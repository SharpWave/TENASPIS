function[NewPixelIdxList,GoodPeakAvg] = RecalcROI(PixelIdxList,GoodPeaks);
% starting with the ROI specified by PixelIdxList and calcium transient
% peaks specified by GoodPeaks, calculate a new ROI that captures the
% average shape of the neuron.  Generally we want an ROI that's big enough
% to capture the important contours of the neuron but not so big that
% neighbor cell artifacts are included

global T_MOVIE;
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
[MinBlobRadius,MaxBlobRadius] = Get_T_Params('MinBlobRadius','MaxBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;
MaxBlobArea = MaxBlobRadius^2*pi;
blankframe = zeros(Xdim,Ydim,'single');
PeakWinLen = 6;
GoodPeakAvg = blankframe;

for i = 1:length(GoodPeaks)
    GoodPeakAvg = GoodPeakAvg + mean(T_MOVIE(:,:,max(1,GoodPeaks(i)-PeakWinLen):min(GoodPeaks(i)+PeakWinLen,NumFrames)),3);
end
GoodPeakAvg = GoodPeakAvg/length(GoodPeaks);
temp = blankframe;
temp(PixelIdxList) = 1;
rp = regionprops(temp,'Centroid');
try
circidx = MakeCircMask(Xdim,Ydim, 30, ceil(rp.Centroid(1)), ceil(rp.Centroid(2)));
catch
    keyboard;
end

thresh = 0.001;
foundit = 0;
oldsize = length(PixelIdxList);
[~,midx] = max(GoodPeakAvg(PixelIdxList));
temp = blankframe;
temp(circidx) = GoodPeakAvg(circidx);
NewPixelIdxList = [];
BestSolid = 0;
BestGradient = 0;
CurrPixelIdxList = NewPixelIdxList;

gmag = imgradient(temp);

while(~foundit)
    
    % segment the average
    tr = regionprops(temp > thresh,'PixelIdxList','Solidity','MajorAxisLength','MinorAxisLength');
    % find which segment is our ROI
    for j = 1:length(tr)
        if(ismember(PixelIdxList(midx),tr(j).PixelIdxList))
            NewPixelIdxList = tr(j).PixelIdxList;
            break;
        end
    end
    
    if(isempty(NewPixelIdxList) || (isempty(tr)) || (length(NewPixelIdxList) < MinBlobArea))
        % raised threshold too high, use the last good threshold
        NewPixelIdxList = CurrPixelIdxList;
        break;
    end
    
    if((length(NewPixelIdxList) > MaxBlobArea) || (tr(j).MajorAxisLength > 2*MaxBlobRadius))
        % ROI is too big and/or too elongated, raise threshold and try
        % again
        thresh = thresh + 0.001;
        continue;
    end
    
    % if we made it to here then the ROI is okish
    if((tr(j).Solidity > .95) && (mean(gmag(NewPixelIdxList)) > BestGradient))
        BestSolid = tr(j).Solidity;
        BestGradient = mean(gmag(NewPixelIdxList));
        CurrPixelIdxList = NewPixelIdxList;
    end
    thresh = thresh + 0.001;
        
end

if(isempty(NewPixelIdxList))
    disp('unable to calculate new ROI, using old one');
    NewPixelIdxList = PixelIdxList;
end
