function[PixelIdxList,GoodPeakAvg] = RecalcROI(PixelIdxList,GoodPeaks);

global T_MOVIE;
[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;
GoodPeakAvg = zeros(Xdim,Ydim,'single');
for i = 1:length(GoodPeaks)
    GoodPeakAvg = GoodPeakAvg + mean(T_MOVIE(:,:,GoodPeaks(i)-2:GoodPeaks(i)+2),3);
end
GoodPeakAvg = GoodPeakAvg/length(GoodPeaks);

thresh = 0.005;
foundit = 0;
oldsize = length(PixelIdxList);
while(~foundit)
    
    tr = regionprops(GoodPeakAvg > thresh,'PixelIdxList','Solidity');
    [~,midx] = max(GoodPeakAvg(PixelIdxList)));
    foundit = 0;
    PixelIdxList{i} = [];
    for j = 1:length(tr)
        if(ismember(PixelIdxList(midx),tr(j).PixelIdxList))
            PixelIdxList = tr(j).PixelIdxList;
            break;
        end
    end
    
    if(isempty(PixelIdxList) || (length(tr) == 0))
        PixelIdxList = [];
        disp('killed a cluster');
        break;
    end
    if((length(PixelIdxList{i}) < 1.25*oldsize) && (tr(j).Solidity >= 0.9) )
        foundit = 1;
    end
    thresh = thresh + 0.001;
    
end

    if (length(PixelIdxList{i}) < MinBlobArea)
        PixelIdxList{i} = [];
        disp(' a cluster got too small');
    end