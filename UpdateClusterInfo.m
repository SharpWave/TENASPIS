function [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,frames] = UpdateClusterInfo(...
    MergeClus,Xdim,Ydim,PixelList,PixelAvg,BigPixelAvg,cmpix,Xcent,Ycent,frames,ClustersToUpdate)

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

i = ClustersToUpdate;

cluidx = MergeClus;
tempX = 0;
tempY = 0;
tempFrameCount = zeros(size(cmpix{i}));
tempAvg = zeros(size(cmpix{i}));

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

% for each cluster, add pixels that overlap with cm(i)
for j = 1:length(cluidx)
    
    % NPidx is index into BigPixelAvg
    [binans,firstidx] = ismember(cmpix{i},cmpix{cluidx(j)});
    okpix = find(binans);
    try
    tempFrameCount(okpix) = tempFrameCount(okpix)+length(frames{cluidx(j)});
    catch
        keyboard;
    end
    tempAvg(okpix) = tempAvg(okpix)+BigPixelAvg{cluidx(j)}(firstidx(okpix))*length(frames{cluidx(j)});
end
BigPixelAvg{i} = tempAvg./tempFrameCount;

% now create new PixelAvg from BigPixelAvg

for j = 1:length(cluidx)
    if (cluidx(j) ~= i)
        frames{i} = [frames{i},frames{cluidx(j)}];
    end
end
% update Pixel Avg
[~,idx] = ismember(PixelList{i},cmpix{i});
try
PixelAvg{i} = BigPixelAvg{i}(idx);
catch
    keyboard;
end
  

end