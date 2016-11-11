function InterpretTraces(Todebug)

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


%% Load relevant variables
% disp('Loading relevant variables from NormTraces and ProcOut')
% load('NormTraces.mat','trace','difftrace','rawtrace');
% load('ProcOut.mat','NumNeurons','NumFrames','FT');

load('SegmentationROIs.mat','NeuronActivity','NumNeurons','NeuronTraces','NeuronPixelIdxList','NeuronAvg');
[Xdim,Ydim,NumFrames,AmplitudeThresholdCoeff,CorrPthresh,MaxGapFillLen] = Get_T_Params('Xdim','Ydim','NumFrames','AmplitudeThresholdCoeff','CorrPthresh','MaxGapFillLen');

blankframe = zeros(Xdim,Ydim,'single');
old = 0.001;

%% For each neuron, find samples where there were either segmentation-identified transients or potential transients
disp('analyzing traces for potential transients');
for i = 1:NumNeurons
    % calculate the amplitude threshold based on the
    % segmentation-identified frames
    Threshold = min(NeuronTraces.LPtrace(i,NeuronActivity(i,:)));
    Threshold = Threshold - abs(Threshold)/3;
    
    % find epochs where the trace was above amplitude threshold
    PosEpochs = NP_FindSupraThresholdEpochs(NeuronTraces.LPtrace(i,:),Threshold);
    PosBool = logical(NeuronTraces.LPtrace(i,:) > Threshold);
    
    % find epochs where the correlation was significant 
    CorrSig = NeuronTraces.CorrR(i,:).*(NeuronTraces.CorrP(i,:)< CorrPthresh);
    % find epochs where the significant correlation is nonzero and overlaps
    % with segmentation-identified activity
    GoodCS = logical(NeuronActivity(i,:).*(CorrSig > 0));
    % set the correlation threshold as the minimum r during these epochs
    CorrThresh = min(CorrSig(GoodCS));
  
    % find epochs above the correlation threshold
    CorrEpochs = NP_FindSupraThresholdEpochs(CorrSig,CorrThresh);
    CorrBool = CorrSig > CorrThresh;
    
    GoodTrBool = false(1,NumFrames);
    
    % identify good correlation epochs that are also above the amplitude
    % threshold for at least 1 frame
    for j = 1:size(CorrEpochs,1)
        % check and see if the amplitude threshold is breached during this
        % epochs, if so, keep it
        if(sum(PosBool(CorrEpochs(j,1):CorrEpochs(j,2))) > 0)
            GoodTrBool(CorrEpochs(j,1):CorrEpochs(j,2)) = true;
        end
    end
    
    % identify small gaps that we can fill in
    ZeroEpochs = NP_FindSupraThresholdEpochs(~GoodTrBool,eps);
    EpLen = ZeroEpochs(:,2)-ZeroEpochs(:,1);
    GoodFill = EpLen <= MaxGapFillLen;
    ZeroEpochs = ZeroEpochs(GoodFill,:);
    
    % fill gaps
    for j = 1:size(ZeroEpochs,1)
        GoodTrBool(ZeroEpochs(j,1):ZeroEpochs(j,2)) = true;
    end
    
    a(1) = subplot(2,6,1:4);
    hold off;
    plot(NeuronTraces.LPtrace(i,:),'-b');hold on;
    plot(NeuronTraces.LPtrace(i,:).*NeuronActivity(i,:),'-k','LineWidth',2);
    plot(NeuronTraces.LPtrace(i,:).*GoodTrBool,'-r','LineWidth',1);
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
        display('pick a time to see the frame')
        [mx,my] = ginput(1)
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
    
%% TO BE INCLUDED IN A BROWSEY VERSION OF THIS    

    
    


keyboard;










