function [PixelList,PixelAvg,meanareas,meanX,meanY,NumEvents,frames] = ...
    UpdateClusterInfo(c,Xdim,Ydim,PixelList,PixelAvg,Xcent,Ycent,frames,...
    ClustersToUpdate,meanareas,meanX,meanY,NumEvents,disp_to_screen)
%[PixelList,PixelAvg,meanareas,meanX,meanY,NumEvents,frames] = ...
%    UpdateClusterInfo(c,Xdim,Ydim,PixelList,PixelAvg,Xcent,Ycent,frames,...
%    ClustersToUpdate,meanareas,meanX,meanY,NumEvents,disp_to_screen)
%
%   General purpose function for updating relevant cluster information
%   after modification (usually merging).
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
    disp_to_screen = 0;
end

if(~exist('disp_to_screen','var'))
    disp_to_screen = 0;
end
  
for thisCluster = ClustersToUpdate'
    if disp_to_screen, display(['updated cluster # ',int2str(thisCluster)]); end
    
    cluidx = find(c == thisCluster);
    tempX = 0;
    tempY = 0;
    temp = zeros(Xdim,Ydim);        %Bitmap.
    tempAvg = zeros(Xdim,Ydim);     %Bitmap for later averaging.
    
    % for each transient in the cluster, accumulate stats
    for thisInstance = 1:length(cluidx)
          validpixels = PixelList{cluidx(thisInstance)};
     
%         if (j == 1)
%           newpixels = validpixels;
%         else
%           newpixels = union(newpixels,validpixels);
%         end
        
        temp(validpixels) = temp(validpixels)+1;    %Add to bitmap. 
        currAvg = zeros(Xdim,Ydim);                 %Set this variable to the corresponding PixelAvg. 
        currAvg(PixelList{cluidx(thisInstance)}) = PixelAvg{cluidx(thisInstance)};
        
        %Sum average pixel intensity to average again later. 
        tempAvg(validpixels) = tempAvg(validpixels)+currAvg(validpixels)*length(frames{cluidx(thisInstance)});
        
        if (cluidx(thisInstance) ~= thisCluster)
            frames{thisCluster} = [frames{thisCluster},frames{cluidx(thisInstance)}];
        end
        
        %Sum for later averaging. 
        tempX = tempX+Xcent(cluidx(thisInstance));
        tempY = tempY+Ycent(cluidx(thisInstance));
    end
    
    temp = temp./length(cluidx);                %Average bit map. Bound to [0,1].
    tempAvg = tempAvg./length(frames{thisCluster});       %Average pixel intensity. 
    
    %Get pixels active for more than one frame, then build BitMap. 
    newpixels = find(temp > ((1/length(cluidx))-eps));
    BitMap = false(Xdim,Ydim);
    BitMap(newpixels) = 1;
    b = bwconncomp(BitMap,4);
    r = regionprops(b,'Area'); 
    
    %Use the new pixel list for everything. 
    PixelList{thisCluster} = newpixels;
    PixelAvg{thisCluster} = tempAvg(newpixels);
    
    %Get the area of the blob in BitMap. 
    meanareas(thisCluster) = r(1).Area;
    
    %Average X/Y coordinates of centroids. 
    meanX(thisCluster) = tempX/length(cluidx);            
    meanY(thisCluster) = tempY/length(cluidx);
    
    %Number of transients. 
    NumEvents(thisCluster) = length(cluidx);

end


end