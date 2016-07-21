function MergeROIs(FT,NeuronPixels,MeanT)

load('ProcOut.mat','Xdim','Ydim');

[NumNeurons,NumFrames] = size(FT);
OverlapThresh = 0.2;
CorrThresh = 0.2;
CorrpThresh = 0.05;



%t = (1:NumFrames)/20;
ToMerge = zeros(NumNeurons,NumNeurons);
MergeDest = zeros(1,NumNeurons);
newFT = FT;

% Determine Merges
display('determining merges');

%Preallocate. 
Overlap = zeros(NumNeurons);
MeanTCorr = zeros(NumNeurons);
MeanTp = zeros(NumNeurons);
p = ProgressBar(NumNeurons); % Initialize progress bar
for i = 1:NumNeurons
    for j = 1:NumNeurons
        Overlap(i,j) = length(intersect(NeuronPixels{j},NeuronPixels{i}))./length(union(NeuronPixels{j},NeuronPixels{i}));
        if (Overlap(i,j) <= OverlapThresh)
            continue;
        end
        pix = union(NeuronPixels{i},NeuronPixels{j});
        [MeanTCorr(i,j),MeanTp(i,j)] = corr(MeanT{i}(pix),MeanT{j}(pix),'type','Spearman');
        if ((MeanTCorr(i,j) > CorrThresh) && (MeanTp(i,j) < CorrpThresh) && (i ~= j))
            ToMerge(i,j) = 1;
            
        end        
    end
    MergeDest(i) = i;
    p.progress;
end
p.stop;

NP = NeuronPixels;

display('performing merges');
for i = 1:NumNeurons
    for j = (i+1):NumNeurons
        if (ToMerge(i,j))
            % try to merge j into i
            newDest = MergeDest(i);
            while(newDest ~= MergeDest(newDest))
                newDest = MergeDest(newDest);
            end
            display(['merging ',int2str(newDest),' ',int2str(j)]);
            NP{newDest} = union(NP{j},NP{newDest});
            newFT(newDest,:) = newFT(newDest,:) | newFT(j,:);
            MergeDest(j) = newDest;
        end
    end
end

clear NeuronPixels;
clear FT;

curr = 1;
for i = 1:NumNeurons
    if (MergeDest(i) == i)
        NeuronPixels{curr} = NP{i};
        NeuronImage{curr} = zeros(Xdim,Ydim);
        NeuronImage{curr}(NP{i}) = 1;
        FT(curr,:) = newFT(i,:);
        curr = curr+1;
    end
end

save('FinalOutput.mat', 'NeuronPixels', 'NeuronImage', 'FT', '-v7.3');




            

