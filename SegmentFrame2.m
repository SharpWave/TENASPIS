function [cc,PeakPix] = SegmentFrame2(frame,mask,thresh)
% [frame,cc,ccprops] = SegmentFrame(frame,mask,thresh)
%
%   Identifies local maxima and separates them out into neuron sized blobs.
%   Does so in an adaptive manner by iteratively bumping up the threshold
%   until no new blobs are identified.
%
%   INPUTS:
%
%       frame: a frame from an braing imaging movie
%
%       mask: a logical array the same size as frame indicating which areas
%       have valid neurons (ones) and which do not (zeros)
%
%       thresh: the starting value at which you will threshold the values in
%       frame to being looking for blobs
%
%   OUTPUTS:
%
%       cc: structure variable containing all the relevant data/statistics 
%       about the blobs discovered (e.g. the pixel indices for each blob) 
%
%       PeakPix: a cell array with the x/y pixel indices for the location 
%       of the peak pixel intensity for each blob.
%
%       NumItsTaken: number of iterations taken to identify each blob.
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

% User defined Parameters
MaxNeuronRadius = 15;
MinNeuronRadius = 5;

initthreshold = 0.01;
MaxAxisRatio = 2; % maxium ratio of the major to minor axis
MinSolidity = 0.95; % minimum blob "solidity"
threshsteps = 10; % number of increments of threshold to check for each blob

% Derived Parameters
MaxBlobArea = ceil((MaxNeuronRadius^2)*pi);
MinBlobArea = ceil((MinNeuronRadius^2)*pi);

% Setup variables for below
PeakPix = []; % Locations of peak pixels 
threshlist = [];
badpix = find(mask == 0); % Locations of pixels that are outside the mask and should be excluded
frame = single(frame); % work with single precision to save memory
blankframe = zeros(size(frame));

% threshold and segment the frame
threshframe = frame > thresh; % apply threshold, make it into a logical array
threshframe = bwareaopen(threshframe,MinBlobArea,4); % remove blobs smaller than minpixels

% Set up variables 
newlist = [];
currnewList = 0;
BlobsInFrame = 1;
NumIts = 0;
tNumItsTaken = [];

% Determine initial blobs and measurements 
rp = regionprops(bwconncomp(threshframe,4),'Area','Solidity','MajorAxisLength','MinorAxisLength','SubarrayIdx','Image');

% investigate whether initialblobs can be refined into legal blobs
for i = 1:length(rp)
    
    GoodBlob(i) = 1;
    props = rp(i);
    tempthresh = initthreshold;
    SmallImage = frame(props.SubarrayIdx{1},props.SubarrayIdx{2});
    SmallImage(find(props.Image == 0)) = 0;
    BinImage = SmallImage > tempthresh;
    MaxIntensity = max(SmallImage(:));
    ThresholdInc = MaxIntensity/threshsteps;
    
    AxisRatio = props.MajorAxisLength/props.MinorAxisLength;
    
    CriteriaOK = (props.Solidity > MinSolidity) && (AxisRatio < MaxAxisRatio) && (props.Area < MaxBlobArea);
            
    while(~CriteriaOK && (tempthresh < MaxIntensity))
      % First increase threshold and take a new binary image
      tempthresh = tempthresh+ThresholdInc;
      BinImage = SmallImage > tempthresh;
      BinImage = bwareaopen(BinImage,MinBlobArea,4);
      
      % then check for the blob criteria again
      temp_props = regionprops(bwconncomp(BinImage,4),'Area','Solidity','MajorAxisLength','MinorAxisLength','SubarrayIdx','Image');
      
      if (length(temp_props) ~= 1)
          % multiple areas in the blob
          break; % CriteriaOK is still 0
      end
      
      AxisRatio = temp_props.MajorAxisLength/temp_props.MinorAxisLength;
      CriteriaOK = (temp_props.Solidity > MinSolidity) && (AxisRatio < MaxAxisRatio) && (temp_props.Area < MaxBlobArea);
    end
    
    if (~CriteriaOK) 
        GoodBlob(i) = 0;
        continue;
    end
    
    % Criteria satisfied, test for multiple peaks
    CritThresh = tempthresh;
    CritBinImage = BinImage;
    
    while (tempthresh < MaxIntensity)
        tempthresh = tempthresh+ThresholdInc;
        BinImage = SmallImage > tempthresh;
        temp_conn = bwconncomp(BinImage,8);
        if (temp_conn.NumObjects > 1)
            GoodBlob(i) = 0;
            break;
        end
    end
      
    if(GoodBlob(i))
        CritImage{i} = SmallImage.*CritBinImage;
        tempframe = blankframe;
        tempframe(props.SubarrayIdx{1},props.SubarrayIdx{2}) = CritImage{i};
        tempbinframe = blankframe;
        tempbinframe(props.SubarrayIdx{1},props.SubarrayIdx{2}) = CritBinImage;
        temp_props = regionprops(bwconncomp(tempbinframe,4),tempframe,'PixelIdxList','PixelValues','WeightedCentroid');
        PixelIdxList{i} = temp_props.PixelIdxList;
        PixelValues{i} = temp_props.PixelValues;
        WeightedCentroid{i} = temp_props.WeightedCentroid;
        
        if (~isempty(intersect(badpix,PixelIdxList{i})))
            GoodBlob(i) = 0;
        end
    end
end

if(sum(GoodBlob) == 0)
    PeakPix = [];
    threshlist = [];
    cc.NumObjects = 0;
    cc.PixelIdxList = [];
    cc.PixelVals = [];
    cc.ImageSize = size(frame);
    cc.Connectivity = 0; 
    return;
end

cc.NumObjects = sum(GoodBlob);
cc.ImageSize = size(frame);
cc.Connectivity = 4;

GB = find(GoodBlob);

for i = 1:length(GB)
    cc.PixelIdxList{i} = single(PixelIdxList{GB(i)});
    cc.PixelVals{i} = single(PixelValues{GB(i)});
    PeakPix{i}(1) = WeightedCentroid{GB(i)}(1);
    PeakPix{i}(2) = WeightedCentroid{GB(i)}(2);
end

end
