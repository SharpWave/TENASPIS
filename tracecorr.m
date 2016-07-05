function CorrTrace = tracecorr(tempFrame,ROIavg,NeuronPixels)
%CorrTrace = tracecorr(tempFrame,ROIavg,NeuronPixels)
%   
%   Correlates the ROI from a frame to the average spike-triggered ROI
%   calculated from MakeROIavg. 
%

%% Correlate ROI. 
    nNeurons = length(NeuronPixels);
    CorrTrace = zeros(1,nNeurons);
    for j = 1:nNeurons
        CorrTrace(j) = corr(tempFrame(NeuronPixels{j}),ROIavg{j}(NeuronPixels{j}));
    end

end

