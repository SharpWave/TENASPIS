function [] = MakeAllNeuronCorr(FT,traces,NeuronPixels)

NumNeurons = size(FT,1);
for i = 1:NumNeurons
    nc{i} = MakeNeuronCorr(traces(i,:),find(FT(i,:)),NeuronPixels{i});
end


