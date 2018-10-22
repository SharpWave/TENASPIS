function [] = VisualSegmentFrame(f)
Set_T_Params('MotCorr.h5');
load singlesessionmask.mat;
[BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = SegmentFrame(f,PrepMask);
hold on;
for i = 1:length(BlobPixelIdxList)
    PlotRegionOutline(BlobPixelIdxList{i});
end