function [ output_args ] = PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%figure;

if (nargin < 4)
    clusterlist = 1:length(PixelList)
end

if(~isrow(clusterlist))
    clusterlist = clusterlist';
end

colors = rand(length(clusterlist),3);

for i = 1:length(clusterlist)
    i/length(clusterlist)
    temp = zeros(Xdim,Ydim);
    temp(PixelList{i}) = 1;
    b = bwboundaries(temp);
    x{i} = b{1}(:,1);
    y{i} = b{1}(:,2);
    plot(y{i},x{i},'Color',colors(clusterlist(i),:));hold on;
end
hold off;
end