%
%
% for n = 1:NumNeurons
%
%     p.progress; % update progress bar
%
%     tr = NeuronTraces.RawTrace(n,:); % Pull trace for neuron n
%     activefr = find(NeuronActivity(n,:)); % Identify active frame indices determined from image segmentation for neuron i
%     for f = activefr
%
%         % If active frame f has already been identified as a positive
%         % transient, continue to next active frame without doing any
%         % calculations below
%         if (PosTr(n,f))
%             continue;
%         end
%
%         % Find forward extent of transient (since trace is z-scored, valid
%         % extent of trace continues as long as the trace is above its mean
%         % value - i.e. trace is above 0)
%         curr = f; % Grab 1st active frame of normalized trace
%         while (tr(curr) > 0) && (curr < NumFrames)
%             curr = curr + 1; % Step through until you don't meet criteria
%         end
%
%         TrEnd = max(curr - 1,f); % Identify frame number at end of trace
%
%         % Find backward extent of transient (trace is above its mean
%         % value)
%         curr = f;
%         while (tr(curr) > 0) && (curr > 1)
%             curr = curr - 1; % Step backward until you don't meet criteria
%         end
%
%         TrStart = min(curr + 1,f); % Identify frame number at start of trace
%
%         PosTr(n,TrStart:TrEnd) = 1; % Set all frames where a positive trace is detected to one
%
%     end
%
%     Epochs = NP_FindSupraThresholdEpochs(PosTr(n,:),eps); % Identify epochs of activity
%     NumTr(n) = size(Epochs,1); % Get number of traces for each neuron
%
%     % Pull out trace information
%     for thisTrace = 1:NumTr(n)
%         TrLength{n}(thisTrace) = Epochs(thisTrace,2)-Epochs(thisTrace,1)+1;                 % Length of trace in frames for neuron n
%         [TrPeakVal{n}(thisTrace),idx] = max(tr(Epochs(thisTrace,1):Epochs(thisTrace,2)));   % The peak value and index for thisTrace of neuron n
%         TrPeakIdx{n}(thisTrace) = idx+Epochs(thisTrace,1)-1;                                % transform frame index within of peak for thisTrace to frame number index
%     end
%
%     % Calculate the smallest peak, largest peak, and average transient
%     % length
%     if (NumTr(n) == 0) % If no transients detected, set values to those below
%         MinPeak(n) = -inf;
%         MaxPeak(n) = -inf;
%         AvgLength(n) = 0;
%     else % If there are transients, actually calculate these values
%         MinPeak(n) = min(TrPeakVal{n});
%         MaxPeak(n) = max(TrPeakVal{n});
%         AvgLength(n) = mean(TrLength{n});
%     end
%
% end
% p.stop;
%
% %% Find potential missed transients
% PrePoPosTr = zeros(NumNeurons,NumFrames); % Initialize
%
% % Identify pre-expansion potential positive transients
% for n = 1:NumNeurons
%     tr = NeuronTraces.RawTrace(n,:); % Get trace
%
%     % Potential transients must a) have trace values above 25% of the
%     % minimum peak detected above, and b) not already be a valid transient
%     PrePoPosTr(n,1:NumFrames) = (tr >= Threshold).*(PosTr(n,:) == 0);
% end
%
% disp('Expanding transients part 2 (identify potential new transients)...');
% p = ProgressBar(NumNeurons);
% for n = 1:NumNeurons
%     tr = trace(n,:);
%     PoPosTr(n,1:NumFrames) = 0;
%     activefr = find(PrePoPosTr(n,:));
%     PoNumTr(n) = 0;
%     for f = activefr
%         if (PoPosTr(n,f))
%             continue;
%         end
%
%         % Find forward extent of transient (intensity above mean value)
%         curr = f;
%
%         while (tr(curr) > 0) && (curr < NumFrames)
%             curr = curr + 1;
%         end
%
%         TrEnd = max(curr - 1,f);
%
%         curr = f;
%
%          % Find backward extent of transient (intensity above mean value)
%         while (tr(curr) > 0) && (curr > 1)
%             curr = curr - 1;
%         end
%
%         TrStart = min(curr + 1,f);
%
%         PoPosTr(n,TrStart:TrEnd) = 1;
%
%     end
%
%     Epochs = NP_FindSupraThresholdEpochs(PoPosTr(n,:),eps);
%     PoNumTr(n) = size(Epochs,1); % Get number of potential transients
%     for thisTrace = 1:PoNumTr(n)
%         PoTrLength{n}(thisTrace) = Epochs(thisTrace,2)-Epochs(thisTrace,1)+1; % Save potential transient length for epoch j
%         [PoTrPeakVal{n}(thisTrace),idx] = max(tr(Epochs(thisTrace,1):Epochs(thisTrace,2))); % ID the peak potential transient value and index in epoch j
%         PoTrPeakIdx{n}(thisTrace) = idx+Epochs(thisTrace,1)-1; % Convert index for peak value from epoch j numbering to frame number
%     end
%
%     p.progress;
% end
% p.stop;
%
% save ExpTransients.mat MaxPeak MinPeak PosTr PoPosTr PrePoPosTr PoTrPeakIdx PoNumTr;
%
% if Todebug
%     for n = 1:NumNeurons
%         plot(FT(n,:)*5);hold on;plot(PosTr(n,:)*5);plot(trace(n,:));plot(zscore(difftrace(n,:)));plot(PoPosTr(n,:),'-r','LineWidth',2);hold off;set(gca,'YLim',[-10 10]);pause;
%     end
% end
%
% end
