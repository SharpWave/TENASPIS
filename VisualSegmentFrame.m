function [NumBlobs,t] = VisualSegmentFrame(f)
Set_T_Params('MotCorr.h5');
load singlesessionmask.mat;
tic
[BlobPixelIdxList,BlobWeightedCentroids,BlobMinorAxisLength] = SegmentFrame(f,neuronmask);
t = toc;
figure;imagesc(f);colormap gray; caxis([-0.01 0.1]);
hold on;
NumBlobs = length(BlobPixelIdxList);
for i = 1:length(BlobPixelIdxList)
    PlotRegionOutline(BlobPixelIdxList{i});
end