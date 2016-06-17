function [] = MakeROIcorrtraces()

disp('Loading relevant variables from ProcOut')
load('ProcOut.mat','NeuronImage','NumFrames','NeuronPixels');
load('TvP.mat','MeanT');

% Get image dimensions and number of neurons
Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);
NumNeurons = length(NeuronImage);

% Initialize progress bar
p=ProgressBar(NumFrames);
disp('Calculating traces for each neuron')
parfor i = 1:NumFrames
    
    % Read in each frame
    tempFrame = h5read(moviefile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
 
    % Sum up the number of pixels active in each frame for each neuron
    for j = 1:length(MeanT)
        CorrTrace(j,i) = corr(tempFrame(NeuronPixels{j}),MeanT{ROIidx(j)}(NeuronPixels{j}));
    end
    p.progress; % Update progress bar
end