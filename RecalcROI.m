function[NewPixelIdxList,GoodPeakAvg] = RecalcROI(PixelIdxList,GoodPeaks);

global T_MOVIE;
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;
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
circidx = MakeCircMask(Xdim,Ydim, 30, ceil(rp.Centroid(1)), ceil(rp.Centroid(2)));

thresh = 0.003;
foundit = 0;
oldsize = length(PixelIdxList);
[~,midx] = max(GoodPeakAvg(PixelIdxList));
temp = blankframe;
temp(circidx) = GoodPeakAvg(circidx);

while(~foundit)
    
    tr = regionprops(temp > thresh,'PixelIdxList','Solidity');
    
    foundit = 0;
    NewPixelIdxList = [];
    for j = 1:length(tr)
        if(ismember(PixelIdxList(midx),tr(j).PixelIdxList))
            NewPixelIdxList = tr(j).PixelIdxList;
            break;
        end
    end
    
    if(isempty(NewPixelIdxList) || (isempty(tr)))
        NewPixelIdxList = [];
        disp('killed a cluster');
        break;
    end
    if((length(NewPixelIdxList) < 1.25*oldsize) && (tr(j).Solidity >= 0.95) )
        foundit = 1;
    end
    thresh = thresh + 0.001;
    
end

if (length(PixelIdxList) < MinBlobArea)
    PixelIdxList = [];
    disp(' a cluster got too small');
end