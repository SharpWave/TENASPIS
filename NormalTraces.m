function [] = NormalTraces(moviefile)
% This function takes the ROI output of ExtractNeurons2015 and extracts
% traces in the straightfoward-most way.  Mostly for validation of the new
% tech
close all;

% Step 1: load up the ROIs
load('ProcOut.mat','NeuronImage','NumFrames','NeuronPixels');

Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);

NumNeurons = length(NeuronImage);

p=ProgressBar(NumFrames);
parfor i = 1:NumFrames
    
    tempFrame = h5read(moviefile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
 
    
    for j = 1:NumNeurons
        trace(j,i) = sum(tempFrame(NeuronPixels{j}));
    end
    p.progress;
end
p.stop; 

for i = 1:NumNeurons
    trace(i,:) = zscore(trace(i,:));
    trace(i,:) = convtrim(trace(i,:),ones(10,1)/10);
    trace(i,1:11) = 0;
    trace(i,end-11:end) = 0;
    difftrace(i,2:NumFrames) = diff(trace(i,:));
    difftrace(i,1:11) = 0;
    difftrace(i,end-11:end) = 0;
end


save NormTraces.mat trace difftrace;

end 