function MakeNeurons(varargin)
% MakeNeurons(varargin)
%
% Arranges calcium transients into neurons, based on centroid locations
% inputs: varargin - see MakeTransients for 'min_trans_length' variable
% (optional)
%
% outputs: ProcOut.mat
% --------------------------------------
% Variables saved: (breaking this requires major version update)
%
%   NeuronImage: bitmap of each neuron roi
%
%   NeuronPixels: list of active pixels for each neuron
%
%   NumNeurons: number of neurons
%
%   c: list of which cluster each transient belongs to
%
%   meanX meanY: centroids of neurons
%
%   Xdim Ydim: pixel dimensions of imaging window
%
%   FT: binary matrix of neuron activity identified by segmentation
%
%   NumFrames: number of frames in the entire movie
%
%   NumTransients: number of transients each neuron had
%
%   MinPixelDist: vector of allowable distances for calling clusters the
%   same neuron
%
%   DistUsed: distance used from MinPixelDist for each iteration of
%   AutoMergeClu
%
%   InitPixelList: list of active pixels for each calcium transient
%
%   nToc: mapping of each neuron to its final cluster
%
%   cTon: mapping of each transient from SegFrame to its correct neuron
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

%% Process varargins
min_trans_length = 5; % default: minimum number of frames a transient must last in order to be included

for j = 1:length(varargin)
    if strcmpi(varargin{j},'min_trans_length')
        min_trans_length = varargin{j+1};
    end
end

%% 
% Possible thresholds for merging clusters. 
MinPixelDist = 0:0.25:6;

close all;

% Load relevant variables
disp('Loading relevant variables')
load('Blobs.mat','PeakPix','cc');
load('Transients.mat','TransientLength','SegChain','NumFrames','Xdim','Ydim') %NumSegments SegChain cc NumFrames Xdim Ydim --- not loading and passing here breaks parallelization

% Identify good segments that are longer than the minimum transient length
goodseg = find(TransientLength >= min_trans_length);
SegChain = SegChain(goodseg);
NumSegments = length(SegChain);

% Intialize "clusters", which are segments that have been pared down a bit
% to their average size/shape across all their active frames and grouped
% together.  End result is groups
if ~exist(fullfile(pwd,'InitClu.mat'),'file'); 
    InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim, ...
        PeakPix, min_trans_length);
end

%% Run AutoMergeClu. 
load InitClu.mat; % Load initialized cluster data
NumIterations = 0;
NumCT = length(c);
oldNumCT = NumCT;
InitPixelList = PixelList;

% run AutoMergeClu, each time incrementing the distance threshold
% Since clusters start out temporally and spatially independent from one
% another, this loop starts out by merging all the clusters that are very
% close to one another into the same new cluster, then bumping up the
% distance threshold incrementally until no new clusters are created or the
% max distance threshold is reached.
for pixDist = MinPixelDist
    Cchanged = 1;
    oldNumCT = NumCT; % Update number
    while Cchanged
        disp(['Merging neurons, iteration #',num2str(NumIterations+1)])
        
        % Iteratively merge spatially distant clusters together
        [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,~,PixelAvg] = ...
            AutoMergeClu(pixDist,c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,PixelAvg);
        NumIterations = NumIterations+1;            % Update number of iterations
        NumClu(NumIterations) = length(unique(c));  % Update number of clusters
        DistUsed(NumIterations) = pixDist;          % Updated distance threshold used
        
        % If you end up with the same number of clusters as the previous iteration, exit
        if (NumClu(NumIterations) == oldNumCT) 
            break;
        else
            % Save updated number of clusters
            oldNumCT = NumClu(NumIterations);
        end
    end
end

%% Unpack the variables calculated above

[CluToPlot,nToc,cTon] = unique(c);  % Get unique clusters and mappings between clusters and neurons
%nToc = Neuron to cluster, which neuron does this cluster correspond to?
%cTon = Cluster to neuron, which cluster does this neuron corerspond to? 

NumNeurons = length(CluToPlot);     % Final number of neurons.

% Initialize variables
CurrClu = 0;                        % Set cluster counter for below
NeuronImage = cell(1,NumNeurons); 
NeuronPixels = cell(1,NumNeurons); 
caltrain = cell(1,NumNeurons); 

% Create neuron mask arrays and calcium transient trains.
for thisCluster = CluToPlot'
    CurrClu = CurrClu + 1;                              % Update cluster counter
    
    % Neuron mask
    NeuronImage{CurrClu} = false(Xdim,Ydim);            
    NeuronImage{CurrClu}(PixelList{thisCluster}) = 1;   
    
    % Neuron mask pixel indices
    NeuronPixels{CurrClu} = PixelList{thisCluster};     
    
    % Calcium transient train
    caltrain{CurrClu} = zeros(1,NumFrames);             
    caltrain{CurrClu}(frames{thisCluster}) = 1;
end

% Initialize variables
NumTransients = zeros(1,length(caltrain)); 
ActiveFrames = cell(1,length(caltrain)); 

% Deal out calcium train into FT, and get number of transients and frames
% that they are active
for thisNeuron = 1:NumNeurons
    FT(thisNeuron,:) = caltrain{thisNeuron};
    tempepochs = NP_FindSupraThresholdEpochs(FT(thisNeuron,:),eps); % Find all epochs when neuron is active or not
    NumTransients(thisNeuron) = size(tempepochs,1);
    ActiveFrames{thisNeuron} = find(FT(thisNeuron,:) > eps);
end

%% Plot All neurons
%disp('Plotting neuron outlines')
%try % Error catching clause: larger files are failing here for some reason
    
    % Plot all neurons and transients
    %figure;
    %PlotNeuronOutlines(InitPixelList,Xdim,Ydim,cTon,NeuronImage);
    
    % Plot iteration, cluster, and distance threshold info
    %figure;
    %[hax, ~, ~] = plotyy(1:length(NumClu),NumClu,1:length(NumClu),DistUsed);
    %xlabel('Iteration Number')
    %ylabel(hax(1),'Number of Clusters'); ylabel(hax(2),'Distance Threshold Used (pixels)')
    
%catch % Error catching clause
    %disp('Error plotting Neuron outlines - Run PlotNeuronOutlines manually if you wish to see them')
%end

%% Save variables

%[MeanBlobs,AllBlob] = MakeMeanBlobs(ActiveFrames,c);

save_name = 'ProcOut.mat';
save(save_name, 'NeuronImage', 'NeuronPixels', 'NumNeurons', 'c', 'Xdim', ...
    'Ydim', 'FT', 'NumFrames', 'NumTransients','MinPixelDist', 'DistUsed', ...
    'InitPixelList', 'nToc', 'cTon', 'min_trans_length', '-v7.3');


end
