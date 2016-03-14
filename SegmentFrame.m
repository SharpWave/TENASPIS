function [cc,PeakPix] = SegmentFrame(frame,mask,thresh)
% [frame,cc,ccprops] = SegmentFrame(frame,mask,thresh)
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

% Parameters
minpixels = 80; % minimum blob size during initial segmentation
adjminpixels = 50; % minimum blob size during re-segmentation attempts
threshinc = 0.02; % how much to increase threshold by on each re-segmentation iteration
neuronthresh = 150; % maximum blob size to be considered a neuron
minsolid = 0.85; % minimum blob solidity to be considered a neuron


PeakPix = [];
badpix = find(mask == 0);

% threshold and segment the frame
initframe = double(frame);
minval = min(initframe(:));
threshframe = frame > thresh;
threshframe = bwareaopen(threshframe,minpixels,4); % remove blobs smaller than minpixels
cc = bwconncomp(threshframe,4);
rp = regionprops(cc,'Area','Solidity');

% exit if no blobs found
if (isempty(cc.PixelIdxList))
    PeakPix = [];
    display('no blobs detected');
    return;
end

% get area and solidity info
for i = 1:length(cc.PixelIdxList)
    segsize(i) = rp(i).Area;
    segsolid(i) = rp(i).Solidity;
end

% the cc's in CCgoodidx satisfy the size and solidity criteria
CCgoodidx = intersect(find(segsize <= neuronthresh),find(segsolid >= minsolid));

% the cc's in CCquestionidx do not satisfy the criteria (but might if we
% raise the threshold!)
CCquestionidx = union(find(segsize > neuronthresh),find(segsolid < minsolid));

newlist = [];
currnewList = 0;

for i = 1:length(CCquestionidx)
    % make a frame containing only the pixels in this blob (all else set to
    % minval)
    qidx = CCquestionidx(i);
    temp = zeros(cc.ImageSize(1),cc.ImageSize(2))+minval;
    temp(cc.PixelIdxList{qidx}) = initframe(cc.PixelIdxList{qidx});
    
    % increase threshold one increment from baseline
    tempthresh = thresh + threshinc;
    BlobsInFrame = 1;
    
    while(BlobsInFrame)
        BlobsInFrame = 0;
        % threshold and segment the frame
        threshframe = temp > tempthresh;
        threshframe = bwareaopen(threshframe,adjminpixels,4);
        bb = bwconncomp(threshframe,4);
        rp = regionprops(bb,'Area','Solidity');
        
        if (~isempty(bb.PixelIdxList))
            % there were blobs, check if any of them satisfy size and
            % solidity criteria
            bsize = [];
            bSolid = [];
            
            for j = 1:length(bb.PixelIdxList)
                bsize(j) = rp(j).Area;
                bSolid(j) = rp(j).Solidity;
            end
            
            newn = intersect(find(bsize <= neuronthresh),find(bSolid >= minsolid));
            
            for j = 1:length(newn)
                % append new blob pixel lists
                currnewList = currnewList + 1;
                newlist{currnewList} = bb.PixelIdxList{newn(j)};
            end
            
            
            if (length(newn) == length(bb.PixelIdxList))
                % nothing left to split
                break;
            else
                % still blobs left
                BlobsInFrame = 1;
                oldn = union(find(bsize > neuronthresh), find(bSolid<minsolid));
                
                % make a frame containing the remaining blobs
                temp = zeros(cc.ImageSize(1),cc.ImageSize(2))+ minval;
                for j = 1:length(oldn)
                    temp(bb.PixelIdxList{oldn(j)}) = initframe(bb.PixelIdxList{oldn(j)});
                end
                
                % increase threshold
                tempthresh = tempthresh + threshinc;
                continue;
            end
        else
            % raising the threshold caused us to go from valid
            % over-threshold blobs to nothing
            continue;
        end
    end
end

numlists = 0;
newcc.PixelIdxList = [];

for i = 1:length(CCgoodidx)
    if (isempty(intersect(cc.PixelIdxList{CCgoodidx(i)},badpix)))
        numlists = numlists + 1;
        newcc.PixelIdxList{numlists} = single(cc.PixelIdxList{CCgoodidx(i)});
    end
end

for i = 1:length(newlist)
    if (isempty(intersect(newlist{i},badpix)))
        numlists = numlists + 1;
        newcc.PixelIdxList{numlists} = single(newlist{i});
    end
end

newcc.NumObjects = numlists;
newcc.ImageSize = cc.ImageSize;
newcc.Connectivity = 4;
cc = newcc;

% get peak pixel
for i = 1:length(cc.PixelIdxList)
    [~,idx] = max(initframe(cc.PixelIdxList{i}));
    [PeakPix{i}(1),PeakPix{i}(2)] = ind2sub(cc.ImageSize,cc.PixelIdxList{i}(idx));
end

display([int2str(length(cc.PixelIdxList)),' Blobs Detected'])
end







