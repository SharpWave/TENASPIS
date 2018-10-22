function[PixelIdxList,PixelAvg] = RecalcROI_Corr(ROIpix,CircMask,BigPixelAvg);

% New version, works from pre-calculated averaged frame in BigPixelAvg,
%  which is centered on the midpoint of the ROIs to be merged
% goal is to find the blob on that midpoint, and return it

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
[MinBlobRadius,MaxBlobRadius,MinSolidity] = Get_T_Params('MinBlobRadius','MaxBlobRadius','MinSolidity');
MinBlobArea = ceil(MinBlobRadius^2*pi);
MaxBlobArea = ceil(MaxBlobRadius^2*pi);
blankframe = zeros(Xdim,Ydim,'single');

thresh = 0.01;
foundit = 0;
midpt = ceil(length(CircMask)/2);
temp = blankframe;
temp(CircMask) = BigPixelAvg;
NewPixelIdxList = [];
BestSolid = 0;
CurrPixelIdxList = [];
maxthresh = max(BigPixelAvg);

threshlist = sort(BigPixelAvg(BigPixelAvg > 0));
currthresh = length(threshlist);
highthresh = length(threshlist);
lowthresh = 1;
bestthresh = 0;

% start threshold in middle
% if no blobs, threshold too high
% if blobs but too big, threshold too low
NumIterations = 0;

while(~foundit)
    if (highthresh - lowthresh <= 1)
        keyboard;
    end
    NumIterations = NumIterations + 1;
    thresh = threshlist(currthresh);
    TooHigh = false;
    TooLow = false;
    ROIidx = 0;
    CurrOverlap = 0;
    
    % segment the average
    rp = regionprops(bwareaopen(temp > thresh,MinBlobArea,4),'PixelIdxList','Area','Solidity','MajorAxisLength','MinorAxisLength');
    
    if(length(rp) == 0)
        % no ROIs found
        TooHigh = true;
    else        
        % find which segment is our ROI
        for j = 1:length(rp)
            ROIintersect = length(intersect(ROIpix,rp(j).PixelIdxList));
            if ((ROIintersect > 0) && (ROIintersect > CurrOverlap))
                ROIidx = j;
                CurrOverlap = ROIintersect;
            end
        end
    end
    
    if (ROIidx == 0)
        % found a blob but not our guy
        TooHigh = true;
    else
        % found our blob, let's check it out
        if (rp(ROIidx).Area > MaxBlobArea)
            TooLow = true;
        else
            % Blob area criteria good
            if(rp(ROIidx).Solidity < 0.9)
                TooLow = true;
            else
                foundit = true;
            end
        end
    end
    
    if (TooLow)
        lowthresh = currthresh;
        currthresh = ceil((currthresh+highthresh)/2);
    end
    
    if (TooHigh)
        highthresh = currthresh;
        currthresh = ceil((currthresh+lowthresh)/2);
    end

end

PixelIdxList = rp(ROIidx).PixelIdxList;
PixelAvg = temp(PixelIdxList);
% NumIterations,

