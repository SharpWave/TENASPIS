function [] = MakeNeurons(varargin)
% [] = MakeNeurons(varargin)
%
% Arranges calcium transients into neurons, based on centroid locations
% inputs: varargin - see MakeTransients for 'min_trans_length' variable
% (optional)
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
% FT: binary neuron activity matrix
% VersionString: which release of Tenaspis was used
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

VersionString = '0.9.0.0-beta';
MinPixelDist = 0.1:1:5

close all;
if min_trans_length == 5
    load_name = 'Segments.mat';
    initclu_name = 'InitClu.mat';
else
    load_name = ['Segments_minlength_' num2str(min_trans_length) '.mat'];
    initclu_name = ['InitClu_minlength_' num2str(min_trans_length) '.mat'];
end
load(load_name) %NumSegments SegChain cc NumFrames Xdim Ydim --- not loading and passing here breaks parallelization

if (exist(initclu_name,'file') == 0)
    InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim, min_trans_length);
end

load(initclu_name); %c Xdim Ydim PixelList Xcent Ycent frames meanareas meanX meanY NumEvents cToSeg
NumIterations = 0;
NumCT = length(c);
oldNumCT = NumCT;
InitPixelList = PixelList;

% run AutoMergeClu, each time incrementing the distance threshold
for i = 1:length(MinPixelDist)
    Cchanged = 1;
    oldNumCT = NumCT;
    while (Cchanged == 1)
        [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,CluDist] = AutoMergeClu(MinPixelDist(i),c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames);
        NumIterations = NumIterations+1;
        NumClu(NumIterations) = length(unique(c));
        DistUsed(NumIterations) = MinPixelDist(i);

        if (NumClu(NumIterations) == oldNumCT)
            break;
        else
            oldNumCT = NumClu(NumIterations);
        end
    end
end

% OK now unpack these things
CurrClu = 0;
[CluToPlot,nToc,cTon] = unique(c);
NumNeurons = length(CluToPlot);

for i = CluToPlot'
    CurrClu = CurrClu + 1;
    NeuronImage{CurrClu} = logical(zeros(Xdim,Ydim));
    NeuronImage{CurrClu}(PixelList{i}) = 1;
    NeuronPixels{CurrClu} = PixelList{i};
    caltrain{CurrClu} = zeros(1,NumFrames);
    caltrain{CurrClu}(frames{i}) = 1;
end

for i = 1:length(caltrain)
    FT(i,:) = caltrain{i};
    tempepochs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    NumTransients(i) = size(tempepochs,1);
    ActiveFrames{i} = find(FT(i,:) > eps);
end

try % Error catching clause: larger files are failing here for some reason
    figure;
    PlotNeuronOutlines(InitPixelList,Xdim,Ydim,cTon)
    figure;
    plotyy(1:length(NumClu),NumClu,1:length(NumClu),DistUsed);
catch
    disp('Error plotting Neuron outlines - Run PlotNeuronOutlines manually if you wish to see them')
end

%[MeanBlobs,AllBlob] = MakeMeanBlobs(ActiveFrames,c);

if min_trans_length == 5
    save ProcOut.mat NeuronImage NeuronPixels NumNeurons c Xdim Ydim FT NumFrames NumTransients MinPixelDist DistUsed InitPixelList VersionString GoodTrs nToc cTon min_trans_length -v7.3;
else
    save_name = ['Procout_minlength_' num2str(min_trans_length) '.mat'];
    save(save_name, 'NeuronImage', 'NeuronPixels', 'NumNeurons', 'c', 'Xdim', 'Ydim', 'FT', 'NumFrames', 'NumTransients', ...
        'MinPixelDist', 'DistUsed', 'InitPixelList', 'VersionString', 'GoodTrs', 'nToc', 'cTon', 'min_trans_length', '-v7.3');
end

end

