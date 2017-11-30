function ExtractBlobs(PrepMask)
% ExtractBlobs(PrepMask)
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
global T_MOVIE;
disp('Extracting Blobs from movie');

%% Get parameters and set up Chunking variables
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

%% set up the PrepMask; i.e., which areas to exclude
if ~exist('PrepMask','var')
    PrepMask = ones(Xdim,Ydim);
end

%% Find the blobs in each frame
p = ProgressBar(NumFrames); % Initialize progress bar

%% Distribute chunked outputs to cell arrays
[BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = deal(cell(1,NumFrames));

for i = 1:NumFrames
    Set_T_Params;
    [BlobPixelIdxList{i},BlobWeightedCentroids{i},BlobMinorAxisLength{i}] = NewSegmentFrame(squeeze(T_MOVIE(:,:,i)),PrepMask);
    p.progress;
end
p.stop; % Shut-down progress bar
%% outputs get saved to disk
disp('saving Blobs to disk');
save Blobs.mat BlobPixelIdxList BlobWeightedCentroids BlobMinorAxisLength;

end