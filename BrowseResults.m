function [outputArg1,outputArg2] = BrowseResults()

load('PlaceMaps2.mat')
load('Reduced.mat');

NumROIs = size(FT,1);

NewStart = FToffset-1;
NewEnd = length(LPtrace{1})%-(FToffset-(length(LPtrace{1})-length(smspeed)));


keyboard;


for i = 1:size(FT,1)
    a = find(FT(i,:));
    subplot(2,5,1:4);
    plot(y);hold on;plot(a,y(a),'r*');axis tight;hold off;
    yl = get(gca,'YLim');
    subplot(2,5,5);
    imagesc(realPL{i}');set(gca,'YDir','normal','YLim',yl);
    
    subplot(2,5,6:9);
    trace = LPtrace{i}(NewStart:NewEnd);
    plot(trace);
    axis tight;hold on;
    plot(a,trace(a),'*');
    hold off;
    pause;
    
end

