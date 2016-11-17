function [] = InterpretTraces(Todebug)
% function [] = InterpretTraces(Todebug)
%
% This takes the output of MergeTransientROIs and creates a best-guess
% estimate of when the neurons in the ROIs had calcium transients. An
% outline of the procedure is below.
%
% A. Decide when calcium transients are present in each ROI, using:
%   1) average value of pixels in each segmentation-identified ROI
%   2) fluorescence traces: mean intensity in each ROI for each frame
%       - use amplitude to identify times when there may be a transient
%   3) correlation r between those average pixel values and each frame of the movie
%       - establishes a baseline correlation from segmentation transients,
%         and determines whether transients identified via amplitude are
%         OK or not based on whether the correlation is significant and sufficiently high
%
% B. Determine the rising slope(s) of each transient identified in A
%   - putative spiking activity occurs during rising phase of calcium
%     transients
%
% C. Eliminate transients that overlap in space and time
%   - spatiotemporally overlapping transients suggest under-merged ROIs
%   - "wrong" ROI should have lower amplitude
%   - potentially eliminate under-merged ROIs
%   - only eliminates overlapping positive slopes; overlapping neurons can
%   be active in quick succession despite long decay of gCamp
%
% D. Remove ROIs with less than 2 transients from the data
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
%
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set up variables and load data
if (~exist('Todebug','var'))
    Todebug = 0;
end

load('SegmentationROIs.mat','NeuronActivity','NumNeurons','NeuronTraces','NeuronPixelIdxList','NeuronAvg','NeuronFrameList','NeuronImage','NeuronObjList','NeuronROIidx','Trans2ROI');
[Xdim,Ydim,NumFrames,AmplitudeThresholdCoeff,CorrPthresh,MaxGapFillLen,SlopeThresh,MinBinSimRank,ROIoverlapthresh,MinPSALen,MinNumPSAepochs] = ...
    Get_T_Params('Xdim','Ydim','NumFrames','AmplitudeThresholdCoeff','CorrPthresh','MaxGapFillLen','SlopeThresh','MinBinSimRank','ROIoverlapthresh','MinPSALen','MinNumPSAepochs');

blankframe = zeros(Xdim,Ydim,'single');
PSAbool = false(NumNeurons,NumFrames);

%% PART A %%%%%%%%%%%%%%%%%%%

%% determine overlapping ROIs
disp('calculating overlapping ROIs');

ROIoverlap = false(NumNeurons,NumNeurons);
ROIpct = zeros(NumNeurons,NumNeurons,'single');
for i = 1:NumNeurons
    for j = i+1:NumNeurons
        if(~isempty(intersect(NeuronPixelIdxList{i},NeuronPixelIdxList{j})))
            ROIoverlap(i,j) = true;
            ROIoverlap(j,i) = true;
            ROIpct(i,j) = length(intersect(NeuronPixelIdxList{i},NeuronPixelIdxList{j}))/min(length(NeuronPixelIdxList{i}),length(NeuronPixelIdxList{j}));
            ROIpct(j,i) = ROIpct(i,j);
        end
    end
end

