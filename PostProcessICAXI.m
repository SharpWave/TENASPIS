function [] = PostProcessICAXI(NumICA,MinThreshPixels)
% this function takes an ICA .mat file as written by Inscopix Mosaic,
% does a bit of post-processing, and hopefully spits out something
% that will form the basis for my continued employment as a scientist

% this version IS EXPERIMENTAL
% way than the initial version.

close all;


% "Magic numbers"

MicronsPerPix = 1.22; % correctish

ICSignalThresh = 15; %[was 25] Dividing line between inside and outside of cell ROI
SR = 20; % Sampling rate in Hz
MaxSignalRad = 6; % maximum radius from middle of ICA for main component

OutNoiseRad = 40; % Outer circle radius of noise ring, big enough to form a complete circle around the signal
InNoiseRad = 7; % Inner circle radius of noise ring, we want some overlap with the signal


if (nargin == 0)
    MinThreshPixels = 60;
end


% Load the independent components
Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Calculating signal masks'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create new IC filters with values less than ICSignalThresh zeroed
% This isolates the pixels that are part of the neuron

for i = 1:NumICA
   l(i) = length(find(IC{i} > ICThresh(i)));
end
figure(1);hist(l,40);xlabel('# pixels in IC');ylabel('# ICs');
LengthGoodidx = find(l > MinThreshPixels);

IC = IC(LengthGoodidx);
x = x(LengthGoodidx);
y = y(LengthGoodidx);
ICThresh = ICThresh(LengthGoodidx);

NumICA = length(IC);

figure(2);hold on;

Sum_Mask = zeros(size(IC{1}));
for i = 1:NumICA
  temp = IC{i};
  temp(find(temp < ICThresh(i))) = 0;
  RawIC{i} = temp;
  temp(find(temp > 0)) = 1;
  ICMask{i} = temp;
  ICnz{i} = find(temp == 1);
  COM{i} = centerOfMass(temp);
  subplot(1,2,1);plot(x{i},y{i});hold on;
  Sum_Mask = Sum_Mask+ICMask{i};
end

subplot(1,2,2);imagesc(Sum_Mask);set(gca,'YDir','normal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Calculating noise masks'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:NumICA
  c = COM{i};

  % Identify a ring of pixels around the center
  for k = 1:Xdim
      for l = 1:Ydim
         pixdist = norm([k l]-c);
         RingMask{i}(k,l) = (pixdist < OutNoiseRad);
      end
  end  
  RingMasknz{i} = find(RingMask{i}(:) > 0);

  NoiseMask_idx{i} = setdiff(RingMasknz{i},ICnz{i});
  NoiseMask{i} = zeros(size(IC{1}));
  NoiseMask{i}(NoiseMask_idx{i}) = 1;
  NoiseMasknz{i} = find(NoiseMask{i} > 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Loading movie data'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MovieData dims are X,Y,T
info = h5info('FLmovie.h5','/Object');
NumFrames = info.Dataspace.Size(3);

t = (1:NumFrames)/SR;

smwin = hann(SR/2)./sum(hann(SR/2)); % 500ms smoothing window

% initialize trace matrices
SignalTrace = zeros(NumICA,NumFrames);
NoiseTrace = zeros(NumICA,NumFrames);

figure(999);

for i = 1:NumICA
    meanIC{i} = zeros(size(IC{1}));
end
NumDetected = zeros(1,NumICA);

for i = 1:NumFrames
    
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  tempFrame = h5read('FLmovie.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
  [SignalTrace(:,i),meanIC,NumDetected] = innerloop(tempFrame,NumICA,ICnz,x,y,SignalTrace,i,meanIC,NumDetected);
  NoiseTrace(:,i) = noiseloop(tempFrame,NumICA,NoiseMasknz);
  
  
end
save backup.mat
keyboard;
end

function [noisevals] = noiseloop(tempFrame,NumICA,NoiseMasknz);
  for i = 1:NumICA
      vals = tempFrame(NoiseMasknz{i});
      vals = sort(vals);
      noisevals(i) = mean(vals(1:ceil(length(vals)/20)));
  end
end

function [tracevals,meanIC,NumDetected] = innerloop(tempFrame,NumICA,ICnz,x,y,SignalTrace,traceend,meanIC,NumDetected)
  tracevals = zeros(NumICA,1);
  [frame,cc] = SegmentFrame(tempFrame);
  
  vals = [];
  idx = [];
  for j = 1:cc.NumObjects
      [tvals,tidx] = findfitscore(ICnz,cc.PixelIdxList{j},NumICA,1);
      
      vals = [vals,tvals];
      idx = [idx,tidx];
  end
  


  for m = 1:NumICA
      [inset,loc] = ismember(m,idx);
      if (inset == 0)
          continue;
      end
      
      if(vals(loc) > 0.25)
          NumDetected(m) = NumDetected(m)+1;
          
          meanIC{m} = meanIC{m} + tempFrame;
%           if (traceend > 80)
%               figure(999);subplot(2,3,1);imagesc(tempFrame);colormap gray;caxis([0 0.2]);hold on;plot(x{m},y{m});hold off;
%               subplot(2,3,2);imagesc(frame);hold on;plot(x{m},y{m});hold off;display(['Fit Score: ',num2str(vals(loc))]);
%               subplot(2,3,3);imagesc(meanIC{m}./NumDetected(m));colormap(gray);caxis([0 0.2]);hold on;
%               for s = 1:NumICA
%                   plot(x{s},y{s});
%               end
%               plot(x{m},y{m},'-r','LineWidth',4);
%               hold off;
%               subplot(2,3,4:6),plot(SignalTrace(m,1:traceend));axis tight;
%               pause;
%           end
          temp = tempFrame(ICnz{m});
          tracevals(m) = mean(temp(:));
      end
  end
end


function [fitscores,fitidx] = findfitscore(a,b,Num,thresh)
    % calculate what percentage of the elements in a are in b. all values
    % and indices that are greater than thresh, otherwise return the max
    
    for i = 1:Num
        common = intersect(a{i},b);
        fitscores(i) = length(common)/length(a{i});
    end
    
    goodscores = find(fitscores >= thresh);
    if (~isempty(goodscores))
        fitscores = fitscores(goodscores);
        fitidx = goodscores;
        return;
    else
        [fitscores,fitidx] = max(fitscores);
        return;
    end
end

  
  