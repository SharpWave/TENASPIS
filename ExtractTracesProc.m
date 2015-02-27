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
  
  if (nargin >1)
    tempFrame2 = h5read(FLmovie,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame2 = tempFrame2(:);
  end
    
  for j = 1:NumNeurons
      FT(i,j) = sum(tempFrame(NeuronPixels{j}));
      if (nargin > 1)
          FT2(i,j) = sum(tempFrame2(NeuronPixels{j}));
      end
  end



end
t = (1:NumFrames)/20;
keyboard;
for i = 1:NumNeurons
  subplot(3,3,1:3);
  plotyy(t,FT(:,i).*(caltrain{i} > 0)',t,FT2(:,i)-min(FT2(:,i)));axis tight;
  activations = NP_FindSupraThresholdEpochs(caltrain{i},0.1,1);
  for j = 1:min(6,size(activations,1))
      subplot(3,3,j+3);
      tempFrame = h5read(moviefile,'/Object',[1 1 activations(j,1) 1],[Xdim Ydim 1 1]);
      imagesc(tempFrame);colormap gray;
  end
  pause;
end
  
keyboard;

