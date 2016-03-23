function [PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,ClustersToUpdate,meanareas,meanX,meanY,NumEvents,frames)
% [PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,ClustersToUpdate,meanareas,meanX,meanY,NumEvents,frames)
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
if nargin <= 6
    ClustersToUpdate = unique(c);
end
    
for i = ClustersToUpdate'
    %display(['updated cluster # ',int2str(i)]);
    cluidx = find(c == i);
    tempX = 0;
    tempY = 0;
    temp = zeros(Xdim,Ydim);
    % for each transient in the cluster, accumulate stats
    for j = 1:length(cluidx)
        try
          validpixels = PixelList{cluidx(j)};
        catch
          keyboard;
        end
        
%         if (j == 1)
%           newpixels = validpixels;
%         else
%           newpixels = union(newpixels,validpixels);
%         end
        
        temp(validpixels) = temp(validpixels)+1;
        if (cluidx(j) ~= i)
            frames{i} = [frames{i},frames{cluidx(j)}];
        end
        tempX = tempX+Xcent(cluidx(j));
        tempY = tempY+Ycent(cluidx(j));
    end
    temp = temp./length(cluidx);
    newpixels = find(temp > ((1/length(cluidx))-eps));
    BitMap = logical(zeros(Xdim,Ydim));
    BitMap(newpixels) = 1;
    b = bwconncomp(BitMap,4);
    r = regionprops(b,'Area'); % known issue where sometimes the merge creates two discontiguous areas. if changes to AutoMergeClu don't fix the problem then the fix will be here.
    if (length(r) == 0)
        display('foundit');
        keyboard;
    end
    PixelList{i} = newpixels;
    meanareas(i) = r(1).Area;
    meanX(i) = tempX/length(cluidx);
    meanY(i) = tempY/length(cluidx);
    NumEvents(i) = length(cluidx);

end


end

