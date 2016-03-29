function [] = MakeTransients(varargin)
% [] = MakeTransients(varargin)
%
% Take all of those blobs found in ExtractBlobs.m and figure out, for each
% one, whether there was one on the previous frame that matched it and if
% so which one, thus deducing calcium transients across frames
%
% varargins:
%
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
%
%% Calcium transient inclusion criteria
max_trans_dist = 2; % (default) maximum number of pixels a transient can travel without being discarded

% Load pertinent blob variables
load ('Blobs.mat','cc','PeakPix');

% Get basic movie info
info = h5info('DFF.h5','/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

% Initialize variables
NumSegments = 0;
SegChain = [];
SegList = zeros(NumFrames,100);

% Initialize progress bar
p = ProgressBar(NumFrames); 

%% Run through loop to connect blobs between successive frames
for i = 2:NumFrames
    stats = regionprops(cc{i},'MinorAxisLength'); % Assuming each neuron can be approximated by an ellipse, get the minor axis length
    Peaks = PeakPix{i}; % Grab peak pixel locations
    OldPeaks = PeakPix{i-1}; % Grab peak pixel locations from previous frame
    for j = 1:cc{i}.NumObjects
        % find match between blob j and all blobs from the previous frame
        [MatchingSeg,~] = MatchSeg(Peaks{j},OldPeaks,SegList(i-1,:),...
            stats(j).MinorAxisLength);
 
        if (MatchingSeg == 0)
            % no match found, make a new segment
            NumSegments = NumSegments+1;
            SegChain{NumSegments} = {[i,j]};
            SegList(i,j) = NumSegments;
        else
            % a match was found, add to segment
            SegChain{MatchingSeg} = [SegChain{MatchingSeg},{[i,j]}];
            SegList(i,j) = MatchingSeg;
        end
    end

    p.progress;
end
p.stop;
%%

TransientLength = zeros(1,length(SegChain));
for i = 1:length(SegChain)
    TransientLength(i) = length(SegChain{i});
end

DistTrav = TransientStats(SegChain);

gooddist = find(DistTrav < max_trans_dist);

SegChain = SegChain(gooddist);
NumSegments = length(SegChain);
TransientLength = TransientLength(gooddist);

save('Transients.mat', 'NumSegments', 'SegChain', 'NumFrames', 'Xdim', 'Ydim', 'max_trans_dist','TransientLength')

end

