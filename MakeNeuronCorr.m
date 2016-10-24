function [rval,pval,AvgN] = MakeNeuronCorr(trace,frames,PixelList,toplot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all;
radius = 50;

if ~exist('toplot','var')
    toplot = 0;
end

[~,Xdim,Ydim,NumFrames] = loadframe('SLPDF.h5',1);
temp = zeros(Xdim,Ydim);
temp(PixelList) = 1;
b = bwconncomp(temp,4);
r = regionprops(b,'Centroid');
centroid = round(r.Centroid);

xMin = max(1,centroid(2)-radius);
xMax = min(Xdim,centroid(2)+radius);

yMin = max(1,centroid(1)-radius);
yMax = min(Ydim,centroid(1)+radius);

DataMat = zeros(xMax-xMin+1,yMax-yMin+1,length(frames));

for i = 1:length(frames)
    i/length(frames);
    frame = loadframe('DFF.h5',frames(i));
    DataMat(:,:,i) = frame(xMin:xMax,yMin:yMax);
end

AvgN = sum(DataMat,3);


for i = 1:size(DataMat,1)
    for j = 1:size(DataMat,2)
        [rval(i,j),pval(i,j)] = corr(squeeze(DataMat(i,j,:)),trace(frames)');
    end
end

if (toplot)
    figure;imagesc(AvgN);
    figure;imagesc(rval);caxis([0 1]);colorbar;
end



