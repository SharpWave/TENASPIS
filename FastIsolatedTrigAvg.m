function [ output_args ] = FastIsolatedTrigAvg(FT,NeuronPixels)

info = h5info('SLPDF.h5','/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

WindowLen = 1;

NumNeurons = size(FT,1);

Overlap = zeros(NumNeurons,NumNeurons);
NewFT = zeros(size(FT));

display('computing Overlaps');

for i = 1:NumNeurons
    for j = 1:NumNeurons
        if (~isempty(intersect(NeuronPixels{i},NeuronPixels{j})))
            Overlap(i,j) = 1;
        end
    end
    Neighbors{i} = setdiff(find(Overlap(i,:)),i);
    TrigAvg{i} = zeros(Xdim,Ydim);
end

display('excluding spatiotemporally contiguous transients');

for i = 1:NumNeurons
    trs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    OrigAct(i) = size(trs,1);
    AdjAct(i) = 0;
    for j = 1:size(trs,1)
        trstart = max(trs(j,2)-(NumFrames-1),trs(j,1));
        NeighborSpikes = sum(sum(FT(Neighbors{i},trs(j,1):trs(j,2))));
        if (NeighborSpikes == 0)
            AdjAct(i) = AdjAct(i)+1;
            NewFT(i,trstart:trs(j,2)) = 1;
        end
    end
end

display('calculating triggered averages');
p = ProgressBar(NumFrames); % Initialize progress bar
for i = 1:NumFrames
    ActiveN = find(NewFT(:,i));
    if(~isempty(ActiveN))
        frame = loadframe('SLPDF.h5',i,info);
        for j = 1:length(ActiveN)
            TrigAvg{ActiveN(j)} = TrigAvg{ActiveN(j)}+frame;
        end
    end
    
    p.progress; % update progress bar
end
p.stop;
for i = 1:NumNeurons
    TrigAvg{i} = TrigAvg{i}./sum(NewFT(i,:));
end

save TrigAvg.mat TrigAvg NewFT OrigAct AdjAct;


