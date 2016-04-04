function [] = NormalTraces(moviefile)
% This function takes the ROI output of ExtractNeurons2015 and extracts
% traces in the straightfoward-most way.  Mostly for validation of the new
% tech
close all;

% Step 1: load up the ROIs
disp('Loading relevant variables from ProcOut')
load('ProcOut.mat','NeuronImage','NumFrames','NeuronPixels');

% Get image dimensions and number of neurons
Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);
NumNeurons = length(NeuronImage);

trace = zeros(NumNeurons,NumFrames); 
% Initialize progress bar
p=ProgressBar(NumFrames);
disp('Calculating traces for each neuron');
parfor i = 1:NumFrames
    
    % Read in each frame
    tempFrame = h5read(moviefile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
 
    % Sum up the number of pixels active in each frame for each neuron
    for j = 1:NumNeurons
        trace(j,i) = sum(tempFrame(NeuronPixels{j}));
    end
    p.progress; % Update progress bar
end
p.stop; % Terminate progress bar

difftrace = zeros(size(trace)); 
disp('Smoothing traces and normalizing')
for i = 1:NumNeurons
    trace(i,:) = zscore(trace(i,:)); % Z-score the trace - effectively thresholds trace later in ExpandTransients
    trace(i,:) = convtrim(trace(i,:),ones(10,1)/10); % Convolve the trace with a ten frame rectangular smoothing window, divide by 10
    trace(i,1:11) = 0; % Set 10 first frames to 0
    trace(i,end-11:end) = 0; % Set 10 last frames to 0
    difftrace(i,2:NumFrames) = diff(trace(i,:)); % Get temporal derivative of each trace
    difftrace(i,1:11) = 0; % Set 10 first frames to 0
    difftrace(i,end-11:end) = 0; % Set 10 last frames to 0
end
 
save NormTraces.mat trace difftrace;

end 