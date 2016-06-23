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
    subplot(1,6,1:4);plot(t,rawtrace(i,:));hold on;
    plot(t,rawtrace(i,:).*FT(i,:),'-r');axis tight;hold off;title(int2str(i));
    subplot(1,6,5);imagesc(MeanT{i});axis image;hold on;
    outline = bwboundaries(NeuronImage{i});
    plot(outline{1}(:,2),outline{1}(:,1),'-g');hold off;
    c = regionprops(NeuronImage{i},'Centroid');
    Centroid = c.Centroid;
    maxc = max(MeanT{i}(NeuronPixels{i}));
    axis([Centroid(1)-50 Centroid(1)+50 Centroid(2)-50 Centroid(2)+50])
    caxis([0 maxc]);title(num2str(maxc));
    subplot(1,6,6);imagesc(TMap{i});axis image;
    pause;
end
