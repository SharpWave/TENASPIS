function [ output_args ] = ProcessSegs(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
close all;

if (exist('InitClu.mat','file') == 0)
    InitializeClusters(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim);
end
  

load InitClu.mat;
  
NumMerges = 10;
RadiusMultiplier = [(1:20)/40];
for i = 1:length(RadiusMultiplier)
    [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeClu(RadiusMultiplier(i),c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);
end

[c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeClu(1,c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);

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
    if (length(find(MeanNeuron{i} > 0.7)) < 10)
        continue;
    end
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


save ProcOut.mat ActiveFrames NeuronImage NeuronPixels OrigMean caltrain NumFrames;

keyboard;





 
end      

% CluDist = pdist([meanX',meanY'],'euclidean');
% CluDist = squareform(CluDist);
% CluToPlot = unique(c);
% 
% % ok now the user interactive part
% for i = CluToPlot'
%   
%   
%   
%   % find all of the reasonably close clusters
%   maxdist = sqrt(meanareas(i)/pi);
% 
%   nearclust = find(CluDist(i,:) < maxdist*1);
%   
%   for j = 1:length(nearclust)
%     if (ismember(nearclust(j),CluToPlot))  
%     figure(4);
%     subplot(1,3,1);imagesc(MeanNeuron{i});title(['Neuron ',int2str(i)]);
%     subplot(1,3,2);imagesc(MeanNeuron{nearclust(j)});title(['target neuron ',int2str(nearclust(j))]);
%     subplot(1,3,3);imagesc(MeanNeuron{i}+MeanNeuron{nearclust(j)});
%     pause;
%     end
%   end
% end