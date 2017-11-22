function [] = BrowseTransientROIs()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load TransientROIs.mat;
load('Blobs.mat','BlobPixelIdxList');
load MovieDims.mat;

NumNeurons = length(FrameList);

global T_MOVIE;

for i = 7800:NumNeurons
    figure(1);
    subplot(3,4,5:8);
    a = FrameList{i};
    yyaxis left;
    
    % create trace
    [xidx,yidx] = ind2sub([Xdim Ydim],PixelIdxList{i});
    LPtrace = mean(T_MOVIE(xidx,yidx,:));
    LPtrace = squeeze(mean(LPtrace));
    LPtrace = convtrim(LPtrace,ones(10,1)/10);
    
    plot(LPtrace);hold on;
    plot(a,LPtrace(a),'ro','MarkerFaceColor','r');axis tight;
    [~,b] = findpeaks(LPtrace,'MinPeakDistance',5,'MinPeakProminence',max(LPtrace)/4,'MinPeakHeight',0.005)
    plot(b,LPtrace(b),'ks');
    hold off;
    yyaxis right;
    %plot(convtrim(NeuronTraces.CorrR(i,:),ones(1,10)/10));
    hold off;
    a1 = subplot(3,4,1);
    % plot the blobs
    for j = 1:length(FrameList{i})
      FrameNum = FrameList{i}(j);
      ObjNum = ObjList{i}(j);
      
      temp = zeros(Xdim,Ydim);
      temp(BlobPixelIdxList{FrameNum}{ObjNum}) = temp(BlobPixelIdxList{FrameNum}{ObjNum}) + 1;
      PlotRegionOutline(temp);hold on;
    end
    title(['final area = ',int2str(length(PixelIdxList{i}))]);
    
    hold off;axis image;
    set(gca,'YDir','normal');
    a2 = subplot(3,4,2);
    PixFreq = CalcPixFreq(FrameList{i},ObjList{i},BlobPixelIdxList);
    imagesc(PixFreq); axis image;set(gca,'YDir','normal');
    set(gca,'YDir','normal');
    [~,maxidx] = max(LPtrace(a));
    maxidx = maxidx+a(1)-1;
    
    
    a3 = subplot(3,4,3);imagesc(T_MOVIE(:,:,maxidx));axis image;caxis([0 max(LPtrace(a))]);title('transient peak');
    hold on;
    temp = zeros(Xdim,Ydim);
    temp(PixelIdxList{i}) = 1;
    PlotRegionOutline(temp,'r');hold off;
    set(gca,'YDir','normal');
    closestpeak = findclosest(a(end),b);
    
    a4 = subplot(3,4,4);imagesc(T_MOVIE(:,:,b(closestpeak)));axis image;caxis([0 max(LPtrace(a))]);title('nearest trace peak');hold on;
    PlotRegionOutline(temp,'r');hold off;
    set(gca,'YDir','normal');
    
    
    % plot the first 4 trace peaks
    a5 = subplot(3,4,9);imagesc(T_MOVIE(:,:,b(1)));axis image;caxis([0 max(LPtrace(a))]);title('first peak');hold on;
    PlotRegionOutline(temp,'r');hold off;
    set(gca,'YDir','normal');
    
    a6 = subplot(3,4,10);imagesc(T_MOVIE(:,:,b(2)));axis image;caxis([0 max(LPtrace(a))]);title('2nd peak');hold on;
    PlotRegionOutline(temp,'r');hold off;
    set(gca,'YDir','normal');
    
     a7 = subplot(3,4,11);imagesc(T_MOVIE(:,:,b(3)));axis image;caxis([0 max(LPtrace(a))]);title('3nd peak');hold on;
    PlotRegionOutline(temp,'r');hold off;
    set(gca,'YDir','normal');
    
         a8 = subplot(3,4,12);imagesc(T_MOVIE(:,:,b(4)));axis image;caxis([0 max(LPtrace(a))]);title('4nd peak');hold on;
    PlotRegionOutline(temp,'r');hold off;
    set(gca,'YDir','normal');
    
    linkaxes([a1 a2 a3 a4 a5 a6 a7 a8],'xy');
    set(gcf,'Position',[6         212        1837         766]);
    if((abs(maxidx-b(closestpeak)) <= 3) || (ismember(b(closestpeak),a)))
        disp('Good');
    else
        disp('Bad');
    end
    pause;
end
    keyboard;

end

