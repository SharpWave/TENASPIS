function [] = MakeAllNeuronCorr(FT,traces,NeuronPixels)

NumNeurons = size(FT,1);
for i = 1:NumNeurons
    i/NumNeurons
    frames = find(FT(i,:));
    frames = frames(1:2:end);
    [rval{i},pval{i},AvgN{i}] = MakeNeuronCorr(traces(i,:),frames,NeuronPixels{i});
end
save NeuronCorrProc.mat rval pval AvgN
keyboard;


