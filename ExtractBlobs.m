function ExtractBlobs(PrepMask, sample_rate)
% ExtractBlobs(file, param_file_use)
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

if nargin < 2
    sample_rate = 20;
end

% Old way of customizing Set_T_Params file - keeping for legacy purposes!
% if nargin < 2
%     param_file_use = ''; % Use Set_T_Params as a default.
% end
disp('Extracting Blobs from movie');

%% Get parameters and set up Chunking variables
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

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

parfor i = 1:NumChunks
    Set_T_Params('BPDFF.h5', sample_rate); % needed because SegFrame is called in a parfor and matlab doesn't distribute global variables to workers
%     Set_Custom_T_Params('BPDFF.h5', param_file_use);
    FrameList = ChunkStarts(i):ChunkEnds(i);
       
    BlobChunk(i) = SegmentFrameChunk(FrameList,PrepMask);
    p.progress;
end
p.stop; % Shut-down progress bar

%% Distribute chunked outputs to cell arrays
[BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = deal(cell(1,NumFrames));

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    BlobPixelIdxList(FrameList) = BlobChunk(i).BlobPixelIdxList;
    BlobWeightedCentroids(FrameList) = BlobChunk(i).BlobWeightedCentroids;
    BlobMinorAxisLength(FrameList) = BlobChunk(i).BlobMinorAxisLength;
end

%% outputs get saved to disk
disp('saving Blobs to disk');
save Blobs.mat BlobPixelIdxList BlobWeightedCentroids BlobMinorAxisLength;

end