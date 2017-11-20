function [] = BrowseSegmentation()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load SegmentationROIs.mat;
load('Blobs.mat','BlobPixelIdxList');
load MovieDims.mat;

for i = 1:NumNeurons
    figure(1);
    subplot(2,2,3:4);
    a = find(NeuronActivity(i,:));
    yyaxis left;
    plot(NeuronTraces.LPtrace(i,:));hold on;
    plot(a,NeuronTraces.LPtrace(i,a),'ro','MarkerFaceColor','r');axis tight;hold off;
    yyaxis right;
    plot(convtrim(NeuronTraces.CorrR(i,:),ones(1,10)/10));
    hold off;
    a1 = subplot(2,2,1);
    % plot the blobs
    for j = 1:length(NeuronFrameList{i})
      FrameNum = NeuronFrameList{i}(j);
      ObjNum = NeuronObjList{i}(j);
      
      temp = zeros(Xdim,Ydim);
      temp(BlobPixelIdxList{FrameNum}{ObjNum}) = temp(BlobPixelIdxList{FrameNum}{ObjNum}) + 1;
      PlotRegionOutline(temp);hold on;
    end
    hold off;axis image;
    a2 = subplot(2,2,2);
    PixFreq = CalcPixFreq(NeuronFrameList{i},NeuronObjList{i},BlobPixelIdxList);
    imagesc(PixFreq);colorbar; axis image;set(gca,'YDir','normal');linkaxes([a1 a2],'xy');
    pause;
end
    keyboard;

end

