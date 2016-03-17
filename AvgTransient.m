function [PixelList,Xcent,Ycent,MeanArea,frames,AvgN] = AvgTransient(SegChain,cc,Xdim,Ydim,PeakPix)
% [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% goes through all of the frames of a particular transient and calculates
% some basic stats
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

Xcent = 0;
Ycent = 0;
%MeanArea = 0;
frames = [];

AvgN = zeros(Xdim,Ydim);

nSegChains = length(SegChain);
p = ProgressBar(nSegChains);
for i = 1:nSegChains
    FrameNum = SegChain{i}(1);
    ObjNum = SegChain{i}(2);
    frames = [frames,FrameNum];
    ts = regionprops(cc{FrameNum},'PixelIdxList');
    temp = zeros(Xdim,Ydim);
    temp(ts(ObjNum).PixelIdxList) = 1;
    AvgN = AvgN + temp;
    Xcent = Xcent+PeakPix{FrameNum}{ObjNum}(1);
    Ycent = Ycent+PeakPix{FrameNum}{ObjNum}(2);
    
    p.progress;
end
p.stop;

AvgN = single(AvgN./length(SegChain));
Xcent = Xcent/length(SegChain);
Ycent = Ycent/length(SegChain);

if (max(AvgN(:)) == 1)
    BoolN = AvgN > 0.8;
    
    PixelList = find(BoolN);
        
    b = bwconncomp(BoolN,4);
    bstat = regionprops(b,'Area');
    
%     Xcent = bstat(1).Centroid(1);
%     Ycent = bstat(1).Centroid(2);
    MeanArea = bstat(1).Area;
else
    PixelList = [];
    Xcent = 0;
    Ycent = 0;
    MeanArea = 0;
end
end
