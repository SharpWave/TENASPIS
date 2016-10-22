function [] = MakeTransients()
% [] = MakeTransients()
%
% Take all of those blobs found in ExtractBlobs.m and figure out, for each
% one, whether there was one on the previous frame that matched it and if
% so which one, thus deducing calcium transients across frames
%
% OUTPUTS:
%
%   NumSegments: total number of valid segments identified from blobs
%
%   NumFrames: total number of frames in the movie
%
%   Xdim, Ydim: x/y size of all the imaging frames
%
%   SegChain: A cell array containing a list of all the transients
%   identified, of the form:
%   SegChain{Transient_number}.{[frame1, object_num1], [frame2, object_num2],...},
%   where object_numx is the object number in the cc variable from
%   ExtractBlobs for frame x.
%
%   max_trans_dist: maximum number of pixels a transient can travel without 
%   being discarded
%
%   TransientLength: length of each corresponding transient from SegChain
%   in frames
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
display('Processing blobs into calcium transient ROIs');

%% load parameters
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

% Load Blob pixel lists and centroids
load('Blobs.mat','BlobPixelIdxList','BlobWeightedCentroids','BlobMinorAxisLength');

% Initialize progress bar
resol = 1; % Percent resolution for progress bar, in this case 10%
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
p = ProgressBar(100/resol);

%% Run through loop to connect blobs between successive frames
for i = 2:NumFrames
  PrevFrame
end
p.stop;
%% Parse Segment data into transients by making sure each segment does not 
% move excessively from start to finish

% Get transient lengths from SegChain
TransientLength = zeros(1,length(SegChain));
for i = 1:length(SegChain)
    TransientLength(i) = length(SegChain{i});
end

% Calculate distance traveled for each transient
DistTrav = TransientStats(SegChain);

% Get transients that move less than the distance threshold
goodstuff = find(DistTrav < max_trans_dist);

% Keep only transients that meet distance traveled criteria
SegChain = SegChain(goodstuff);
NumSegments = length(SegChain);
TransientLength = TransientLength(goodstuff);

save('Transients.mat', 'NumSegments', 'SegChain', 'NumFrames', 'Xdim', 'Ydim', ...
    'max_trans_dist', 'TransientLength')

end

