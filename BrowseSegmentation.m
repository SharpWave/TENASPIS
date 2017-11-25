function [] = BrowseSegmentation(i)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load SegmentationROIs.mat;
load('Blobs.mat','BlobPixelIdxList');
load MovieDims.mat;
global T_MOVIE;

figure(1);set(gcf,'Position',[ 1 1 1920 1000]);
a2 = subplot(2,5,2);




[xidx,yidx] = ind2sub([Xdim Ydim],NeuronPixelIdxList{i});
LPtrace = mean(T_MOVIE(xidx,yidx,1:NumFrames),1);

LPtrace = squeeze(mean(LPtrace));
LPtrace = convtrim(LPtrace,ones(10,1)/10);

figure(1);

subplot(2,5,6:10);
a = find(NeuronActivity(i,:));

plot(LPtrace);hold on;
plot(a,LPtrace(a),'ro','MarkerFaceColor','r');axis tight;
[~,b] = findpeaks(LPtrace,'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
plot(b,LPtrace(b),'ks');hold off;

%plot(convtrim(NeuronTraces.CorrR(i,:),ones(1,10)/10));
hold off;title('fluorescence trace');

% plot the blobs
a3 = subplot(2,5,3);
tempframe = zeros(Xdim,Ydim);
for j = 1:length(b)
    tempframe = tempframe+T_MOVIE(:,:,b(j));
end
tempframe = tempframe/length(b);
imagesc(tempframe);
set(gca,'YDir','normal');
hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;axis image;title('ALL peak average');caxis([0 max(tempframe(NeuronPixelIdxList{i}))]);colorbar;

% plot the blobs
a4 = subplot(2,5,4);
tempframe = zeros(Xdim,Ydim);
ovl = 0;
for j = 1:length(b)
    if(intersect(b(j),NeuronFrameList{i}) > 0)
        tempframe = tempframe+mean(T_MOVIE(:,:,b(j)-2:b(j)+2),3);
        ovl = ovl + 1;
    end
end
tempframe = tempframe/ovl;
imagesc(tempframe);
set(gca,'YDir','normal');
hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;axis image;title('seg peak average');caxis([0 max(tempframe(NeuronPixelIdxList{i}))]);colorbar;
segframe = tempframe;

a1 = subplot(2,5,1);
for j = 1:length(NeuronFrameList{i})
    FrameNum = NeuronFrameList{i}(j);
    ObjNum = NeuronObjList{i}(j);
    
    temp = zeros(Xdim,Ydim);
    temp(BlobPixelIdxList{FrameNum}{ObjNum}) = temp(BlobPixelIdxList{FrameNum}{ObjNum}) + 1;
    PlotRegionOutline(temp);hold on;
end
set(gca,'YDir','normal');
hold off;axis image;


subplot(2,5,2);
for j = 1:NumNeurons
    if((length(intersect(NeuronPixelIdxList{j},NeuronPixelIdxList{i}))> 0)&& (i ~= j))
        PlotRegionOutline(NeuronImage{j});hold on;
    end
end
pl = PlotRegionOutline(NeuronImage{i},'g');hold off;
pl{1}.LineWidth = 4;
axis image;

rp = regionprops(NeuronImage{i},'Centroid');



for j = 1:length(b)
    
    a5 = subplot(2,5,5);
    mv = mean(T_MOVIE(:,:,b(j)-2:b(j)+2),3);
    imagesc(mv);axis image;caxis([0 max(mv(NeuronPixelIdxList{i}))]);colorbar;set(gca,'YDir','normal');
    hold on;PlotRegionOutline(NeuronImage{i},'r');hold off;
    linkaxes([a1 a2 a3 a4 a5],'xy');axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
    
    subplot(2,5,6:10);hold on;
    ppt = plot(b(j),LPtrace(b(j)),'mo','MarkerSize',8,'MarkerFaceColor','m');hold off;
    
    [~,m1] = imgradient(mv);
    [~,m2] = imgradient(segframe);
    phasediffs = angdiff(deg2rad(m1(NeuronPixelIdxList{i})),deg2rad(m2(NeuronPixelIdxList{i})));
    PhaseError = rad2deg(mean(abs(phasediffs))),
    title(num2str(PhaseError));
    pause;
end




end

