function [BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = SegmentFrame(frame,PrepMask)


[Xdim,Ydim,threshold,MaxBlobRadius,MinBlobRadius,MaxAxisRatio,MinSolidity] = ...
    Get_T_Params('Xdim','Ydim','threshold','MaxBlobRadius','MinBlobRadius','MaxAxisRatio','MinSolidity');


NormMaxThresh = 0.95; % maximum threshold to try (fraction of max intensity)
ToPlot = false; % whether to plot the results (also need to disable the parfor in ExtractBlobs

if (~exist('PrepMask','var'))
    PrepMask = true(Xdim,Ydim);
else
    if (isempty(PrepMask))
        PrepMask = true(Xdim,Ydim);
    end
end

% Derived Parameters
MaxBlobArea = ceil((MaxBlobRadius^2)*pi);
MinBlobArea = ceil((MinBlobRadius^2)*pi);

%% Setup variables for below
badpix = find(PrepMask == 0); % Locations of pixels that are outside the mask and should be excluded
blankframe = zeros(Xdim,Ydim,'single'); % use this

maxframe = max(frame(PrepMask));
threshinc = 0.02;
threshlist = prctile(frame(:),95:threshinc:100);

CurrGoodBlob = 0;
BlobPixelIdxList = [];
BlobWeightedCentroids = [];
BlobMinorAxisLength = [];
BlobAxisRatio = [];
BlobSolidity = [];



for i = 1:length(threshlist)
    threshframe = frame > threshlist(i);
    threshframe = bwareaopen(threshframe,MinBlobArea,4); % remove blobs smaller than minpixels
    
    rp = regionprops(bwconncomp(threshframe,4),'Area','Solidity','MajorAxisLength','MinorAxisLength','PixelIdxList','Centroid'); % get the properties of the blobs
    WasImproved = zeros(1,length(BlobPixelIdxList));
    OldNumBlobs = length(BlobPixelIdxList);
    
    for j = 1:length(rp)
        % compute the axis ratio and check against size and solidity
        % requirements
        
        CriteriaOK = (rp(j).Solidity > MinSolidity) && (rp(j).Area < MaxBlobArea) && (rp(j).MajorAxisLength < 2*MaxBlobRadius);
        
        
        if(~CriteriaOK)
            continue;
        end        
        
        AxisRatio = rp(j).MajorAxisLength/rp(j).MinorAxisLength;
        
        % ok so it looks good but do we already have it? Check all of the
        % old blobs for matches
        AlreadyFound = false;
        BetterThanBefore = false;
        CentroidIdx = sub2ind([Xdim Ydim],ceil(rp(j).Centroid(2)),ceil(rp(j).Centroid(1)));        
        
        for k = 1:OldNumBlobs
            if(ismember(CentroidIdx,BlobPixelIdxList{k}))
                AlreadyFound = true;
                
                BetterThanBefore = ((rp(j).Solidity > BlobSolidity(k)) && (AxisRatio < BlobAxisRatio(k)));
                if(BetterThanBefore && CriteriaOK)
                    % this guarantees that the matching blob gets deleted
                    WasImproved(k) = 1;
                    %disp('kept blob at a higher threshold');
                end
                break;
            end
        end        
        
        if(AlreadyFound && ~BetterThanBefore)
            % not better so keep the blob at the old threshold

            continue;
        end
        
        % ok at this point it's a new blob
        CurrGoodBlob = CurrGoodBlob + 1;
        BlobPixelIdxList{CurrGoodBlob} = rp(j).PixelIdxList;
        BlobWeightedCentroids{CurrGoodBlob} = single(rp(j).Centroid);
        BlobMinorAxisLength(CurrGoodBlob) = single(rp(j).MinorAxisLength);
        BlobAxisRatio(CurrGoodBlob) = AxisRatio;
        BlobSolidity(CurrGoodBlob) = single(rp(j).Solidity);
    end
    
    % clean up blobs that were replaced by new blobs at a higher threshold
    BadGuys = find(WasImproved);
    for j = 1:length(BadGuys)
        BlobPixelIdxList{BadGuys(j)} = [];
    end
    NotDead = ones(1,length(BlobPixelIdxList));
    
    for j = 1:length(BlobPixelIdxList)
        if(isempty(BlobPixelIdxList{j}))
            NotDead(j) = 0;
        end
    end
    NotDead = find(NotDead);
    BlobPixelIdxList = BlobPixelIdxList(NotDead);
    BlobWeightedCentroids = BlobWeightedCentroids(NotDead);
    BlobMinorAxisLength = BlobMinorAxisLength(NotDead);
    BlobAxisRatio = BlobAxisRatio(NotDead);
    BlobSolidity = BlobSolidity(NotDead);
    CurrGoodBlob = length(BlobPixelIdxList);    
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

%parameter debugging

if(ToPlot)
    temp = blankframe;
    for i = 1:length(BlobPixelIdxList)
        temp(BlobPixelIdxList{i}) = temp(BlobPixelIdxList{i}) + frame(BlobPixelIdxList{i});
    end
    cutoff = PercentileCutoff(frame(:),99.5);
    composite = zeros(Xdim,Ydim,3);
    tempc = frame/cutoff;
    tempc(find(temp ~= 0)) = 0;
    composite(:,:,1) = frame/cutoff;
    
    composite(:,:,2) = tempc;
    composite(:,:,3) = tempc;
    
    figure(53);image(composite);axis image;pause;
end





