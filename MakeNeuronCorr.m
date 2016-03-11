function [ output_args ] = MakeNeuronCorr(trace,frames,PixelList)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all;
radius = 50;

[~,Xdim,Ydim,NumFrames] = loadframe('DFF.h5',1);
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
    i/length(frames)
    frame = loadframe('SLPDF.h5',frames(i));
    DataMat(:,:,i) = frame(xMin:xMax,yMin:yMax);
    
    
end

figure;imagesc(sum(DataMat,3));

for i = 1:size(DataMat,1)
    for j = 1:size(DataMat,2)
        rval(i,j) = corr(squeeze(DataMat(i,j,:)),trace(frames)');
    end
end
figure;imagesc(rval);caxis([0 1]);colorbar;



