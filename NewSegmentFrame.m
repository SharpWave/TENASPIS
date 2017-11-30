function [BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = NewSegmentFrame(frame,PrepMask,CheckPeaks,ThreshOverride)


[Xdim,Ydim,threshold,threshsteps,MaxBlobRadius,MinBlobRadius,MaxAxisRatio,MinSolidity] = ...
    Get_T_Params('Xdim','Ydim','threshold','threshsteps','MaxBlobRadius','MinBlobRadius','MaxAxisRatio','MinSolidity');

if (~exist('PrepMask','var'))
    PrepMask = true(Xdim,Ydim);
else
    if (isempty(PrepMask))
        PrepMask = true(Xdim,Ydim);
    end
end

LowPassFilter = fspecial('disk',3);
%frame = imfilter(frame,LowPassFilter,'replicate');
frame = medfilt2(frame,[5 5]);

% Derived Parameters
MaxBlobArea = ceil((MaxBlobRadius^2)*pi);
MinBlobArea = ceil((MinBlobRadius^2)*pi);

%% Setup variables for below
badpix = find(PrepMask == 0); % Locations of pixels that are outside the mask and should be excluded
blankframe = zeros(Xdim,Ydim,'single');

maxframe = max(frame(PrepMask));

threshinc = (maxframe-threshold)/threshsteps;

threshlist = threshold:threshinc:maxframe;

CurrGoodBlob = 0;
BlobPixelIdxList = [];

for i = 1:length(threshlist)
    threshframe = frame > threshlist(i);
    threshframe = bwareaopen(threshframe,MinBlobArea,4); % remove blobs smaller than minpixels
    rp = regionprops(bwconncomp(threshframe,4),'Area','Solidity','MajorAxisLength','MinorAxisLength','PixelIdxList','Centroid');
    NumHits = zeros(1,length(BlobPixelIdxList));
    OldNumBlobs = length(BlobPixelIdxList);
    
    for j = 1:length(rp)
        % check basic properties
        AxisRatio = rp(j).MajorAxisLength/rp(j).MinorAxisLength;
        
        CriteriaOK = (rp(j).Solidity > MinSolidity) && (AxisRatio < MaxAxisRatio) && (rp(j).Area < MaxBlobArea) && (rp(j).MajorAxisLength < 2*MaxBlobRadius);
        if(~CriteriaOK)
            continue;
        end
        
        
        % ok so it looks good but do we already have it?
        AlreadyFound = false;
        CentroidIdx = sub2ind([Xdim Ydim],ceil(rp(j).Centroid(2)),ceil(rp(j).Centroid(1)));
        
        for k = 1:OldNumBlobs
            if(ismember(CentroidIdx,BlobPixelIdxList{k}))
                AlreadyFound = true;
                NumHits(k) = NumHits(k) + 1;
                break;
            end
        end
        
        if(AlreadyFound)
            continue;
        end
        
        % ok at this point it's a new blob
        CurrGoodBlob = CurrGoodBlob + 1;
        BlobPixelIdxList{CurrGoodBlob} = rp(j).PixelIdxList;        
        BlobWeightedCentroids{CurrGoodBlob} = single(rp(j).Centroid);
        BlobMinorAxisLength(CurrGoodBlob) = single(rp(j).MinorAxisLength);
    end
    
    BadGuys = find(NumHits > 1);
    for j = 1:length(BadGuys)
        BlobPixelIdxList{BadGuys(j)} = [];
    end
end

GoodBlob = ones(1,CurrGoodBlob);
for i = 1:CurrGoodBlob
    if(isempty(BlobPixelIdxList{i}) || (~isempty(intersect(BlobPixelIdxList{i},badpix))))
        GoodBlob(i) = 0;
    end
end
BlobPixelIdxList = BlobPixelIdxList(find(GoodBlob));
BlobWeightedCentroids = BlobWeightedCentroids(find(GoodBlob));
BlobMinorAxisLength = BlobMinorAxisLength(find(GoodBlob));

% %parameter debugging
% temp = blankframe;
% for i = 1:length(BlobPixelIdxList)
%     temp(BlobPixelIdxList{i}) = temp(BlobPixelIdxList{i}) + frame(BlobPixelIdxList{i});
% end
% cutoff = PercentileCutoff(frame(:),98);
% composite = zeros(Xdim,Ydim,3);
% cutframe = frame;
% cutframe(frame <= 0.005) = 0;
% composite(:,:,1) = temp/cutoff;
% composite(:,:,2) = frame/cutoff*0.2;
% composite(:,:,3) = cutframe/cutoff*0.6;
% %figure(53);subplot(1,2,1);imagesc(frame);axis image;colormap gray;subplot(1,2,2);imagesc(temp);axis image;colormap gray;colorbar;pause;
% figure(53);image(composite);axis image;pause;






% filter the frame if needed

% do regionprops on the frame at X different thresholds

% start with bottom thresh

% keep blobs within criterion

% raise thresh

% if matching blob already kept, ignore blob unless more than one matches
% the same

% repeat for each thresh
