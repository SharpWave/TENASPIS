function [] = MergeTransientROIs()
% [] = MergeTransientROIs()
% Merges calcium transient ROIs into neuron ROIs

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
%
disp('merging transient ROIs into neuron ROIs');

%% load parameters
[DistanceThresholdList,Xdim,Ydim,NumFrames,ROIBoundaryCoeff,MinNumTransients] = Get_T_Params('DistanceThresholdList','Xdim','Ydim','NumFrames','ROIBoundaryCoeff','MinNumTransients');

%% load data
load('UngarbagedROIs.mat','Trans2ROI','Xcent','Ycent','FrameList','ObjList','PixelAvg','PixelIdxList','BigPixelAvg','CircMask','Overlaps');
load('BlobLinks.mat','BlobPixelIdxList');
NumIterations = 0;
NumCT = length(Trans2ROI);

MinCorr = [15:5:40];

% try to merge transient clusters, starting with a high threshold for
% gradient similarity and then lowering the threshold
go = 1;
for j = 1:length(MinCorr)
    while(go == 1)
        disp(['Merging neurons, iteration #',num2str(NumIterations+1),' min angular standard deviation: ',num2str(MinCorr(j))])
        
        % Iteratively merge spatially distant clusters together
        [Overlaps,Trans2ROI,PixelIdxList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg] = AttemptTransientMerges(Overlaps,MinCorr(j),Trans2ROI,PixelIdxList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg,CircMask,BlobPixelIdxList);
        NumIterations = NumIterations+1; % Update number of iterations
        oldNumCT = NumCT;
        NumCT = length(unique(Trans2ROI));
        if (oldNumCT == NumCT)
            break;
        end
    end
end

%% Unpack the variables calculated above
disp('Final ROI refinement');
ROIidx = unique(Trans2ROI); % Get unique clusters and mappings between clusters and neurons
NumROIs = length(ROIidx); % Final number of neurons
blankframe = zeros(Xdim,Ydim,'single');

[tempPixelIdxList,tempFrameList,tempObjList,GoodPeakAvg,GoodPeaks] = deal(cell(1,NumROIs));

IsTransientPeak = false(NumROIs,NumFrames);
LPtrace = zeros(NumROIs,NumFrames);
convwin = ones(1,2)/2;

p = ProgressBar(NumROIs);

global T_MOVIE;

for i = 1:NumROIs    
    currtran = ROIidx(i);
    tempPixelIdxList{i} = PixelIdxList{currtran};    
    tempFrameList{i} = FrameList{currtran};
    tempObjList{i} = ObjList{currtran};   
    
    IsTransientPeak(i,tempFrameList{i}) = true;
    %GoodPeakAvg{i} = mean(T_MOVIE(:,:,tempFrameList{i}),3);
    
    [xidx,yidx] = ind2sub([Xdim Ydim],tempPixelIdxList{i});
    temptrace = mean(T_MOVIE(xidx,yidx,1:NumFrames),1);    
    temptrace = squeeze(mean(temptrace));
    LPtrace(i,:) = convtrim(temptrace,convwin);
    
    PeakEpoch = NP_FindSupraThresholdEpochs(IsTransientPeak(i,:),eps);
    for j = 1:size(PeakEpoch,1)
        [~,tempidx] = max(LPtrace(i,PeakEpoch(j,1):PeakEpoch(j,2)));
        GoodPeaks{i}(j) = tempidx+PeakEpoch(j,1)-1;
    end
    tempPixelIdxList{i} = RecalcROI(tempPixelIdxList{i},GoodPeaks{i});
    
    p.progress;
end
p.stop;
PixelIdxList = tempPixelIdxList;
FrameList = tempFrameList;
ObjList = tempObjList;

disp('saving outputs');
save('SegmentationROIs.mat','PixelIdxList','GoodPeakAvg','FrameList','ObjList','ROIidx','NumROIs','IsTransientPeak','Trans2ROI','LPtrace','GoodPeaks','-v7.3');


end