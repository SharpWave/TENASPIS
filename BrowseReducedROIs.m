function [] = BrowseTransientROIs(i)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load Reduced.mat;

load MovieDims.mat;

NumNeurons = length(PixelIdxList);

global T_MOVIE;
Overlaps = CalcOverlaps(PixelIdxList);

%for i = 1:length(PixelIdxList);


figure(1);
set(gcf,'Position',[2 348 1911 648]);
subplot(2,3,4:6);
plot(LPtrace{i});axis tight;hold on;
plot(GoodPeaks{i},LPtrace{i}(GoodPeaks{i}),'ro','MarkerSize',6,'MarkerFaceColor','r');
[~,b] = findpeaks(LPtrace{i},'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
plot(b,LPtrace{i}(b),'ko','MarkerSize',10);
hold off;

a1 = subplot(2,3,1);
imagesc(GoodPeakAvg{i});
set(gca,'YDir','normal');
hold on;PlotRegionOutline(PixelIdxList{i},'g');hold off;axis image;
title(['ROI peak average: ',int2str(length(b))]);
caxis([0 max(GoodPeakAvg{i}(PixelIdxList{i}))]);colorbar;

a2 = subplot(2,3,2);
imagesc(GoodPeakAvg{i});
set(gca,'YDir','normal');
caxis([0.003 max(GoodPeakAvg{i}(PixelIdxList{i}))]);colorbar;
hold on;PlotRegionOutline(PixelIdxList{i},'g');
nbrs = find(Overlaps(i,:));
goodnbrs = [];
for j = 1:length(nbrs)
    if(Overlaps(i,nbrs(j)) > length(PixelIdxList{i})/8)
        PlotRegionOutline(PixelIdxList{nbrs(j)});
        goodnbrs = [goodnbrs,nbrs(j)];
    end
end

hold off;axis image;




AllPeaks = sort(union(b,GoodPeaks{i}));
IsDup = zeros(1,length(AllPeaks));
% sometimes peak locations get offset by a few samples, need to
% eliminate duplicates created this way
for j = 2:length(IsDup)
    if(AllPeaks(j)-AllPeaks(j-1) <= 10)
        %disp('found duplicate!!');
        IsDup(j) = 1;
        AllPeaks(j) = -5;
    end
end
AllPeaks = AllPeaks(~IsDup);

clear s;

figure(2);
subplot(length(goodnbrs)+1,5,1:4);
plot(LPtrace{i});axis tight;hold on;
plot(GoodPeaks{i},LPtrace{i}(GoodPeaks{i}),'ro','MarkerSize',6,'MarkerFaceColor','r');
[~,b] = findpeaks(LPtrace{i},'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
plot(b,LPtrace{i}(b),'ko','MarkerSize',10);
hold off;
s(1) = subplot(length(goodnbrs)+1,5,5);
imagesc(GoodPeakAvg{i});
set(gca,'YDir','normal');
hold on;PlotRegionOutline(PixelIdxList{i},'g');hold off;axis image;
%title(['ROI peak average: ',int2str(length(b))]);
caxis([0 max(GoodPeakAvg{i}(PixelIdxList{i}))]);colorbar;

temp = zeros(Xdim,Ydim);
temp(PixelIdxList{i}) = 1;
rp = regionprops(temp,'Centroid');

for j = 1:length(goodnbrs)
    jidx = goodnbrs(j);
    subplot(length(goodnbrs)+1,5,1+j*5:4+j*5);
    plot(LPtrace{jidx});axis tight;hold on;
    plot(GoodPeaks{jidx},LPtrace{jidx}(GoodPeaks{jidx}),'ro','MarkerSize',6,'MarkerFaceColor','r');
    [~,b] = findpeaks(LPtrace{jidx},'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
    plot(b,LPtrace{jidx}(b),'ko','MarkerSize',10);
    hold off;
    s(j+1) = subplot(length(goodnbrs)+1,5,5+j*5);
    imagesc(GoodPeakAvg{jidx});
    set(gca,'YDir','normal');
    hold on;
    PlotRegionOutline(PixelIdxList{i},'g');
    PlotRegionOutline(PixelIdxList{jidx},'r');
    hold off;axis image;
    %title(['ROI peak average: ',int2str(length(b))]);
    caxis([0 max(GoodPeakAvg{jidx}(PixelIdxList{jidx}))]);colorbar;
    linkaxes(s,'xy');
    axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
end

set(gcf,'Position',[1921          41        1920         963]);
length(GoodPeaks{i})/length(AllPeaks),
figure(1);
for j = 1:length(AllPeaks)
    mv = mean(T_MOVIE(:,:,AllPeaks(j)-2:AllPeaks(j)+2),3);
    a3 = subplot(2,3,3);
    imagesc(mv);axis image;caxis([0.005 max(mv(PixelIdxList{i}))]);colorbar;set(gca,'YDir','normal');
    hold on;PlotRegionOutline(PixelIdxList{i},'g');hold off;
    linkaxes([a1 a2 a3],'xy');
    
    axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
    
    subplot(2,3,4:6);hold on;
    plot(AllPeaks(j),LPtrace{i}(AllPeaks(j)),'ko','MarkerSize',2,'MarkerFaceColor','k');hold off;
    
    pause;
end
end
