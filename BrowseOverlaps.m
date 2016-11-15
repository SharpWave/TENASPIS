function [ output_args ] = BrowseOverlaps(moviefile,NeuronID,cx )
close all;

% load basic shit
load FinalOutput.mat;
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
blankframe = zeros(Xdim,Ydim,'single');
t = (1:NumFrames)/20;

display('checking buddies');
buddies = [];
for i = 1:NumNeurons
    Overlap(i) = length(intersect(NeuronPixelIdxList{NeuronID},NeuronPixelIdxList{i}))./min(length(NeuronPixelIdxList{NeuronID}),length(NeuronPixelIdxList{i}));

    if ((i ~= NeuronID)&& (Overlap(i) > 0))
        buddies = [buddies,i];
    end
end

figure(5);histogram(jsim(NeuronID,:),40);

figure(1);
a(1) = subplot(length(buddies)+1,1,1);
plot(NeuronTraces.LPtrace(NeuronID,:));hold on;
act = NP_FindSupraThresholdEpochs(PSAbool(NeuronID,:),eps);
for j = 1:size(act,1)
    plot(act(j,1):act(j,2),NeuronTraces.LPtrace(NeuronID,act(j,1):act(j,2)),'-r','LineWidth',2);
end
axis tight
for i = 1:length(buddies)
    a(i+1) = subplot(length(buddies)+1,1,i+1);
    plot(NeuronTraces.LPtrace(buddies(i),:));hold on;
    act = NP_FindSupraThresholdEpochs(PSAbool(buddies(i),:),eps);
    for j = 1:size(act,1)
        plot(act(j,1):act(j,2),NeuronTraces.LPtrace(buddies(i),act(j,1):act(j,2)),'-r','LineWidth',2);
    end
    farsims = sort(jsim(NeuronID,Overlap == 0));
    idx = findclosest(farsims,jsim(NeuronID,buddies(i)));
    normrank = idx/length(find(Overlap == 0));
    
    title([int2str(buddies(i)),' Overlap % ',num2str(Overlap(buddies(i))),' dws similarity: ',num2str(jsim(NeuronID,buddies(i))),' pct ',num2str(normrank)]);
    axis tight;
end
linkaxes(a,'x');
set(gcf,'Position',[437    49   883   948])

figure(3);
fb(1) = subplot(length(buddies)+1,1,1);
temp = blankframe;
temp(NeuronPixelIdxList{NeuronID}) = NeuronAvg{NeuronID};
imagesc(temp);axis image;hold on;caxis([0 max(NeuronAvg{NeuronID})]);
[b] = bwboundaries(NeuronImage{NeuronID});
b = b{1};
plot(b(:,2),b(:,1),'g');
for i = 1:length(buddies)
    [b] = bwboundaries(NeuronImage{buddies(i)});colormap gray;
    b = b{1};
    plot(b(:,2),b(:,1),'r');
end
for i = 1:length(buddies)
    fb(i+1) = subplot(length(buddies)+1,1,i+1);
    temp = blankframe;
    temp(NeuronPixelIdxList{buddies(i)}) = NeuronAvg{buddies(i)};
    imagesc(temp);
    max(NeuronAvg{buddies(i)}),
    axis image;hold on;
    try caxis([0 max(NeuronAvg{buddies(i)})]);end
    [b] = bwboundaries(NeuronImage{buddies(i)});colormap gray;
    b = b{1};
    plot(b(:,2),b(:,1),'r');
    [b] = bwboundaries(NeuronImage{NeuronID});
    b = b{1};
    plot(b(:,2),b(:,1),'g');
end

linkaxes(fb,'xy');
set(gcf,'Position',[437    49   883   948])

while(1)
    pause;
    figure(1)
    display('pick a time to see the frame')
    [mx,my] = ginput(1);
    f = LoadFrames(moviefile,round(mx));
    figure(2);set(gcf,'Position',[1130         337         773         600]);
    
    imagesc(f);caxis(cx);
    hold on
    [b] = bwboundaries(NeuronImage{NeuronID});
    b = b{1};
    plot(b(:,2),b(:,1),'g');
    for i = 1:length(buddies)
        [b] = bwboundaries(NeuronImage{buddies(i)});colormap gray;
        b = b{1};
        plot(b(:,2),b(:,1),'r');
    end
    hold off;
end

