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
display('merging transient ROIs into neuron ROIs');

%% load parameters
DistanceThresholdList = Get_T_Params('DistanceThresholdList');

%% load data
load('TransientROIs.mat','Trans2ROI','Xcent','Ycent','FrameList','ObjList','PixelAvg','PixelIdxList','BigPixelAvg','CircMask');
NumIterations = 0;
NumCT = length(Trans2ROI);
oldNumCT = NumCT;

% run AutoMergeClu, each time incrementing the distance threshold
% Since clusters start out temporally and spatially independent from one
% another, this loop starts out by merging all the clusters that are very
% close to one another into the same new cluster, then bumping up the
% distance threshold incrementally until no new clusters are created or the
% max distance threshold is reached.
for i = 1:length(DistanceThresholdList)
    Cchanged = 1;
    oldNumCT = NumCT; % Update number
    while Cchanged == 1
        disp(['Merging neurons, iteration #',num2str(NumIterations+1)])
        
        % Iteratively merge spatially distant clusters together
        [Trans2ROI,PixelIdxList,Xcent,Ycent,FrameList,PixelAvg,BigPixelAvg] = AttemptTransientMerges(DistanceThresholdList(i),Trans2ROI,PixelIdxList,Xcent,Ycent,FrameList,PixelAvg,BigPixelAvg,CircMask);
        NumIterations = NumIterations+1; % Update number of iterations
        NumClu(NumIterations) = length(unique(c)); % Update number of clusters
        DistUsed(NumIterations) = MinPixelDist(i); % Updated distance threshold used
        
        if (NumClu(NumIterations) == oldNumCT) 
            % If you end up with the same number of clusters as the previous iteration, exit
            break;
        else
            % Save number of clusters
            oldNumCT = NumClu(NumIterations);
        end
    end
end

%% Unpack the variables calculated above

NeuronROIidx = unique(Trans2ROI); % Get unique clusters and mappings between clusters and neurons
NumNeurons = length(NeuronROIidx); % Final number of neurons
nClus = length(CluToPlot); % Final number of clusters



end