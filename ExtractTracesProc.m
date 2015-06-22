function [] = ExtractTracesProc(moviefile,FLmovie)
% This function takes the ROI output of ExtractNeurons2015 and extracts
% traces in the straightfoward-most way.  Mostly for validation of the new
% tech
close all;

% Step 1: load up the ROIs
load ProcOut.mat;

Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);

NumNeurons = length(NeuronImage);

for i = 1:NumFrames
    i
    tempFrame = h5read(moviefile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
    
    
    tempFrame2 = h5read(FLmovie,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame2 = tempFrame2(:);
    
    
    for j = 1:NumNeurons
        Dtrace(i,j) = sum(tempFrame(NeuronPixels{j}));
        
        Rawtrace(i,j) = sum(tempFrame2(NeuronPixels{j}));
        
    end
end
Dtrace = Dtrace';
Rawtrace = Rawtrace';

save DumbTraces.mat Dtrace Rawtrace;

