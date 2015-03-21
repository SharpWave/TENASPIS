function [] = ProcessSegs(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim, todebug)
% [] = ProcessSegs(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim)
%   Detailed explanation goes here
close all;

if (exist('InitClu.mat','file') == 0)
    InitializeClusters(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim);
end

if (nargin < 8)
    todebug = 0;
end
  

load InitClu.mat;
  
NumMerges = 10;
RadiusMultiplier = [(1:10)/40,(1:10)/30];

OverlapThresh = 0.85:-0.01:0.80

for i = 1:length(OverlapThresh)
    [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeCluIntersect(RadiusMultiplier(i),c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap,OverlapThresh(i));
    if (todebug)
        CluToPlot = unique(c);
        
        mc{i} = zeros(Xdim,Ydim);
        for j = CluToPlot'
            temp = find(MeanNeuron{j} == 1);
            
            temp2 = zeros(Xdim,Ydim);
            temp2(temp) = 1;
            mc{i} = mc{i}+temp2;
        end
        figure;imagesc(mc{i});title(['radius ',num2str(RadiusMultiplier(i))]);colorbar
        
    end
    NumClu(i) = length(unique(c));
end

keyboard;
for i = 1:length(RadiusMultiplier)
    [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeClu(RadiusMultiplier(i),c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);
    if (todebug)
        CluToPlot = unique(c);
        
        mc{i+length(OverlapThresh)} = zeros(Xdim,Ydim);
        for j = CluToPlot'
            temp = find(MeanNeuron{j} == 1);
            
            temp2 = zeros(Xdim,Ydim);
            temp2(temp) = 1;
            mc{i+length(OverlapThresh)} = mc{i+length(OverlapThresh)}+temp2;
        end
        figure;imagesc(mc{i+length(OverlapThresh)});title(['radius ',num2str(RadiusMultiplier(i))]);colorbar
        
    end
    NumClu(i+length(OverlapThresh)) = length(unique(c));
end
figure;plot(NumClu);
if (todebug)
    save mc.mat mc -v7.3;
end

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

