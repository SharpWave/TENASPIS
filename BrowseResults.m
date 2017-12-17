function [outputArg1,outputArg2] = BrowseResults()

load('PlaceMaps2.mat')
load('Reduced.mat');
[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');

NumROIs = size(FT,1);

NewStart = FToffset-1;
NewEnd = length(LPtrace{1})%-(FToffset-(length(LPtrace{1})-length(smspeed)));

for i = 1:size(FT,1)
    a = find(FT(i,:));
    ax1 = subplot(2,5,1:4);
    plot(y);hold on;plot(a,y(a),'r*');axis tight;hold off;
    yl = get(gca,'YLim');
    subplot(2,5,5);
    imagesc(realPL{i}');set(gca,'YDir','normal','YLim',yl);axis equal;
    
    ax2 = subplot(2,5,6:9);
    trace = LPtrace{i}(NewStart:NewEnd);
    plot(trace);
    axis tight;hold on;
    plot(a,trace(a),'*');
    hold off;
    linkaxes([ax1 ax2],'x');
    
    subplot(2,5,10);
    [minyidx,minxidx] = ind2sub([Xdim,Ydim],PixelIdxList{i}(ceil(length(PixelIdxList{i})/2)));
    imagesc(GoodPeakAvg{i});hold on;PlotRegionOutline(PixelIdxList{i},'r');hold off;axis([minxidx-40 minxidx+40 minyidx-40 minyidx+40]);
    maxavg = max(GoodPeakAvg{i}(PixelIdxList{i}));
    caxis([0 maxavg]);title(num2str(maxavg));
    pause;
    
end

