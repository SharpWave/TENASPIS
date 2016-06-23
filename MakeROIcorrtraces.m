function [] = MakeROIcorrtraces(NeuronPixels,Xdim,Ydim,NumFrames,ROIavg)

% Initialize progress bar
disp('Calculating traces for each neuron');
p=ProgressBar(NumFrames);

parfor i = 1:NumFrames
    
    % Read in each frame
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
    CorrTrace(:,i) = tracecorr(tempFrame,ROIavg,NeuronPixels);
    % Sum up the number of pixels active in each frame for each neuron

    p.progress; % Update progress bar
end
p.stop;

parfor i = 1:length(NeuronPixels)
    fCorrTrace(i,:) = convtrim(CorrTrace(i,:),ones(1,10)./10);
end

save CorrTrace.mat CorrTrace fCorrTrace;
