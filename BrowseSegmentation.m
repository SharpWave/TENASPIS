function [] = BrowseSegmentation(i)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load SegmentationROIs.mat;
load('Blobs.mat','BlobPixelIdxList');
load MovieDims.mat;
global T_MOVIE;

figure(1);set(gcf,'Position',[ 1 1 1920 1000]);
a2 = subplot(2,6,2);




[xidx,yidx] = ind2sub([Xdim Ydim],NeuronPixelIdxList{i});
LPtrace = mean(T_MOVIE(xidx,yidx,1:NumFrames),1);

LPtrace = squeeze(mean(LPtrace));
LPtrace = convtrim(LPtrace,ones(10,1)/10);

figure(1);

subplot(2,6,7:12);
a = find(NeuronActivity(i,:));

plot(LPtrace);hold on;
plot(a,LPtrace(a),'ro','MarkerFaceColor','r');axis tight;
[~,b] = findpeaks(LPtrace,'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
plot(b,LPtrace(b),'ks');hold off;

%plot(convtrim(NeuronTraces.CorrR(i,:),ones(1,10)/10));
hold off;ylabel('fluorescence trace');

% plot the blobs
a3 = subplot(2,6,3);
tempframe = zeros(Xdim,Ydim);
for j = 1:length(b)
    tempframe = tempframe+T_MOVIE(:,:,b(j));
end
tempframe = tempframe/length(b);
imagesc(tempframe);
set(gca,'YDir','normal');
hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;axis image;
title(['ALL peak average: ',int2str(length(b))]);
caxis([0.005 max(tempframe(NeuronPixelIdxList{i}))]);colorbar;

% plot the blobs
a4 = subplot(2,6,4);
tempframe = zeros(Xdim,Ydim);
ovl = 0;
peakavg = 0;

for j = 1:length(b)
    if(intersect(b(j),NeuronFrameList{i}) > 0)
        tempframe = tempframe+mean(T_MOVIE(:,:,b(j)-2:b(j)+2),3);
        ovl = ovl + 1;
        peakavg = peakavg+LPtrace(b(j));
    end
end
peakavg = peakavg/ovl;
tempframe = tempframe/ovl;
imagesc(tempframe);
set(gca,'YDir','normal');
hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;axis image;
title(['seg peak average: ',int2str(ovl)]);
caxis([0.005 max(tempframe(NeuronPixelIdxList{i}))]);colorbar;
segframe = tempframe;

a1 = subplot(2,6,1);
for j = 1:length(NeuronFrameList{i})
    FrameNum = NeuronFrameList{i}(j);
    ObjNum = NeuronObjList{i}(j);
    
    temp = zeros(Xdim,Ydim);
    temp(BlobPixelIdxList{FrameNum}{ObjNum}) = temp(BlobPixelIdxList{FrameNum}{ObjNum}) + 1;
    PlotRegionOutline(temp);hold on;
end
set(gca,'YDir','normal');
hold off;axis image;
title('segmentation outlines');

subplot(2,6,2);
for j = 1:NumNeurons
    if((length(intersect(NeuronPixelIdxList{j},NeuronPixelIdxList{i}))> 0)&& (i ~= j))
        PlotRegionOutline(NeuronImage{j});hold on;
    end
end
pl = PlotRegionOutline(NeuronImage{i},'g');hold off;
pl{1}.LineWidth = 4;
axis image;
title('Overlapping ROIs');
rp = regionprops(NeuronImage{i},'Centroid');


% Calculate which peaks are ok
MaxError = 25;

GoodPeakAvg = zeros(Xdim,Ydim);
GoodPeak = zeros(1,length(b));

for j = 1:length(b)    
    
    mv = mean(T_MOVIE(:,:,b(j)-2:b(j)+2),3);    
    [~,m1] = imgradient(mv);
    [~,m2] = imgradient(segframe);
    phasediffs = angdiff(deg2rad(m1(NeuronPixelIdxList{i})),deg2rad(m2(NeuronPixelIdxList{i})));
    PhaseError = rad2deg(mean(abs(phasediffs)));
    if (PhaseError <= MaxError)
        GoodPeak(j) = 1;
        GoodPeakAvg = GoodPeakAvg + mv;
        subplot(2,6,7:12);hold on;plot(b(j),LPtrace(b(j)),'og','MarkerSize',15);
    end
end
GoodPeakAvg = GoodPeakAvg./sum(GoodPeak);
a6 = subplot(2,6,6);
imagesc(GoodPeakAvg);
set(gca,'YDir','normal');
hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;axis image;
title(['total peaks: ',int2str(sum(GoodPeak))]);
caxis([0.005 max(GoodPeakAvg(NeuronPixelIdxList{i}))]);colorbar;

subplot(2,6,7:12);
title(['seg peak / trace standard dev: ',num2str(peakavg/std(LPtrace))]);
for j = 1:length(b)
    a5 = subplot(2,6,5);
    mv = mean(T_MOVIE(:,:,b(j)-2:b(j)+2),3);
    imagesc(mv);axis image;caxis([0.005 max(mv(NeuronPixelIdxList{i}))]);colorbar;set(gca,'YDir','normal');
    hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;
    linkaxes([a1 a2 a3 a4 a5 a6],'xy');axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
    subplot(2,6,7:12);hold on;
    ppt = plot(b(j),LPtrace(b(j)),'mo','MarkerSize',8,'MarkerFaceColor','m');hold off;
    [~,m1] = imgradient(mv);
    [~,m2] = imgradient(segframe);
    phasediffs = angdiff(deg2rad(m1(NeuronPixelIdxList{i})),deg2rad(m2(NeuronPixelIdxList{i})));
    PhaseError = rad2deg(mean(abs(phasediffs)));
    subplot(2,6,5);
    title(['peak error = ',num2str(PhaseError)]);
    pause;

end

