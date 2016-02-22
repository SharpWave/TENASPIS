function [ output_args ] = Calc_pPeak()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
load('ProcOut.mat','NeuronPixels','NumNeurons','FT','NumFrames');

for i = 1:NumNeurons
    pPeak{i} = zeros(size(NeuronPixels{i}));
end

for i = 1:NumFrames
    i
    ActiveN = find(FT(:,i));
    [frame] = loadframe('DFF.h5',i);
    for j = 1:length(ActiveN)
        idx = ActiveN(j);
        [val,maxid] = max(frame(NeuronPixels{idx}));
        pPeak{idx}(maxid) = pPeak{idx}(maxid) + 1;
    end
end

for i = 1:NumNeurons
    pPeak{i} = pPeak{i}./sum(FT(i,:));
end

save pPeak.mat pPeak;

end

