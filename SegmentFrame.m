function [BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = SegmentFrame(frame,PrepMask,CheckPeaks)
% [BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = SegmentFrame(frame,PrepMask)
%
%   Identifies local maxima and separates them out into neuron sized blobs.
%   Does so in an adaptive manner by iteratively bumping up the threshold
%   until no new blobs are identified.
%
%   INPUTS:
%
%       frame: a frame from an braing imaging movie
%
%       PrepMask: a logical array the same size as frame indicating which areas
%       should be used for blob detection (ones) and which should be excluded
%       (zeros).
%
%   OUTPUTS:
%
%       BlobPixelIdxList: Cell array of lists of pixel indices belonging to
%       each blob
%
%       BlobWeightedCentroids: Cell array of weighted centroid values for each
%       blob
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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
%% Get Parameters

[Xdim,Ydim,threshold,threshsteps,MaxBlobRadius,MinBlobRadius,MaxAxisRatio,MinSolidity] = ...
    Get_T_Params('Xdim','Ydim','threshold','threshsteps','MaxBlobRadius','MinBlobRadius','MaxAxisRatio','MinSolidity');

if (~exist('PrepMask','var'))
    PrepMask = true(Xdim,Ydim);
else
    if (isempty(PrepMask))
        PrepMask = true(Xdim,Ydim);
    end
end

if (~exist('CheckPeaks','var'))
    CheckPeaks = true;
end

% Derived Parameters
MaxBlobArea = ceil((MaxBlobRadius^2)*pi);
MinBlobArea = ceil((MinBlobRadius^2)*pi);

%% Setup variables for below
badpix = find(PrepMask == 0); % Locations of pixels that are outside the mask and should be excluded
blankframe = zeros(Xdim,Ydim,'single');

%% segment the frame at initial threshold
threshframe = frame > threshold; % apply threshold, make it into a logical array
threshframe = bwareaopen(threshframe,MinBlobArea,4); % remove blobs smaller than minpixels

% Determine initial blobs and measurements
rp = regionprops(bwconncomp(threshframe,4),'Area','Solidity','MajorAxisLength','MinorAxisLength','SubarrayIdx','Image','PixelIdxList');
GoodBlob = true(length(rp),1);

% Determine whether any of the blobs go off of the mask and eliminate them
for i = 1:length(rp)
    if (~isempty(intersect(rp(i).PixelIdxList,badpix)))
        GoodBlob(i) = false;
    end
end
rp = rp(GoodBlob);
GoodBlob = true(length(rp),1);
BlobPixelIdxList = cell(1,length(rp));
BlobWeightedCentroids = cell(1,length(rp));
BlobMinorAxisLength = zeros(1,length(rp),'single');

%% Test each blob for blob shape criteria; raise threshold and re-test if test fails
for i = 1:length(rp)
    
    props = rp(i);
    currthresh = threshold;
    
    % Make a small matrix with actual and binarized pixel data for the blob
    SmallImage = frame(props.SubarrayIdx{1},props.SubarrayIdx{2});
    SmallImage(props.Image == 0) = 0;
    BinImage = SmallImage > currthresh;
    
    % Sort the pixel matrix to determine the set of thresholds that will be used
    smsort = sort(SmallImage(:));
    smsort = smsort(smsort > 0);
    PixPerThresh = ceil(length(smsort)./threshsteps);
    threshlist = smsort(PixPerThresh:PixPerThresh:length(smsort));
    ThreshIdx = 1;
    
    % Determine whether initial blob passes size and shape criteria
    AxisRatio = props.MajorAxisLength/props.MinorAxisLength;
    CriteriaOK = (props.Solidity > MinSolidity) && (AxisRatio < MaxAxisRatio) && (props.Area < MaxBlobArea);
    
    while(~CriteriaOK && (ThreshIdx <= length(threshlist)))
        % Criteria not met on last check, but still thresholds to check
        
        % First increase threshold and take new binarized pixel data
        currthresh = threshlist(ThreshIdx);
        BinImage = SmallImage > currthresh;
        BinImage = bwareaopen(BinImage,MinBlobArea,4);
        
        % then check for the blob criteria again
        temp_props = regionprops(bwconncomp(BinImage,4),'Area','Solidity','MajorAxisLength','MinorAxisLength','SubarrayIdx','Image');
        
        if (length(temp_props) ~= 1)
            % zero or multiple areas in the blob, abandon blob
            break; % CriteriaOK is still 0
        end
        
        AxisRatio = temp_props.MajorAxisLength/temp_props.MinorAxisLength;
        CriteriaOK = (temp_props.Solidity > MinSolidity) && (AxisRatio < MaxAxisRatio) && (temp_props.Area < MaxBlobArea);
        ThreshIdx = ThreshIdx + 1;
    end
    
    if (~CriteriaOK)
        % Couldn't find threshold that satisfied criteria
        GoodBlob(i) = 0;
        continue;
    end
    
    % Criteria satisfied, test for multiple peaks
    CritBinImage = BinImage;
    
    if (CheckPeaks)
        while (ThreshIdx <= length(threshlist))
            % while more thresholds to check
            % take new binarized pixel data
            currthresh = threshlist(ThreshIdx);
            BinImage = SmallImage > currthresh;
            temp_conn = bwconncomp(BinImage,8);
            if (temp_conn.NumObjects > 1)
                % multiple peaks, abandon ship!
                GoodBlob(i) = 0;
                break;
            end
            if (temp_conn.NumObjects == 0)
                % this probably never happens
                break;
            end
            if (length(temp_conn.PixelIdxList{1}) < MinBlobArea)
                % Blob got small after raising threshold. At this point there
                % wouldn't be multiple peaks that we care about so the blob
                % will be included
                break;
            end
            ThreshIdx = ThreshIdx + 1;
        end
    end
    if (GoodBlob(i))
        % Blob passed shape, size, and "multiple peak" criteria, so determine Pixel List and centroids in full frame coordinates
        tempbinframe = blankframe;
        tempbinframe(props.SubarrayIdx{1},props.SubarrayIdx{2}) = CritBinImage;
        temp_props = regionprops(bwconncomp(tempbinframe,4),frame,'PixelIdxList','WeightedCentroid','MinorAxisLength');
        BlobPixelIdxList{i} = single(temp_props.PixelIdxList);
        BlobWeightedCentroids{i} = single(temp_props.WeightedCentroid);
        BlobMinorAxisLength(i) = single(temp_props.MinorAxisLength);
    end
end

%% Keep only blobs passing the shape, size, and peak criteria

BlobPixelIdxList = BlobPixelIdxList(GoodBlob);
BlobWeightedCentroids = BlobWeightedCentroids(GoodBlob);
BlobMinorAxisLength = BlobMinorAxisLength(GoodBlob);

end
