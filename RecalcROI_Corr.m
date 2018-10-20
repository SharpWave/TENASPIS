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

threshlist = prctile(BigPixelAvg(BigPixelAvg > 0),1:0.5:100);
currthresh = 1;

while(~foundit)
    if(currthresh > length(threshlist))
        break;
    end
       
    thresh = threshlist(currthresh);

    
    % segment the average    
    rp = regionprops(bwareaopen(temp > thresh,ceil(MinBlobArea/2),4),'PixelIdxList','Area','Solidity','MajorAxisLength','MinorAxisLength');
    
    % find which segment is our ROI
    for j = 1:length(rp)
        if(length(intersect(ROIpix,rp(j).PixelIdxList)) > 0)
            NewPixelIdxList = rp(j).PixelIdxList;
            break;
        end
    end
    
    if(~isempty(CurrPixelIdxList) & (length(rp) == 0))
        % threshold too high
        break;
    end
    
    if (length(rp) == 0)
        keyboard;
    end
    
    
    CriteriaOK = (rp(j).Area < MaxBlobArea); 
    
    if (~CriteriaOK)
        % still haven't found one
        currthresh = currthresh+1;
        continue;
    end
    
    % ok, this one works, let's not waste time trying to get better
    if(rp(j).Solidity > BestSolid)
      CurrPixelIdxList = NewPixelIdxList;
      BestSolid = rp(j).Solidity;
    else
      currthresh = currthresh+1;
      continue;  
    end
end

PixelIdxList = CurrPixelIdxList;
PixelAvg = temp(PixelIdxList);

