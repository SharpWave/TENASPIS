function [] = MergeTransientROIs(varargin)
% [] = MakeROIs(varargin)
%
% Arranges calcium transients into neurons, based on centroid locations
% inputs: varargin - see MakeTransients for 'min_trans_length' variable
% (optional)
%
% outputs: ProcOut.mat
% --------------------------------------
% Variables saved: (breaking this requires major version update)
%
% NumNeurons: final number of neurons
% NeuronImage: bitmap of each neuron roi
% NeuronPixels: list of active pixels for each neuron
% InitPixelList: list of active pixels for each calcium transient
% c: list of which cluster each transient belongs to
% meanX meanY: centroids of neurons
% Xdim Ydim: pixel dimensions of imaging window
% NumFrames: number of frames in the entire movie
% FT: binary matrix of neuron activity identified by segmentation
% VersionString: which release of Tenaspis was used
% cTon: mapping of each transient from SegFrame to its correct neuron
% nToc: mapping of each neuron to its final cluster
%
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
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
MinPixelDist = 0:0.25:6;

NumIterations = 0;
NumCT = length(Trans2ROI);
oldNumCT = NumCT;

% run AutoMergeClu, each time incrementing the distance threshold
% Since clusters start out temporally and spatially independent from one
% another, this loop starts out by merging all the clusters that are very
% close to one another into the same new cluster, then bumping up the
% distance threshold incrementally until no new clusters are created or the
% max distance threshold is reached.
for i = 1:length(MinPixelDist)
    Cchanged = 1;
    oldNumCT = NumCT; % Update number
    while Cchanged == 1
        disp(['Merging neurons, iteration #',num2str(NumIterations+1)])
        
        % Iteratively merge spatially distant clusters together
        [Trans2ROI,PixelIdxList,Xcent,Ycent,FrameList,PixelAvg,BigPixelAvg] = AutoMergeClu(MinPixelDist(i),Trans2ROI,PixelIdxList,Xcent,Ycent,FrameList,PixelAvg,BigPixelAvg,CircMask);
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

[CluToPlot,nToc,cTon] = unique(Trans2ROI); % Get unique clusters and mappings between clusters and neurons
NumNeurons = length(CluToPlot); % Final number of neurons
nClus = length(CluToPlot); % Final number of clusters

% Initialize variables
CurrClu = 0; % Set cluster counter for below
NeuronImage = cell(1,nClus); 
NeuronPixels = cell(1,nClus);
NeuronAvg = cell(1,nClus); 
caltrain = cell(1,nClus); 

% Create neuron mask arrays and calcium transient trans
for i = CluToPlot'
    CurrClu = CurrClu + 1; % Update cluster counter
   
    NeuronPixels{CurrClu} = PixelIdxList{i}(find(PixelAvg{i} > mean_DFF_thresh));
    NeuronImage{CurrClu} = false(Xdim,Ydim);
    NeuronImage{CurrClu}(NeuronPixels{CurrClu}) = 1;
    
    NeuronAvg{CurrClu} = PixelAvg{i}(find(PixelAvg{i} > mean_DFF_thresh));
    caltrain{CurrClu} = zeros(1,NumFrames); % Calicum transient train
    caltrain{CurrClu}(frames{i}) = 1;
end

% Initialize variables
NumTransients = zeros(1,length(caltrain)); 
ActiveFrames = cell(1,length(caltrain)); 

% Deal out calcium train into FT, and get number of transients and frames
% that they are active
for i = 1:length(caltrain)
    FT(i,:) = caltrain{i};
    tempepochs = NP_FindSupraThresholdEpochs(FT(i,:),eps); % Find all epochs when neuron is active or not
    NumTransients(i) = size(tempepochs,1);
    ActiveFrames{i} = find(FT(i,:) > eps);
end

%% Save variables

save_name = 'ProcOut.mat';
save(save_name, 'NeuronImage', 'NeuronPixels', 'Trans2ROI', 'SegROITrBool',  ...
    'MinPixelDist', 'ActiveFrames', 'DistUsed', 'InitPixelList', 'nToc', 'cTon', 'NeuronAvg', 'min_trans_length', '-v7.3');


end