%% For each neuron, find samples where there were either segmentation-identified transients or potential transients
disp('analyzing traces for potential transients');
for i = 1:NumNeurons
    % calculate the amplitude threshold based on the
    % segmentation-identified frames
    %i = ceil(rand*NumNeurons);
    Threshold = min(NeuronTraces.LPtrace(i,NeuronActivity(i,:)));
    Threshold = Threshold - abs(Threshold)*AmplitudeThresholdCoeff;
    
    % find epochs where the trace was above amplitude threshold
    PosBool = logical(NeuronTraces.LPtrace(i,:) > Threshold);
    
    % find epochs where the correlation was significant
    CorrSig = NeuronTraces.CorrR(i,:).*(NeuronTraces.CorrP(i,:)< CorrPthresh);
    % find epochs where the significant correlation is nonzero and overlaps
    % with segmentation-identified activity
    GoodCS = logical(NeuronActivity(i,:).*(CorrSig > 0));
    
    if (sum(GoodCS) == 0)
        continue;
    end
    
    % set the correlation threshold as the minimum r during these epochs
    CorrThresh = min(CorrSig(GoodCS));
    
    % find epochs above the correlation threshold
    CorrEpochs = NP_FindSupraThresholdEpochs(CorrSig,CorrThresh);
        
    % identify good correlation epochs that are also above the amplitude
    % threshold for at least 1 frame
    GoodTrBool = false(1,NumFrames);
    for j = 1:size(CorrEpochs,1)
        % check and see if the amplitude threshold is breached during this
        % epochs, if so, keep it
        if(sum(PosBool(CorrEpochs(j,1):CorrEpochs(j,2))) > 0)
            GoodTrBool(CorrEpochs(j,1):CorrEpochs(j,2)) = true;
        end
    end
    
    % identify small gaps that we can fill in
    ZeroEpochs = NP_FindSupraThresholdEpochs(~GoodTrBool,eps);
    EpLen = ZeroEpochs(:,2)-ZeroEpochs(:,1)+1;
    GoodFill = EpLen <= MaxGapFillLen;
    ZeroEpochs = ZeroEpochs(GoodFill,:);
    
    % fill gaps
    for j = 1:size(ZeroEpochs,1)
        GoodTrBool(ZeroEpochs(j,1):ZeroEpochs(j,2)) = true;
    end
    
    % Part B: detect positive slopes
    InSlope = false;
    SlopeTr = NeuronTraces.DFDTtrace(i,:);
    for j = 1:NumFrames
        if (InSlope)
            % check if fluoresence slope is still postive
            if ((SlopeTr(j) > 0) && (GoodTrBool(j)))
                PSAbool(i,j) = true;
            else
                InSlope = false;
            end
        else
            % not currently in a slope
            if (GoodTrBool(j))
                if (SlopeTr(j) >= SlopeThresh)
                    % new slope
                    InSlope = true;
                    PSAbool(i,j) = true;
                    % check if we can go backward to beginning of positive
                    % slope (ok even if not ok correlation)
                    BackCheck = j-1;
                    while((SlopeTr(BackCheck) > SlopeThresh) && (BackCheck >= 2))
                        PSAbool(i,BackCheck) = true;
                        BackCheck = BackCheck - 1;
                    end
                end
            end
        end
    end
    
    %% plotting (optional)
    if (Todebug)
        a(1) = subplot(2,6,1:4);
        hold off;
        plot(NeuronTraces.LPtrace(i,:),'-b');hold on;
        plot(NeuronTraces.LPtrace(i,:).*NeuronActivity(i,:),'-k','LineWidth',2);
        plot(NeuronTraces.LPtrace(i,:).*GoodTrBool,'-r','LineWidth',1);
        plot(NeuronTraces.LPtrace(i,:).*PSAbool(i,:),'-g','LineWidth',1);
        axis tight;
        a(2) = subplot(2,6,7:10);
        hold off;
        plot(CorrSig,'-m');
        hold on;plot(CorrSig.*(CorrSig > CorrThresh));axis tight;hold off;
        
        linkaxes(a,'x');
        
        subplot(2,6,11);histogram(NeuronTraces.CorrR(i,NeuronActivity(i,:)),(-1:0.05:1));title(num2str(CorrThresh));
        subplot(2,6,5);histogram(NeuronTraces.LPtrace(i,NeuronActivity(i,:)),(0:0.005:0.2));
        pause;
        ToGo = 'y';
        while(strcmpi(ToGo,'y'))
            disp('pick a time to see the frame')
            [mx,~] = ginput(1);
            f = LoadFrames('BPDFF.h5',ceil(mx));
            b(1) = subplot(2,6,6);imagesc(f);axis image;
            caxis([0 max(f(NeuronPixelIdxList{i}))]);
            tempf = blankframe;
            tempf(NeuronPixelIdxList{i}) = NeuronAvg{i};
            b(2) = subplot(2,6,12);imagesc(tempf);axis image;
            linkaxes(b);
            ToGo = input('do another frame? [y/n] -->','s');
        end
    end
end

%% B2: Find ROIs that should have been merged but weren't
% basic theory: if two ROIs created in segmentation are so close that they
% yield outputs that are closer than statistically likely, they are
% indistinguishable and should be merged

