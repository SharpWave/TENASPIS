function [ output_args ] = BrowseOverlaps(moviefile,NeuronID,cx )
close all;

% load basic shit


load FinalTraces.mat;
load('FinalOutput.mat');
load MeanT.mat;

NumFrames = size(FT,2);
NumNeurons = size(FT,1);

t = (1:NumFrames)/20;

display('checking buddies');
buddies = [];
for i = 1:NumNeurons
  Overlap(i) = length(intersect(NeuronPixels{NeuronID},NeuronPixels{i}))./length(union(NeuronPixels{NeuronID},NeuronPixels{i}));
  CaCorr(i) = corr(FT(NeuronID,:)',FT(i,:)');
  pix = union(NeuronPixels{i},NeuronPixels{NeuronID});
  [MeanTCorr(i),MeanTp(i)] = corr(MeanT{i}(pix),MeanT{NeuronID}(pix));
  
  if ((i ~= NeuronID)&& (Overlap(i) > 0))
      buddies = [buddies,i];
  end
end

figure(1);
a(1) = subplot(length(buddies)+1,1,1);
plot((rawtrace((NeuronID),:)));hold on;plot(FT((NeuronID),:)*0.02);axis tight;

for i = 1:length(buddies)
    a(i+1) = subplot(length(buddies)+1,1,i+1);
    plot((rawtrace((buddies(i)),:)));hold on;plot(FT(buddies(i),:)*0.02,'-r');title([int2str(buddies(i)),' ',num2str(Overlap(buddies(i))),' ',num2str(CaCorr(buddies(i))),' ',num2str(MeanTCorr(buddies(i))),' ',num2str(MeanTp(buddies(i)))]);
    axis tight;
end
linkaxes(a,'x');
set(gcf,'Position',[437    49   883   948])

while(1)
    pause;
    figure(1)
    display('pick a time to see the frame')
    [mx,my] = ginput(1);
    f = loadframe(moviefile,mx);
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

