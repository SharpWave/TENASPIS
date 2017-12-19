function [outputArg1,outputArg2] = BrowseResults()

load('PlaceMaps2.mat')
load('Reduced.mat');
[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
global T_MOVIE;
NumROIs = size(FT,1);

NewStart = FToffset-1;
NewEnd = length(LPtrace{1})%-(FToffset-(length(LPtrace{1})-length(smspeed)));
Overlaps = CalcOverlaps(PixelIdxList,20);

for i = 1:size(FT,1)
    a = find(FT(i,:));
    ax1 = subplot(2,5,1:4);
    plot(y);hold on;plot(a,y(a),'r*');axis tight;hold off;
    yl = get(gca,'YLim');
    
    
    ax2 = subplot(2,5,6:9);
    trace = LPtrace{i}(NewStart:NewEnd);
    plot(trace);
    axis tight;hold on;
    plot(a,trace(a),'*');
    hold off;
    linkaxes([ax1 ax2],'x');
    
    subplot(2,5,10);
    [minyidx,minxidx] = ind2sub([Xdim,Ydim],PixelIdxList{i}(ceil(length(PixelIdxList{i})/2)));
    imagesc(GoodPeakAvg{i});hold on;PlotRegionOutline(PixelIdxList{i},'r');
    ol = find(Overlaps(i,:));
    for j = 1:length(ol)
        PlotRegionOutline(PixelIdxList{ol(j)},'g');
    end
    
    hold off;axis([minxidx-40 minxidx+40 minyidx-40 minyidx+40]);
    maxavg = max(GoodPeakAvg{i}(PixelIdxList{i}));
    caxis([0 maxavg]);title(num2str(maxavg));
    
    disp('hit any key for next neuron or click the mouse to display a frame');
    pause
    w = waitforbuttonpress;
    while (w == 0)
        disp('click for a new frame');
        g = ginput(1);
        subplot(2,5,5);
        frame = squeeze(T_MOVIE(:,:,ceil(g(1))+FToffset));
        imagesc(frame);axis image;hold on;
        PlotRegionOutline(PixelIdxList{i});
        axis([minxidx-40 minxidx+40 minyidx-40 minyidx+40]);
        try
            caxis([0 max(frame(PixelIdxList{i}))]);
        end
        title(num2str(maxavg));hold off;
        disp('hit any key for next neuron or click the mouse to display a frame');
        pause;
        w = waitforbuttonpress;
    end
end