% calculate binary similarity metric
disp('calculating ROI activity similarity');
BinSim = zeros(NumNeurons,NumNeurons,'single');
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    for j = 1:NumNeurons
        exhits = round(sum(PSAbool(i,:))*sum(PSAbool(j,:))/NumFrames);
        if (sum(PSAbool(i,:) & PSAbool(j,:)) > exhits)
            BinSim(i,j) = (sum(PSAbool(i,:) & PSAbool(j,:))-exhits)/(min(sum(PSAbool(i,:)),sum(PSAbool(j,:)))-exhits);
        else
            if (exhits > 0)
                BinSim(i,j) = (sum(PSAbool(i,:) & PSAbool(j,:))-exhits)/(exhits);
            else
                BinSim(i,j) = 0;
            end
        end
        if (i == j)
            BinSim(i,j) = 0;
        end
    end
    p.progress;
end
p.stop;

disp('calculating whether overlapping ROIs have more similar PSA than expected');
% determine how likely similarity metrics are compared to non-adjacent
% population
BadNeighbors = cell(1,NumNeurons);
for i = 1:NumNeurons
    Neighbors = find(ROIpct(i,:) > ROIoverlapthresh);
    
    if (isempty(Neighbors))
        continue;
    end
    
    NeighborSim = BinSim(i,Neighbors);
    
    FarSims = sort(BinSim(i,ROIoverlap(i,:) == 0));
    BinSimRank = zeros(1,length(Neighbors));
    
    for j = 1:length(NeighborSim)
        idx = findclosest(NeighborSim(j),FarSims);
        BinSimRank(j) = idx/length(FarSims);
    end
    
    BadNeighbors{i} = Neighbors(BinSimRank >= MinBinSimRank);
    
end

disp('merging ROIs that are practically indistinguishable')

% make a list of where each row lives now (by default, its own index)
ROIhome = 1:NumNeurons;
NumMerges = 0;
% for each neuron i
for i = 1:NumNeurons
    % for each nasty neighbor j: Overlap over 50% and BinSim rank over 94
    for j = 1:length(BadNeighbors{i})
        % find actual location of ROI
        idx1 = i;
        while(ROIhome(idx1) ~= idx1)
            idx1 = ROIhome(idx1);
        end
        
        idx2 = BadNeighbors{i}(j);
        while(ROIhome(idx2) ~= idx2)
            idx2 = ROIhome(idx2);
        end
        
        % determine who has more transients (counting ones added in clustering)
        Temp1 = NP_FindSupraThresholdEpochs(PSAbool(idx1,:),eps);
        Temp2 = NP_FindSupraThresholdEpochs(PSAbool(idx2,:),eps);
        if (size(Temp1,1) > size(Temp2,1))
            target = idx1;
            ball = idx2;
        else
            target = idx2;
            ball = idx1;
        end
        
        PSAbool(target,:) = PSAbool(target,:) | PSAbool(ball,:);
        PSAbool(ball,:) = false;
        ROIhome(ball) = target;
        NumMerges = NumMerges+1;
    end
end

disp([int2str(NumMerges),' ROIs eliminated via merging']);

%% B3: fill gaps again

for i = 1:NumNeurons
    ZeroEpochs = NP_FindSupraThresholdEpochs(~PSAbool(i,:),eps);
    EpLen = ZeroEpochs(:,2)-ZeroEpochs(:,1)+1;
    GoodFill = EpLen <= MaxGapFillLen;
    ZeroEpochs = ZeroEpochs(GoodFill,:);
    
    % fill gaps
    for j = 1:size(ZeroEpochs,1)
        PSAbool(i,ZeroEpochs(j,1):ZeroEpochs(j,2)) = true;
    end
end

