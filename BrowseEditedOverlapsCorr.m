function [] = BrowseEditedOverlapsCorr()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load ROImerge.mat;

NumROIs = length(CircMask);
figure(1);
CorrThresh = sqrt(0.75);

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

for i = 1:NumROIs
    OverlapList = find(Overlaps(i,:));
    
    
    subplot(2,3,1);hold on; % ROI i brightness
    a = zeros(Xdim,Ydim);
    a(CircMask{i}) = BigPixelAvg{i};
    imagesc(a);
    axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
    %caxis([0 max(PixelAvg{i})]);colorbar;
    PlotRegionOutline(PixelIdxList{i},'g');hold off;
    
    subplot(2,3,2);hold on;
    a(CircMask{i}) = ROIcorrR{i};
    imagesc(a);
    axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
    caxis([-1 1]);colorbar;
    PlotRegionOutline(PixelIdxList{i},'g');hold off;
    
    subplot(2,3,3);hold on;
    imagesc(a);
    axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
    caxis([CorrThresh 1]);colorbar;
    PlotRegionOutline(PixelIdxList{i},'g');hold off;
    
    for j = 1:length(OverlapList)
        t = OverlapList(j);
        
        subplot(2,3,4);hold on; % ROI i brightness
        a = zeros(Xdim,Ydim);
        a(CircMask{t}) = BigPixelAvg{t};
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        %caxis([0 max(PixelAvg{t})]);colorbar;
        PlotRegionOutline(PixelIdxList{i},'g');
        PlotRegionOutline(PixelIdxList{t},'r');hold off;
        
        subplot(2,3,5);hold on;
        a(CircMask{t}) = ROIcorrR{t};
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([-1 1]);colorbar;
        PlotRegionOutline(PixelIdxList{i},'g');
        PlotRegionOutline(PixelIdxList{t},'r');hold off;
        
        subplot(2,3,6);hold on;
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([CorrThresh 1]);colorbar;
        PlotRegionOutline(PixelIdxList{i},'g');
        PlotRegionOutline(PixelIdxList{t},'r');hold off;
        pause;
    end
    
    
end

