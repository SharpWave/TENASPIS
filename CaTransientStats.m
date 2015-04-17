function [ output_args ] = CaTransientStats( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load InitClu.mat; %c Xdim Ydim seg Xcent Ycent frames MeanNeuron meanareas meanX meanY NumEvents Invalid overlap

display('Calculating transient distance');
CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);

for i = 1:length(c)
    NeuronPixels{i} = find(MeanNeuron{i});
    NumPixels(i) = length(NeuronPixels{i});
end
    



parfor i = 1:length(c)
    i
    PixelPctOverlap(i,:) = CalcPixelOverlaps(i,NeuronPixels);

end

keyboard;


end

