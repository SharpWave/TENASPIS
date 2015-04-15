function [ output_args ] = PlotNeuronOutlines(MeanNeuron,NeuronsToPlot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure;
if (nargin < 2)
    NeuronsToPlot = 1:length(MeanNeuron)
end

for i = NeuronsToPlot
    
b = bwboundaries(MeanNeuron{i});
x{i} = b{1}(:,1);
y{i} = b{1}(:,2);
plot(y{i},x{i});hold on;
end

end

