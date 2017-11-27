function [] = EditTransientROIs()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load TransientROIs.mat;
load('BlobLinks.mat','BlobPixelIdxList');
load MovieDims.mat;

NumNeurons = length(FrameList);

global T_MOVIE;
if(isempty(T_MOVIE))
    disp('load the movie');
    return;
end

p = ProgressBar(NumNeurons);

TraceWinSec = 600;

GoodTransient = zeros(1,NumNeurons);

for i = 1:NumNeurons    
    a = FrameList{i};
    NumBlobs = length(a);
    
    % set a window around the transient to calculate the trace
    MinWin = a(1)-TraceWinSec;
    MaxWin = a(1)+TraceWinSec;
    
    if((a(1)-TraceWinSec) < 1)
        % window would go off left edge
        MinWin = 1;
        MaxWin = TraceWinSec*2+1;
    end
    
    if((a(1)+TraceWinSec) > NumFrames)
        MaxWin = NumFrames;
        MinWin = NumFrames-(TraceWinSec*2+1)+1;
    end
    
    if (NumFrames < (TraceWinSec*2+1))
        MinWin = 1;
        MaxWin = NumFrames;
    end
    
    tidx = MinWin:MaxWin;
    
    % create trace
    [xidx,yidx] = ind2sub([Xdim Ydim],PixelIdxList{i});
    LPtrace = mean(T_MOVIE(xidx,yidx,tidx),1);
    
    LPtrace = squeeze(mean(LPtrace));
    LPtrace = convtrim(LPtrace,ones(10,1)/10);
    
    [~,b] = findpeaks(LPtrace,'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
    
    newa = a-MinWin+1;
    
    [~,segpeakidx] = max(LPtrace(newa));
    segpeakidx = segpeakidx+newa(1)-1; % convert index back to dimensions of LPtrace
    
    if(isempty(b))
        % if there were actually any peaks, they were really weak and this
        % transient was mis-detected
        GoodTransient(i) = 0;
        continue;
    end
    
    closesttrpeak = findclosest(segpeakidx,b);
    closesttrpeak = b(closesttrpeak); % convert index back to dimensions of LPtrace
    
    
    
    
    if((abs(segpeakidx-closesttrpeak) <= 2) || (ismember(closesttrpeak,newa)))
        %disp('Good');
        GoodTransient(i) = 1;
        
        % limit the transient to the frames within 2 of cloesettrpeak
        gooda = (newa <= closesttrpeak+2) & (newa >= closesttrpeak-2);
        if(sum(gooda) == 0)
            keyboard;
        end
        newa = newa(gooda);
        
        % now average the frames around the peak together.
        mv = mean(T_MOVIE(:,:,newa+MinWin-1),3);
        BigPixelAvg{i} = mv(CircMask{i});
        PixelAvg{i} = mv(PixelIdxList{i});
        [~,idx] = max(PixelAvg{i});
        [Ycent(i),Xcent(i)] = ind2sub([Xdim Ydim],PixelIdxList{i}(idx));
        FrameList{i} = FrameList{i}(gooda);
        ObjList{i} = ObjList{i}(gooda);

    else
        %disp('Bad');
        GoodTransient(i) = 0;
    end

    %     figure(1);plot(LPtrace);hold on;
    %     plot(newa,LPtrace(newa),'-r','LineWidth',2);
    %     plot(b,LPtrace(b),'ko');hold off;GoodTransient(i),
    %     pause;
    p.progress;
end
p.stop;



% edit down all of the variables
FrameList = FrameList(find(GoodTransient));
ObjList = ObjList(find(GoodTransient));
PixelIdxList = PixelIdxList(find(GoodTransient));
CircMask = CircMask(find(GoodTransient));
PixelAvg = PixelAvg(find(GoodTransient));
Xcent = Xcent(find(GoodTransient));
Ycent = Ycent(find(GoodTransient));
BigPixelAvg = BigPixelAvg(find(GoodTransient));
NumTransients = sum(GoodTransient);
Trans2ROI = 1:NumTransients;

disp('Computing pixel overlaps');
MaxDist = 20;

Overlaps = CalcOverlaps(PixelIdxList);

disp('saving data');
save UngarbagedROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelAvg PixelIdxList BigPixelAvg CircMask Overlaps;

end

