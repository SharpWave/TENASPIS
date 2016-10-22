function [] = ExtractBlobs(PrepMask)
% [] = ExtractBlobs(file,mask)
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
%% Get parameters and set up Chunking variables
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize','threshold');

ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

%% set up the PrepMask; i.e., which areas to exclude
if ~exist('PrepMask','var')
    PrepMask = ones(Xdim,Ydim);
end

%% Find the blobs in each frame
p = ProgressBar(NumChunks); % Initialize progress bar
BlobPixelIdxList = cell(1,NumFrames);
BlobWeightedCentroids = cell(1,NumFrames);

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames('BPDFF.h5',FrameList);
    
    parfor j = ChunkStarts(i):ChunkEnds(i)
        currFrame = FrameList(j);
        [BlobPixelIdxList{j},BlobWeightedCentroids{j}] = SegmentFrame(squeeze(FrameChunk(:,:,j)),PrepMask);
        
    end
    p.progress;
end

p.stop; % Shut-down progress bar


save Blobs.mat BlobPixelIdxList BlobWeightedCentroids;

end