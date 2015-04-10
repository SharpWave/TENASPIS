function [ output_args ] = PlotUnclusteredTransients()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load Segments.mat; % NumSegments SegChain SegList cc NumFrames Xdim Ydim

AllSeg = zeros(Xdim,Ydim);
for i = 1:NumSegments
    % average the pixels in the segment and plot
    AvgSeg = zeros(Xdim,Ydim);
    for j = 1:length(SegChain{i})
        temp = zeros(Xdim,Ydim);
        frame = SegChain{i}{j}(1);
        seg = SegChain{i}{j}(2);
        temp(cc{frame}.PixelIdxList{seg}) = 1;
        AvgSeg = AvgSeg+temp;
    end
    AvgSeg = AvgSeg./length(SegChain{i});
    AllSeg = AllSeg + AvgSeg;
end
figure;imagesc(AllSeg)




end

