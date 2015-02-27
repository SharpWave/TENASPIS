function [] = ExtractTraces(NumICA,MinThreshPixels)
% ExtractTraces v 0.90 9/19/2014
% Using Inscopix Mosaic generated IC files and a DF/F corrected movie,
% generate accurate, sensitive traces for the cells

close all;

% "Magic numbers"
MicronsPerPix = 1.22; % correctish
SR = 20; % Sampling rate in Hz
OutNoiseRad = 40; % Radius from cell center to calculate Noise

if (nargin == 1)
    MinThreshPixels = 60;
end

% Load the independent components, edit them if this is the first time
[ICThresh,IC,NumICA,x,y] = EditICA(NumICA,MinThreshPixels); % 

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Calculating signal masks'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create new IC filters with values less than ICThresh zeroed
% This isolates the pixels that are part of the neuron
figure;hold on;
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

% initialize trace matrices
SignalTrace = zeros(NumICA,NumFrames);
NoiseTrace = zeros(NumICA,NumFrames);

parfor i = 1:NumFrames
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  tempFrame = h5read('FLmovie.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
  SignalTrace(:,i) = innerloop(tempFrame,NumICA,ICnz,x,y);
  NoiseTrace(:,i) = noiseloop(tempFrame,NumICA,NoiseMasknz);
end

FT = PolishTraces(SignalTrace,NoiseTrace);

%save backup.mat
save FinalTraces.mat FT NumICA IC ICnz x y t c NumFrames; 
keyboard;
end

function [noisevals] = noiseloop(tempFrame,NumICA,NoiseMasknz);
  for i = 1:NumICA
      vals = tempFrame(NoiseMasknz{i});
      vals = sort(vals);
      noisevals(i) = mean(vals(1:ceil(length(vals)/20)));
  end
end

function [tracevals] = innerloop(tempFrame,NumICA,ICnz,x,y)
tracevals = zeros(NumICA,1);
vals = [];
idx = [];

% find active cells in frame
[frame,cc] = SegmentFrame(tempFrame);

% find overlaps between detected active cells and ICs
%cc.Numobjects
for j = 1:cc.NumObjects % for each detected "segment"
    [tvals,tidx] = findfitscore(ICnz,cc.PixelIdxList{j},NumICA,1);
    % tvals is list of fit values
    % tidx is list of IC indices
    vals = [vals,tvals];
    idx = [idx,tidx];
end

% idx is list of all of the ICs that were either completely covered by a
% segment or were the most covered by a particular segment

% if IC is active, assign value
for m = 1:NumICA % for each IC
    [inset,loc] = ismember(m,idx); % see if IC is in idx. loc is position
    
    if (inset == 0)
        % not in idx, leave alone
        continue;
    end
    
    if(vals(loc) > 0.25) % there was at least a 25% overlap
        temp = tempFrame(ICnz{m});
        tracevals(m) = mean(temp(:));
    end
end
end


function [fitscores,fitidx] = findfitscore(a,b,Num,thresh)
    % calculate what percentage of the elements in a are also in b. all values
    % and indices that are greater than thresh, otherwise return the max
    
    for i = 1:Num % for each IC
        common = intersect(a{i},b);
        fitscores(i) = length(common)/length(a{i});
    end
    
    goodscores = find(fitscores >= thresh); % list of ICs with at least thresh covered
    
    if (~isempty(goodscores)) % there was at least one
        fitscores = fitscores(goodscores); % all the scores that were greater than 0
        fitidx = goodscores;
        return;
    else
        [fitscores,fitidx] = max(fitscores);
        if (sum(fitscores) == 0)
            fitscores = [];
            fitidx = [];
        end
        return;
    end
end

  
  