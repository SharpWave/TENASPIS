function [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,frames] = UpdateClusterInfo(...
    c,Xdim,Ydim,PixelList,PixelAvg,BigPixelAvg,cmpix,Xcent,Ycent,frames,ClustersToUpdate)

% [PixelList,meanareas,meanX,meanY,NumEvents,frames] = ...
%   UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,...
%   ClustersToUpdate,meanareas,meanX,meanY,NumEvents,frames)
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
if(~exist('ClustersToUpdate','var'))
    ClustersToUpdate = unique(c);
end


for i = ClustersToUpdate'
    
    cluidx = find(c == i);
    tempX = 0;
    tempY = 0;
    tempFrameCount = 0;
    tempAvg = zeros(Xdim,Ydim);
    
    
    % merge ROI pixel sets
    newpixels = [];
    
    for j = 1:length(cluidx)
        
        mergepixels = PixelList{cluidx(j)};
        if (j == 1)
            newpixels = mergepixels;
        else
            newpixels = union(newpixels,mergepixels);
        end
        
        tempX = tempX+Xcent(cluidx(j));
        tempY = tempY+Ycent(cluidx(j));
    end
    
    PixelList{i} = newpixels;
    Xcent(i) = tempX/length(cluidx);
    Ycent(i) = tempY/length(cluidx);
    
    if (cluidx(j) ~= i)
        frames{i} = [frames{i},frames{cluidx(j)}];
    end
    
    
    for j = 1:length(cluidx)
        
        % increment pixel frame counts
        tempFrameCount = tempFrameCount+length(frames{cluidx(j)});
        
        % grab average pixel values for new unioned ROI
        currAvg = zeros(Xdim,Ydim);
        % NPidx is index into BigPixelAvg
        NPidx = 
        currAvg(newpixels) = BigPixelAvg{cluidx(j)}(newpixel index(global) into BigPixel;
        tempAvg(newpixels) = tempAvg(newpixels)+currAvg(newpixels)*length(frames{cluidx(j)});
        
        
    end
    
    tempAvg = tempAvg./TempFrameCount;
    
    
    PixelAvg{i} = tempAvg(newpixels);
    
    
    
    
end


end