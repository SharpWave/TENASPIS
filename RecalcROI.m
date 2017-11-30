function[NewPixelIdxList,GoodPeakAvg] = RecalcROI(PixelIdxList,GoodPeaks);

global T_MOVIE;
[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;
blankframe = zeros(Xdim,Ydim,'single');

GoodPeakAvg = blankframe;

for i = 1:length(GoodPeaks)
    GoodPeakAvg = GoodPeakAvg + mean(T_MOVIE(:,:,GoodPeaks(i)-2:GoodPeaks(i)+2),3);
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
    if((length(NewPixelIdxList) < 1.1*oldsize) && (tr(j).Solidity >= 0.9) )
        foundit = 1;
    end
    thresh = thresh + 0.001;
    
end

if (length(PixelIdxList) < MinBlobArea)
    PixelIdxList = [];
    disp(' a cluster got too small');
end