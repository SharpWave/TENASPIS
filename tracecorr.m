function [CorrTrace] = tracecorr(tempFrame,ROIavg,NeuronPixels)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    for j = 1:length(NeuronPixels)
        CorrTrace(j) = corr(tempFrame(NeuronPixels{j}),ROIavg{j}(NeuronPixels{j}));
    end

end

