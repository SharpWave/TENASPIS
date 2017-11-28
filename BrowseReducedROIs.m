function [] = BrowseTransientROIs()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load Reduced.mat;

load MovieDims.mat;

NumNeurons = length(PixelIdxList);

global T_MOVIE;

for i = 1:length(PixelIdxList);
    [xidx,yidx] = ind2sub([Xdim Ydim],PixelIdxList{i});
    LPtrace{i} = mean(T_MOVIE(xidx,yidx,1:NumFrames),1);
    LPtrace{i} = squeeze(mean(LPtrace{i}));
    LPtrace{i} = convtrim(LPtrace{i},ones(10,1)/10);
    
    figure(1);
    subplot(2,2,3:4);
    plot(LPtrace{i});axis tight;hold on;
    plot(GoodPeaks{i},LPtrace{i}(GoodPeaks{i}),'ro','MarkerSize',6,'MarkerFaceColor','r');
    [~,b] = findpeaks(LPtrace{i},'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
    plot(b,LPtrace{i}(b),'ko','MarkerSize',10);
    hold off;
    
    subplot(2,1,1);
    imagesc();
    set(gca,'YDir','normal');
    hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;axis image;
    title(['ALL peak average: ',int2str(length(b))]);
    caxis([0.005 max(tempframe(NeuronPixelIdxList{i}))]);colorbar;
    
    fig
    GridLength = ceil(sqrt(length(b)));
end
