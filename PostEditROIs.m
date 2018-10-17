function [outputArg1,outputArg2] = PostEditROIs()

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
load UngarbagedROIs.mat;
load ROIcorr.mat;

threshold = sqrt(0.75); % magic number is minimum explained variance
NumROIs = length(CircMask);


blankframe = zeros(Xdim,Ydim,'single');
GoodROI = ones(1,NumROIs);
CorrIsolation = zeros(1,NumROIs);


for i = 1:NumROIs
    % plot the corrmap into a 2-d array and threshold
    corrblobframe = blankframe;
    corrblobframe(CircMask{i}) = (ROIcorrR{i} > threshold);

    % find the blob containing the centroid
    rp = regionprops(corrblobframe,'PixelIdxList');
    FoundIt = 0;
    for j = 1:length(rp)
      LIA = ismember(PixelIdxList{i},rp(j).PixelIdxList);
      if (sum(LIA) == length(PixelIdxList{i}));
          FoundIt = j;
          break;
      end
    end
    
    if (FoundIt == 0)
        GoodROI(i) = 0;
        CorrBlobIdx{i} = [];        
    else
        CorrBlobIdx{i} = rp(FoundIt).PixelIdxList;
        OutsidePixels = setdiff(CircMask{i},CorrBlobIdx{i});
        corrblobframe(CircMask{i}) = ROIcorrR{i}.*(ROIcorrR{i} > 0);
        OutsideValues = corrblobframe(OutsidePixels);
        CorrIsolation(i) = 1-mean(OutsideValues);
    end     

end

figure(1);
for i = 1:NumROIs
    if (GoodROI(i))
        PlotRegionOutline(PixelIdxList{i},'g');
        
    else
        PlotRegionOutline(PixelIdxList{i},'r');
    end
end

% pare things down according to the decision
GoodIdx = find(GoodROI);
display(['kept ',int2str(sum(GoodROI)),' transients out of ',int2str(NumROIs)])

BigPixelAvg = BigPixelAvg(GoodIdx);
CircMask = CircMask(GoodIdx);
FrameList = FrameList(GoodIdx);
ObjList = ObjList(GoodIdx);
PixelAvg = PixelAvg(GoodIdx);
PixelIdxList = PixelIdxList(GoodIdx);
ROIcorrP = ROIcorrP(GoodIdx);
ROIcorrR = ROIcorrR(GoodIdx);
Trans2ROI = Trans2ROI(GoodIdx);
Xcent = Xcent(GoodIdx);
Ycent = Ycent(GoodIdx);
CorrBlobIdx = CorrBlobIdx(GoodIdx);
CorrIsolation = CorrIsolation(GoodIdx);

display('Calculating Overlaps and saving');

Overlaps = CalcOverlaps(PixelIdxList);

% save stuff

save EvenBetterROIs.mat BigPixelAvg CircMask FrameList ObjList PixelAvg PixelIdxList ROIcorrP ROIcorrR Trans2ROI Xcent Ycent CorrBlobIdx CorrIsolation Overlaps;


end

