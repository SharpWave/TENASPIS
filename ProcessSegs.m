function [] = ProcessSegs(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim)
% [] = ProcessSegs(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim)
%   Detailed explanation goes here
close all;

if (exist('InitClu.mat','file') == 0)
    InitializeClusters(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim);
end
  

load InitClu.mat;
  
NumMerges = 10;
RadiusMultiplier = [(1:20)/160];
for i = 1:length(RadiusMultiplier)
    [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeClu(RadiusMultiplier(i),c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);
end

CluToPlot = unique(c);
mc = zeros(Xdim,Ydim);
for i = CluToPlot'
  temp = find(MeanNeuron{i} > 0.7);
  
  temp2 = zeros(Xdim,Ydim);
  temp2(temp) = 1;
  mc = mc+temp2;
end

figure(8);imagesc(mc);

% OK now unpack these things

CurrClu = 0;
for i = CluToPlot'
%     if (length(find(MeanNeuron{i} > 0.7)) < 10)
%         continue;
%     end
    CurrClu = CurrClu + 1;
    clusegs = find(c == i);
    ActiveFrames{CurrClu} = [];
    for j = clusegs
       ActiveFrames{CurrClu} = [ActiveFrames{CurrClu},frames{j}];
    end
    temp = zeros(Xdim,Ydim);
    temp(find(MeanNeuron{i} > 0.7)) = 1;
    NeuronImage{CurrClu} = temp;
    NeuronPixels{CurrClu} = find(MeanNeuron{i} > 0.7);
    OrigMean{CurrClu} = MeanNeuron{i};
    caltrain{CurrClu} = zeros(1,NumFrames);
    caltrain{CurrClu}(ActiveFrames{CurrClu}) = 1;
end
 
for i = 1:length(caltrain)
    FT(i,:) = caltrain{i};
end

save ProcOut.mat ActiveFrames NeuronImage NeuronPixels OrigMean FT caltrain NumFrames -v7.3;
 
end      

