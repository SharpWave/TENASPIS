function [] = CheckFinalOutput()

load FinalTraces.mat;
load MeanT.mat;
load FinalOutput.mat;
load ('PlaceMaps.mat','TMap');

close all;
figure(1);
set(gcf,'Position',[8         753        1855         225]);

NumNeurons = size(FT,1);
NumFrames = size(FT,2);
t = (1:NumFrames)/20;

for i = 1:NumNeurons
    outline{i} = bwboundaries(NeuronImage{i});
end

for i = 1:NumNeurons
    subplot(1,6,1:4);plot(t,rawtrace(i,:));hold on;
    plot(t,rawtrace(i,:).*FT(i,:),'-r');axis tight;hold off;title(int2str(i));
    subplot(1,6,5);imagesc(MeanT{i});axis image;hold on;
    for j = 1:NumNeurons
        plot(outline{j}{1}(:,2),outline{j}{1}(:,1),'-g');
    end
    plot(outline{i}{1}(:,2),outline{i}{1}(:,1),'-g');hold off;
    c = regionprops(NeuronImage{i},'Centroid');
    Centroid = c.Centroid;
    maxc = max(MeanT{i}(NeuronPixels{i}));
    axis([Centroid(1)-25 Centroid(1)+25 Centroid(2)-25 Centroid(2)+25])
    caxis([0 maxc]);title(num2str(maxc));
    subplot(1,6,6);imagesc(TMap{i});axis image;
    pause;
end
