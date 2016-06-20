function [PixelList,Xcent,Ycent,MeanArea,frames,PixelAvg] = AvgTransient(SegChain,cc,Xdim,Ydim,PeakPix)
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

% Initialize variables
Xcent = 0; % Xcentroid location in pixels
Ycent = 0; % Ycentroid location in pixels
%MeanArea = 0;
frames = [];

AvgN = zeros(Xdim,Ydim);

nSegChains = length(SegChain);
for i = 1:nSegChains
    
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
    
    AvgN = AvgN + temp; % Add up blobs from each frame
    Xcent = Xcent+PeakPix{FrameNum}{ObjNum}(1); % Add up all centroid/peak locations from each frame
    Ycent = Ycent+PeakPix{FrameNum}{ObjNum}(2); % Add up all centroid/peak locations from each frame
    
end

% Take averages of the blobs and centroids
AvgN = single(AvgN./length(SegChain));

Xcent = Xcent/length(SegChain);
Ycent = Ycent/length(SegChain);

if (max(AvgN(:)) == 1) % If blob is relatively stable across all frames, continue
    BoolN = AvgN > 0.8; % Find areas where 80% or more of the blobs occur for valid pixels across all frames
    
    PixelList = find(BoolN); % Get pixel indices
        
    % Get area of valid pixels
    b = bwconncomp(BoolN,4);
    bstat = regionprops(b,'Area');
    
%     Xcent = bstat(1).Centroid(1);
%     Ycent = bstat(1).Centroid(2);
    MeanArea = bstat(1).Area; % Deal out area to usable variable
    PixelAvg = zeros(size(PixelList));
    
    for i = 1:nSegChains
      FrameNum = SegChain{i}(1);
      ObjNum = SegChain{i}(2);
      [isgood,goodloc] = ismember(PixelList,cc{FrameNum}.PixelIdxList{ObjNum});
      
      %keyboard;
      
      PixelAvg(isgood) = PixelAvg(isgood) + cc{FrameNum}.PixelVals{ObjNum}(goodloc(isgood));
  
    end
     PixelAvg = PixelAvg ./nSegChains;
     
else % If blob is not that stable across all the frames, effectively discard by setting to empty/zero
    PixelList = [];
    PixelAvg = [];
    Xcent = 0;
    Ycent = 0;
    MeanArea = 0;
end

end
