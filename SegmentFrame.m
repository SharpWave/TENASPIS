function [frame,cc,ccprops,origprops] = SegmentFrame(frame,toplot,mask,thresh)
% [frame,cc,ccprops] = SegmentFrame(frame,toplot,mask,thresh)
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
% UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    toplot = 0;
end

minpixels = 80;%80
numpan = 3;
threshinc = 0.005;%10
neuronthresh = 120;%300
artifactthresh = 30000;
minsolid = 0.9;
ccprops = [];

initframe = double(frame);
minval = min(initframe(:));

if (toplot) 
    figure;
    subplot(1,numpan,1);imagesc(frame); title ('raw input');colormap(gray);
end

badpix = find(mask == 0);


threshframe = frame > thresh;



threshframe = bwareaopen(threshframe,minpixels,4); % remove smaller than minpixels

if (toplot) 
    subplot(1,numpan,2);imagesc(threshframe); title('input to bwconncomp');
end

cc = bwconncomp(threshframe,4);
rp = regionprops(cc,'Area','Centroid','Eccentricity','EquivDiameter','MajorAxisLength','MinorAxisLength','Orientation','PixelIdxList','Solidity');
origprops = rp;

if (length(cc.PixelIdxList) == 0)
    frame = zeros(cc.ImageSize(1),cc.ImageSize(2));
    return;
end


% ok, now sort the cc's by their sizes
for i = 1:length(cc.PixelIdxList)
    segsize(i) = rp(i).Area;
    segsolid(i) = rp(i).Solidity;
end

CCgoodidx = intersect(find(segsize <= neuronthresh),find(segsolid >= minsolid));
CCquestionidx = intersect(union(find(segsize > neuronthresh),find(segsolid < minsolid)),find(segsize < artifactthresh));
CCbadidx = find(segsize >= artifactthresh);

% the cc's in CCquestionidx might be multiple cells
if (toplot)
figure
end
newlist = [];
currnewList = 0;
for i = 1:length(CCquestionidx)
    % we want to try to increase the threshold and do a bwconncomp on only
    % the pixels that were part of this cc
    % if this creates any cc's that are below the neuron size threshold, we eliminate those pixels and continue to raise the threshold
    % repeating this until all pixels have been eliminated or there are no
    % more cc's
    qidx = CCquestionidx(i);
    temp = zeros(cc.ImageSize(1),cc.ImageSize(2))+minval;
    temp(cc.PixelIdxList{qidx}) = initframe(cc.PixelIdxList{qidx});
    tempthresh = thresh + threshinc;
    keepgoing = 1;
    while(keepgoing)
        keepgoing = 0;
        threshframe = temp > tempthresh;
        threshframe = bwareaopen(threshframe,minpixels,4);
        if (toplot)
            subplot(1,2,1);imagesc(threshframe);colormap gray;caxis([0 1]);
            subplot(1,2,2);imagesc(temp);caxis([tempthresh max(temp(:))]);pause;
        end
        
        
        bb = bwconncomp(threshframe,4);
        rp = regionprops(bb,'Area','Solidity');        
        if (length(bb.PixelIdxList) > 0)
            % there were blobs, check if any of them are under
            % thresh
            bsize = [];
            bSolid = [];
            for j = 1:length(bb.PixelIdxList)
                bsize(j) = rp(j).Area;
                bSolid(j) = rp(j).Solidity;
            end
            %bsize
            %bSolid
            
            %%%TODO also check for ellipsoid border by comparing the size
            % to the size of the border
            
            newn = intersect(find(bsize <= neuronthresh),find(bSolid >= minsolid));
            if (length(newn) > 0)
                for j = 1:length(newn)
                    % this is a new list
                    currnewList = currnewList + 1;
                    newlist{currnewList} = bb.PixelIdxList{newn(j)};
                    %display('successfully found a new neuron');
                    if (toplot)
                        pause;
                    end
                end
            end
            
            if (length(newn) == length(bb.PixelIdxList))
                % nothing left to split
                break;
            else
                % still over-threshold blobs left
                oldn = union(find(bsize > neuronthresh), find(bSolid<minsolid));
                temp = zeros(cc.ImageSize(1),cc.ImageSize(2))+ minval;
                for j = 1:length(oldn)
                    temp(bb.PixelIdxList{oldn(j)}) = initframe(bb.PixelIdxList{oldn(j)});
                end
                tempthresh = tempthresh + threshinc;
                keepgoing = 1;
                continue;
            end
        else
            % raising the threshold caused us to go from valid
            % over-threshold blobs to nothing
            continue;
        end
    end
end
close all;

numlists = 0;
newcc.PixelIdxList = [];


for i = 1:length(CCgoodidx)
    if (length(intersect(cc.PixelIdxList{CCgoodidx(i)},badpix)) == 0)
      numlists = numlists + 1;
      newcc.PixelIdxList{numlists} = cc.PixelIdxList{CCgoodidx(i)};
    end
end

for i = 1:length(newlist)
    if (length(intersect(newlist{i},badpix)) == 0)
      numlists = numlists + 1;
      newcc.PixelIdxList{numlists} = newlist{i};
    end
end

newcc.NumObjects = numlists;
newcc.ImageSize = cc.ImageSize;
newcc.Connectivity = 4;
cc = newcc;
ccprops = regionprops(cc,'Area','Centroid','Eccentricity','EquivDiameter','MajorAxisLength','MinorAxisLength','Orientation','PixelIdxList','Solidity');

% add in centroids

frame = zeros(cc.ImageSize(1),cc.ImageSize(2));
for i = 1:length(cc.PixelIdxList)
  frame(cc.PixelIdxList{i}) = 1;
end

end

            
            
            
            
    
