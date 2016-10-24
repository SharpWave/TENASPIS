function [] = ExtractBlobs(file,mask)
% [] = ExtractBlobs(file,mask)
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
% extract active cell "blobs" from movie in file
% mask is the binary mask of which areas to use and not to use
% use MakeBlobMask to make a mask

%FrameChunkSize = 1000; % how many frames to load at a time;


% Get Basic Movie Information
info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

%NumFrames = 5000; %%%%%%%%%%%%%%%%%%TESTING ONLY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FrameChunkSize = 1250;
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts)
% Pull neuron mask if specified, otherwise set mask to include the whole
% image
if ~exist('mask','var')
    mask = ones(Xdim,Ydim);
end
maskpix = find(mask(:) > 0); % Get pixels to use when looking for blobs

% Pre-allocate variables
cchunk = cell(1,NumChunks);
pchunk = cell(1,NumChunks);

cc = cell(1,NumFrames); 
PeakPix = cell(1,NumFrames); 
NumItsTaken = cell(1,NumFrames);
ThreshList = cell(1,NumFrames);

p = ProgressBar(NumFrames); % Initialize progress bar

% Run through each frame and isolate all blobs

thresh = 0.01;

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames('SLPDF.h5',FrameList,info);
    tempcc = [];
    tempPeakPix = [];
    NumChunkFrames = length(FrameList);
    tempcc = cell(1,NumChunkFrames);
    tempPeakPix = cell(1,NumChunkFrames);
    parfor j = 1:NumChunkFrames
      currFrame = FrameList(j);  
      [tempcc{j},tempPeakPix{j}] = SegmentFrame2(squeeze(FrameChunk(:,:,j)),mask,thresh); 
       p.progress;
    end
    cc(FrameList) = tempcc;
    PeakPix(FrameList) = tempPeakPix;
     % update progress bar    
end

p.stop; % Shut-down progress bar


save Blobs.mat cc mask PeakPix thresh;

end