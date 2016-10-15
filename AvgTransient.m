function [PixelList,frames,Xcent,Ycent] = AvgTransient(SegChain,cc,Xdim,Ydim)
% [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% goes through all of the frames of a particular transient and calculates
% some basic stats
%
% INPUTS:
%   cc, PeakPix: see ExtractBlobs help
%
%   SegChain, Xdim, Ydim: see MakeTransients help.  SegChain is for an
%   individual segment only.
%
% OUTPUTS:
%
%   PixelList: List of pixel indices which are active on 80% or more of the
%   transient frames - corresponds to array of size Ydim x Xdim
%
%   Xcent, Ycent: the average location of the peak pixel across all the
%   frames for the transient
%
%   MeanArea: Area of active pixels identified in PixelList
%
%   frames: array of active frames for the transient
%
%   AvgN: not currently used for other functions
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

MinPercentPresent = 1;

% Initialize variables
frames = [];
AvgN = zeros(Xdim,Ydim);
nFrames = length(SegChain);

for i = 1:nFrames    
    % Pull identifying information about each transient from SegChain
    FrameNum = SegChain{i}(1);
    ObjNum = SegChain{i}(2);
    
    frames = [frames,FrameNum];
    
    % Get active pixels for each transient
    ts = regionprops(cc{FrameNum},'PixelIdxList');
    
    % Set active pixels for each segment in each frame to 1, all else to
    % zero
    temp = zeros(Xdim,Ydim);
    temp(ts(ObjNum).PixelIdxList) = 1;
    
    AvgN = AvgN + temp; % Add up blob mask    
end

% AvgN is fraction of frames including that pixel 
AvgN = single(AvgN./nFrames);

if (max(AvgN(:)) < 1) % SHOULD be redundant with the motion criterion
  error('putative calcium transient on the go, something is wrong with MakeTransients');
end

PixelList = find(AvgN >= MinPercentPresent);
temp = zeros(Xdim,Ydim);
temp(PixelList) = 1;
r = regionprops(temp,'Centroid');
Xcent = r.Centroid(1);
Ycent = r.Centroid(2);



end
