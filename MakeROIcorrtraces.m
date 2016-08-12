function MakeROIcorrtraces(NeuronPixels,ROIavg,moviefile)
%MakeROIcorrtraces(NeuronPixels,ROIavg,moviefile)
%
%   Correlates the pixel intensity of each neuron's ROI with its
%   spike-triggered average ROI. 
%
%   INPUTS
%       NeuronPixels: ROI (in linear indices) of each neuron. 
%       
%       ROIavg: Output of MakeROIavg. 1xN cell array each containing Xdim x
%       Ydim arrays depicting the average of what the frame looks like for
%       each neuron when they're active. 
%
%       moviefile: Move file (SLPDF.h5).
%
%   OUTPUTS
%       Saves to CorrTrace.mat.
%       
%       CorrTrace: NxF matrix where each entry is the Pearson correlation
%       rho for a given neuron's ROI at a given frame. 
%
%       fCorrTrace: Smoothed (convolved) version of CorrTrace.

%% Correlate traces. 
info = h5info(moviefile,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

disp('Calculating traces for each neuron');
nNeurons = length(ROIavg); 
CorrTrace = zeros(nNeurons,NumFrames); 
fCorrTrace = zeros(nNeurons,NumFrames);

% Initialize progress bar
resol = 5;                                  % Percent resolution for progress bar, in this case 5%
update_inc = round(NumFrames/(100/resol));  % Get increments for updating ProgressBar
p = ProgressBar(100/resol);
parfor i = 1:NumFrames
    
    % Read each frame then correlate ROI to target ROI.
    tempFrame = loadframe(moviefile,i,info);
    tempFrame = tempFrame(:);
    CorrTrace(:,i) = tracecorr(tempFrame,ROIavg,NeuronPixels);

    if round(i/update_inc) == (i/update_inc)
        p.progress;
    end
end
p.stop;

%% Smooth.
parfor i = 1:length(NeuronPixels)
    fCorrTrace(i,:) = convtrim(CorrTrace(i,:),ones(1,10)./10);
end

%% Save.
save CorrTrace.mat CorrTrace fCorrTrace;

end