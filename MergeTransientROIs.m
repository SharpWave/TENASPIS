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

MinCorr = [10:5:25];

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
NeuronROIidx = unique(Trans2ROI); % Get unique clusters and mappings between clusters and neurons
NumNeurons = length(NeuronROIidx); % Final number of neurons
blankframe = zeros(Xdim,Ydim,'single');

[NeuronPixelIdxList,NeuronImage,NeuronAvg,NeuronFrameList,NeuronObjList] = deal(cell(1,NumNeurons));

NeuronActivity = false(NumNeurons,NumFrames);

for i = 1:NumNeurons
    
    currtran = NeuronROIidx(i);
    NeuronPixelIdxList{i} = PixelIdxList{currtran};
    temp = blankframe;
    temp(NeuronPixelIdxList{i}) = 1;
    NeuronImage{i} = temp;
    [~,idx2] = ismember(NeuronPixelIdxList{i},CircMask{currtran});
    NeuronAvg{i} = BigPixelAvg{currtran}(idx2);
    NeuronFrameList{i} = FrameList{currtran};
    NeuronObjList{i} = ObjList{currtran};
    NeuronActivity(i,NeuronFrameList{i}) = true;
    
    
end

%% Kill off the singletons! (presumed to be noise)
for i = 1:NumNeurons
    temp = NP_FindSupraThresholdEpochs(NeuronActivity(i,:),eps);
    nTrans(i) = size(temp,1);
end

OKcount = nTrans >= MinNumTransients;
NumNeurons = sum(OKcount);

NeuronPixelIdxList = NeuronPixelIdxList(OKcount);
NeuronImage = NeuronImage(OKcount);
NeuronAvg = NeuronAvg(OKcount);
NeuronFrameList = NeuronFrameList(OKcount);
NeuronObjList = NeuronObjList(OKcount);
NeuronROIidx = NeuronROIidx(OKcount);
NeuronActivity = NeuronActivity((OKcount),:);
nTrans = nTrans(OKcount);
Overlaps = Overlaps(find(OKcount),:);
Overlaps = Overlaps(:,find(OKcount));

%NeuronTraces = MakeTracesAndCorrs(NeuronPixelIdxList,NeuronAvg);

disp('saving outputs');
save('SegmentationROIs.mat','NeuronPixelIdxList','NeuronImage','NeuronAvg','NeuronFrameList','NeuronObjList','NeuronROIidx','NumNeurons','NeuronActivity','nTrans','Trans2ROI','Overlaps','-v7.3');


end