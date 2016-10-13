function MergeROIs(FT,NeuronPixels,MeanT,NeuronImage,AdjAct)

load('ProcOut.mat','Xdim','Ydim');

NumFrames = size(FT,2);
NumNeurons = size(FT,1);

OverlapThresh = 0.2;
CorrThresh = 0.2;
CorrpThresh = 0.05;



t = (1:NumFrames)/20;
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
            b1 = bwboundaries(NeuronImage{i},4);
            b2 = bwboundaries(NeuronImage{j},4);
            
            figure(1);
            a(1) = subplot(1,3,1);
            imagesc(MeanT{i});axis image;caxis([0 max(MeanT{i}(NeuronPixels{i}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;
            
            a(2) = subplot(1,3,2);
            imagesc(MeanT{j});axis image;caxis([0 max(MeanT{j}(NeuronPixels{j}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;
            
            a(3) = subplot(1,3,3);
            imagesc((MeanT{j}*AdjAct(j)+MeanT{i}*AdjAct(i))./(AdjAct(i)+AdjAct(j)));axis image;caxis([0 max(MeanT{j}(NeuronPixels{j}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;
            
            linkaxes(a);
            MeanTCorr(i,j),MeanTp(i,j),Overlap(i,j),
            
            pause;
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




            

