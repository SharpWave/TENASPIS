function [CorrTrace] = tracecorr(tempFrame,ROIavg,NeuronPixels)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    CorrTrace = zeros(1,length(NeuronPixels));
    for j = 1:length(NeuronPixels)
        CorrTrace(j) = corr(tempFrame(NeuronPixels{j}),ROIavg{j});
    end

end

