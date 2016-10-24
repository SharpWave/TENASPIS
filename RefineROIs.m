function [ output_args ] = RefineROIs(TrigAvg,AdjAct,NeuronPixels,FT)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

thresh = 0.01;

GoodROI = find(AdjAct > 0);
TrigAvg = TrigAvg(GoodROI);
oldNeuronPixels = NeuronPixels(GoodROI);
FT = FT(GoodROI,:);
clear NeuronPixels;

BadROI = [];

GoodMatch = zeros(1,length(oldNeuronPixels));

for i = 1:length(oldNeuronPixels)
    b = bwconncomp((TrigAvg{i} > thresh),4);
    matches = [];
    for j = 1:b.NumObjects
        if (~isempty(intersect(b.PixelIdxList{j},oldNeuronPixels{i})))
           matches = [matches,j];
        end
    end
    
    GoodMatch(i) = (length(matches) == 1);
    
    if (~GoodMatch(i))
        continue;
    end
    
    NeuronPixels{i} = b.PixelIdxList{matches};
    NeuronImage{i} = zeros(size(TrigAvg{1}));
    NeuronImage{i}(NeuronPixels{i}) = 1;
        
    
end
gm = find(GoodMatch);
NeuronImage = NeuronImage(gm);
NeuronPixels = NeuronPixels(gm);
FT = FT(gm,:);

save RefinedROIs.mat NeuronImage NeuronPixels FT;

