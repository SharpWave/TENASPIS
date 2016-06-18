function [] = MakeROIcorrtraces()
load ProcOut.mat;
load ROIavg.mat;

% Initialize progress bar
p=ProgressBar(NumFrames);
disp('Calculating traces for each neuron')
for i = 1:NumFrames
    
    % Read in each frame
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
 
    % Sum up the number of pixels active in each frame for each neuron
    for j = 1:NumNeurons
        CorrTrace(j,i) = corr(tempFrame(NeuronPixels{j}),ROIavg{j}(NeuronPixels{j}));
    end
    p.progress; % Update progress bar
end
p.stop;
save CorrTrace.mat CorrTrace;
