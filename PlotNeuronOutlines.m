function [ output_args ] = PlotNeuronOutlines(PixelList,Xdim,Ydim,NeuronsToPlot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%figure;

if (nargin < 4)
    NeuronsToPlot = 1:length(PixelList)
end

if(~isrow(NeuronsToPlot))
  NeuronsToPlot = NeuronsToPlot';
end

for i = NeuronsToPlot
temp = zeros(Xdim,Ydim);
temp(PixelList{i}) = 1;
b = bwboundaries(temp);
x{i} = b{1}(:,1);
y{i} = b{1}(:,2);
plot(y{i},x{i});hold on;
end
hold off;
end

