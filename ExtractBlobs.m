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

% Get Basic Movie Information
info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

% Pull neuron mask if specified, otherwise set mask to include the whole
% image
if ~exist('mask','var')
    mask = ones(Xdim,Ydim);
end
maskpix = find(mask(:) > 0); % Get pixels to use when looking for blobs

% Pre-allocate variables
cc = cell(1,NumFrames); 
PeakPix = cell(1,NumFrames); 
NumItsTaken = cell(1,NumFrames);

p = ProgressBar(NumFrames); % Initialize progress bar

% Run through each frame and isolate all blobs

[meanframe,stdframe] = moviestats(file);

thresh = 4*mean(stdframe);

parfor i = 1:NumFrames 
    
    % Read in each imaging frame
    tempFrame = loadframe(file,i,info);
%     tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    
    %thresh = 0.04; %median(tempFrame(maskpix)); % Set threshold

    % Detect all blobs that are within the mask by adaptively thresholding
    % each frame
    [cc{i},PeakPix{i},NumItsTaken{i},ThreshList{i}] = SegmentFrame(tempFrame,mask,thresh);
    
    p.progress; % update progress bar    
end

p.stop; % Shut-down progress bar

save Blobs.mat cc mask PeakPix NumItsTaken ThreshList;

end