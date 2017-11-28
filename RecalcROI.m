function[NewPixelIdxList,GoodPeakAvg] = RecalcROI(PixelIdxList,GoodPeaks);

global T_MOVIE;
[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;
GoodPeakAvg = zeros(Xdim,Ydim,'single');

for i = 1:length(GoodPeaks)
    GoodPeakAvg = GoodPeakAvg + mean(T_MOVIE(:,:,GoodPeaks(i)-2:GoodPeaks(i)+2),3);
end
GoodPeakAvg = GoodPeakAvg/length(GoodPeaks);

thresh = 0.003;
foundit = 0;
oldsize = length(PixelIdxList);

while(~foundit)
    
    tr = regionprops(GoodPeakAvg > thresh,'PixelIdxList','Solidity');
    [~,midx] = max(GoodPeakAvg(PixelIdxList));
    foundit = 0;
    NewPixelIdxList = [];
    for j = 1:length(tr)
        if(ismember(PixelIdxList(midx),tr(j).PixelIdxList))
            NewPixelIdxList = tr(j).PixelIdxList;
            break;
        end
    end
    
    if(isempty(NewPixelIdxList) || (length(tr) == 0))
        NewPixelIdxList = [];
        disp('killed a cluster');
        break;
    end
    if((length(NewPixelIdxList) < 1.25*oldsize) && (tr(j).Solidity >= 0.9) )
        foundit = 1;
    end
    thresh = thresh + 0.001;
    
end

if (length(PixelIdxList) < MinBlobArea)
    PixelIdxList = [];
    disp(' a cluster got too small');
end