%% Part D: Kill the flimsy ROIs  - remove PSA epochs shorter than MinPSALen
NumActs = zeros(1,NumNeurons);
AllPSALen = [];
actlist = cell(1,NumNeurons);
for i = 1:NumNeurons
    if (~isempty(actlist{i}))
        
        PSALen = (actlist{i}(:,2)-actlist{i}(:,1))+1;
        AllPSALen = [AllPSALen;PSALen];
        for j = 1:size(actlist{i},1)
            if (PSALen(j) < MinPSALen)
                PSAbool(i,actlist{i}(j,1):actlist{i}(j,2)) = false;
            end
        end
    end
    actlist{i} = NP_FindSupraThresholdEpochs(PSAbool(i,:),eps);
    NumActs(i) = size(actlist{i},1);
end

%% C. eliminate spatiotemporal overlaps
disp('eliminating spatiotemporal overlaps');

p = ProgressBar(NumNeurons);

for i = 1:NumNeurons
    Neighbors = find(ROIoverlap(i,:));
    for j = 1:size(actlist{i},1)
        % do any neighbors have an epoch that starts or ends during this
        % one?
        actframes = (actlist{i}(j,1):actlist{i}(j,2));
        nList = [];
        epList = [];
        meanDffList = [];
        for k = 1:length(Neighbors)
            nIdx = Neighbors(k);
            for m = 1:size(actlist{nIdx})
                if (ismember(actlist{nIdx}(m,1),actframes) || ismember(actlist{nIdx}(m,2),actframes))
                    % neuron nIdx epoch m overlaps with neuron i epoch j
                    nList = [nList,nIdx];
                    epList = [epList,m];
                    meanDffList = [meanDffList,mean(NeuronTraces.LPtrace(nIdx,actlist{nIdx}(m,1):actlist{nIdx}(m,2)))];
                end
            end
        end
        
        if (isempty(nList))
            continue;
        end
        
        TijMeanDFF = mean(NeuronTraces.LPtrace(i,actlist{i}(j,1):actlist{i}(j,2)));
        
        nList = [i,nList];
        epList = [j,epList];
        meanDFFList = [TijMeanDFF,meanDffList];
        [~,maxidx] = max(meanDFFList);
        
        for k = 1:length(nList)
            if ((k == maxidx) || (nList(k) == nList(maxidx)))
                continue;
            end
            
            % kill the epoch
            PSAbool(nList(k),actlist{nList(k)}(epList(k),1):actlist{nList(k)}(epList(k),2)) = false;
            if (nList(k) ~= i)
                actlist{nList(k)} = NP_FindSupraThresholdEpochs(PSAbool(nList(k),:),eps);
            end
        end
    end
    actlist{i} = NP_FindSupraThresholdEpochs(PSAbool(i,:),eps);
    p.progress;
end
p.stop;

for i = 1:NumNeurons
    NumActs(i) = size(actlist{i},1);
end

ActOK = NumActs >= MinNumPSAepochs;

% 'NeuronActivity','NumNeurons','NeuronTraces','NeuronPixelIdxList','NeuronAvg','NeuronFrameList','NeuronImage','NeuronObjList','NeuronROIidx','Trans2ROI');
NeuronActivity = NeuronActivity(ActOK);
NeuronPixelIdxList = NeuronPixelIdxList(ActOK);
NeuronFrameList = NeuronFrameList(ActOK);
NeuronImage = NeuronImage(ActOK);
NeuronObjList = NeuronObjList(ActOK);
NeuronROIidx = NeuronROIidx(ActOK);

PSAbool = PSAbool(ActOK,:);
disp('averaging ROIs over the movie');
NeuronAvg = PixelSetMovieAvg(PSAbool,NeuronPixelIdxList);

NumNeurons = sum(ActOK);

NeuronTraces.RawTrace = NeuronTraces.RawTrace(ActOK,:);
NeuronTraces.LPtrace = NeuronTraces.LPtrace(ActOK,:);
NeuronTraces.DFDTtrace = NeuronTraces.DFDTtrace(ActOK,:);
NeuronTraces.CorrR = NeuronTraces.CorrR(ActOK,:);
NeuronTraces.CorrP = NeuronTraces.CorrP(ActOK,:);

save('FinalOutput.mat','NeuronActivity','NumNeurons','NeuronTraces','NeuronPixelIdxList','NeuronAvg','NeuronFrameList','NeuronImage','NeuronObjList','NeuronROIidx','Trans2ROI','PSAbool','BinSim');


