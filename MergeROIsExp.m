function MergeROIs(FT,NeuronPixels,MeanT,MeanTDFF,NeuronImage,AdjAct,TMap,pval)

load('ProcOut.mat','Xdim','Ydim');

NumFrames = size(FT,2);
NumNeurons = size(FT,1);

OverlapThresh = 0.05;
CorrThresh = 0.05;
CorrpThresh = 0.1;

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
%p = ProgressBar(NumNeurons); % Initialize progress bar

MergeDecision = [];
MergeR = [];
MergeP = [];
MergeOverlap = [];
MergeList = [];

for i = 1:NumNeurons
    NumAct(i) = size(NP_FindSupraThresholdEpochs(FT(i,:),eps),1);
end

for i = 1:NumNeurons
    i./NumNeurons,
    for j = 1:NumNeurons
        if (i >= j);
            continue;
        end
        
        Overlap(i,j) = length(intersect(NeuronPixels{j},NeuronPixels{i}))./min(length(NeuronPixels{j}),length(NeuronPixels{i}));
        if (Overlap(i,j) <= OverlapThresh)
            continue;
        end
        pix = union(NeuronPixels{i},NeuronPixels{j});
        [MeanTCorr(i,j),MeanTp(i,j)] = corr(MeanT{i}(pix),MeanT{j}(pix),'type','Spearman');
        
        rptemp = regionprops(NeuronImage{i},'Centroid');
        xc = rptemp.Centroid(1);
        yc = rptemp.Centroid(2);
        
        if ((MeanTCorr(i,j) > CorrThresh) && (MeanTp(i,j) < CorrpThresh) && (i ~= j))
            
            
           
            
            
            
            ToMerge(i,j) = 1;
            b1 = bwboundaries(NeuronImage{i},4);
            b2 = bwboundaries(NeuronImage{j},4);
            
            figure(1);
            a(1) = subplot(3,3,1);
            imagesc(MeanT{i});axis image;caxis([0 max(MeanT{i}(NeuronPixels{i}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;title(int2str(NumAct(i)));

            
            a(2) = subplot(3,3,2);
            imagesc(MeanT{j});axis image;caxis([0 max(MeanT{j}(NeuronPixels{j}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;title(int2str(NumAct(j)));
            
            a(3) = subplot(3,3,3);
            imagesc((MeanT{j}*AdjAct(j)+MeanT{i}*AdjAct(i))./(AdjAct(i)+AdjAct(j)));axis image;caxis([0 max(MeanT{j}(NeuronPixels{j}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;
            
            a(4) = subplot(3,3,4);
            imagesc(MeanTDFF{i});axis image;caxis([0 max(MeanTDFF{i}(NeuronPixels{i}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;title(int2str(NumAct(i)));

            
            a(5) = subplot(3,3,5);
            imagesc(MeanTDFF{j});axis image;caxis([0 max(MeanTDFF{j}(NeuronPixels{j}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;title(int2str(NumAct(j)));
            
            a(6) = subplot(3,3,6);
            imagesc((MeanTDFF{j}*AdjAct(j)+MeanTDFF{i}*AdjAct(i))./(AdjAct(i)+AdjAct(j)));axis image;caxis([0 max(MeanTDFF{j}(NeuronPixels{j}))]);
            hold on;plot(b1{1}(:,2),b1{1}(:,1),'-r');hold off;
            hold on;plot(b2{1}(:,2),b2{1}(:,1),'-r');hold off;
            
            linkaxes(a);
            
%             subplot(3,3,7);
%             imagesc(TMap{i});axis image;title(num2str(pval(i)));
%             
%             subplot(3,3,8);
%             imagesc(TMap{j});axis image;title(num2str(pval(j)));
%             
%             subplot(3,3,9);
%             imagesc(TMap{i}+TMap{j});axis image;
            
            display(['Correlation r value: ',num2str(MeanTCorr(i,j))]);
            display(['Correlation p value: ',num2str(MeanTp(i,j))]);
            display(['ROI overlap: ',num2str(Overlap(i,j))]);
            display(['Num Frames in first ',int2str(sum(FT(i,:)))]);
            display(['Num Frames in second ',int2str(sum(FT(j,:)))]);
            rtemp = corr(FT(i,:)',FT(j,:)');
            display(['Temporal correlation ',num2str(rtemp)]);
            display('HIT ENTER AFTER INSPECTING]');
            pause;
            ToMerge = input('actually merge these two? [y/n] -->','s');
            
            MergeList = [MergeList,{i,j}];
            
            MergeDecision = [MergeDecision,strcmp(ToMerge,'y')];
            MergeOverlap = [MergeOverlap,Overlap(i,j)];
            MergeR = [MergeR,MeanTCorr(i,j)];
            MergeP = [MergeP,MeanTp(i,j)];
            display(['Mean Correlation ',num2str(mean(MergeR(find(MergeDecision))))]);
        end
    end
    MergeDest(i) = i;
    %p.progress;
end

save

p.stop;
keyboard;








%
% NP = NeuronPixels;
%
% display('performing merges');
% for i = 1:NumNeurons
%     for j = (i+1):NumNeurons
%         if (ToMerge(i,j))
%             % try to merge j into i
%             newDest = MergeDest(i);
%             while(newDest ~= MergeDest(newDest))
%                 newDest = MergeDest(newDest);
%             end
%             display(['merging ',int2str(newDest),' ',int2str(j)]);
%             NP{newDest} = union(NP{j},NP{newDest});
%             newFT(newDest,:) = newFT(newDest,:) | newFT(j,:);
%             MergeDest(j) = newDest;
%         end
%     end
% end
%
% clear NeuronPixels;
% clear FT;
%
% curr = 1;
% for i = 1:NumNeurons
%     if (MergeDest(i) == i)
%         NeuronPixels{curr} = NP{i};
%         NeuronImage{curr} = zeros(Xdim,Ydim);
%         NeuronImage{curr}(NP{i}) = 1;
%         FT(curr,:) = newFT(i,:);
%         curr = curr+1;
%     end
% end
%
% save('FinalOutput.mat', 'NeuronPixels', 'NeuronImage', 'FT', '-v7.3');
%
%




