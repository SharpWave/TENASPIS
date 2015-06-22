function [] = ExtractTracesBlob(moviefile,FLmovie)
% This function takes the ROI output of ExtractNeurons2015 and extracts
% traces in the straightfoward-most way.  Mostly for validation of the new
% tech
close all;

% Step 1: load up the ROIs
load ProcOut.mat;
load MeanBlobs.mat;

Xdim = size(BinBlobs{1},1);
Ydim = size(BinBlobs{1},2);

NumNeurons = length(BinBlobs);

for i = 1:NumFrames
    if(~mod(i,1000))
        display([num2str(i/NumFrames),' of the way done']);
    end
    
    tempFrame = h5read(moviefile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
    
    
    tempFrame2 = h5read(FLmovie,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame2 = tempFrame2(:);
    
    
    for j = 1:NumNeurons
        BDtrace(i,j) = sum(tempFrame(NeuronPixels{j}));
        
        BRawtrace(i,j) = sum(tempFrame2(NeuronPixels{j}));
        
    end
end
BDtrace = BDtrace';
BRawtrace = BRawtrace';

save MeanBlobTraces.mat BDtrace BRawtrace;

