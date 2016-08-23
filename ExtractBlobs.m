function [] = ExtractBlobs(moviefile,mask,varargin)
% ExtractBlobs(moviefile,mask)
%
%   Extracts active neurons from "blob" images in movie frames. 
%
%   INPUTS
%       moviefile: movie file (currently supports h5). 
%
%       mask: Logical matrix with same dimensions as movie frame specifying
%       which areas to use and which not to use. 
%
%   OUTPUT variables in Blobs.mat
%       cc: 1xF (F = # of frames) structure containing relevant data on the
%       discovered blobs.
%           fields...
%               NumObjects, number of blobs.
%               ImageSize, frame dimensions.
%               Connectivity, 4.
%
%       mask: same as input.
%
%       PeakPix: 1xF cell array with nested 1xN (N = # of blobs detected
%       that frame) cell array containing a 2-element vector, the XY
%       coordinates of the peak pixel of that blob on that frame.
%
%       NumItsTaken: 1xF cell array with nested N-element vector containing
%       the number of iterations of threshold increasing required to detect
%       that blob in SegmentFrame.
%       
%       threshlist: 1xF cell array with nested (N+1)-element vector
%       containing the thresholds used for each blob. 
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

% Get Basic Movie Information
info = h5info(moviefile,'/Object');
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
ThreshList = cell(1,NumFrames);

% Run through each frame and get the standard deviation of each individual
% frame. 
disp('Getting movie stats...');
[~,stdframe] = moviestats(moviefile);

%Make threshold above the 4th standard deviation. 
thresh = 4*mean(stdframe);

%%
disp('Performing Frame Segmentation...')
p = ProgressBar(NumFrames); % Initialize progress bar
parfor i = 1:NumFrames 
    
    % Read in each imaging frame
    tempFrame = loadframe(moviefile,i,info);
%     tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    
    %thresh = 0.04; %median(tempFrame(maskpix)); % Set threshold

    % Detect all blobs that are within the mask by adaptively thresholding
    % each frame
    [cc{i},PeakPix{i},NumItsTaken{i},ThreshList{i}] = SegmentFrame(tempFrame,mask,thresh, varargin{:});
    
    p.progress; % update progress bar    
end

p.stop; % Shut-down progress bar

%%

varargin_params = varargin;

save Blobs.mat cc mask PeakPix NumItsTaken ThreshList varargin_params

end