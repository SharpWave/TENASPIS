function MakeROIcorrtraces(NeuronPixels,Xdim,Ydim,NumFrames,ROIavg)
%MakeROIcorrtraces(NeuronPixels,Xdim,Ydim,NumFrames,ROIavg)
%
%   Correlates the pixel intensity of each neuron's ROI with its
%   spike-triggered average ROI. 
%
%   INPUTS
%       NeuronPixels: ROI (in linear indices) of each neuron. 
%
%       Xdim/Ydim: X and Y dimensions of the image. 
%
%       NumFrames: Number of frames. 
%       
%       ROIavg: Output of MakeROIavg. 1xN cell array each containing Xdim x
%       Ydim arrays depicting the average of what the frame looks like for
%       each neuron when they're active. 
%
%   OUTPUTS
%       Saves to CorrTrace.mat.
%       
%       CorrTrace: NxF matrix where each entry is the Pearson correlation
%       rho for a given neuron's ROI at a given frame. 
%
%       fCorrTrace: Smoothed (convolved) version of CorrTrace.

%% Correlate traces. 
% Initialize progress bar
disp('Calculating traces for each neuron');
nNeurons = length(ROIavg); 
CorrTrace = zeros(nNeurons,NumFrames); 
fCorrTrace = zeros(nNeurons,NumFrames);

p=ProgressBar(NumFrames);
parfor i = 1:NumFrames
    
    % Read each frame then correlate ROI to target ROI.
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
    CorrTrace(:,i) = tracecorr(tempFrame,ROIavg,NeuronPixels);

    p.progress; % Update progress bar
end
p.stop;

%% Smooth.
parfor i = 1:length(NeuronPixels)
    fCorrTrace(i,:) = convtrim(CorrTrace(i,:),ones(1,10)./10);
end

%% Save.
save CorrTrace.mat CorrTrace fCorrTrace;

end