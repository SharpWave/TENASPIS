function [ po] = CalcPixelOverlaps(idx,NeuronPixels)
%[ po] = CalcPixelOverlaps(idx,MeanNeuron)
%   Detailed explanation goes here
for j = 1:length(NeuronPixels)
    po(1,j) = length(intersect(NeuronPixels{idx},NeuronPixels{j}))/length(NeuronPixels{idx});
end

end

