function [] = EditTransientROIs()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load TransientROIs.mat;
load('Blobs.mat','BlobPixelIdxList');
load MovieDims.mat;

NumNeurons = length(FrameList);

global T_MOVIE;
if(isempty(T_MOVIE))
    disp('load the movie');
    return;
end

p = ProgressBar(NumNeurons);

TraceWinSec = 1500;

for i = 1:NumNeurons
    i / NumNeurons;
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
    
    [~,b] = findpeaks(LPtrace,'MinPeakDistance',10,'MinPeakProminence',max(LPtrace)/4,'MinPeakHeight',0.005);
    
    newa = a-MinWin+1;
    
    [~,segpeakidx] = max(LPtrace(newa));
    segpeakidx = segpeakidx+newa(1)-1; % convert index back to dimensions of LPtrace
    
    closesttrpeak = findclosest(segpeakidx,b);
    closesttrpeak = b(closesttrpeak); % convert index back to dimensions of LPtrace
    
    
    
    
    if((abs(segpeakidx-closesttrpeak) <= 3) || (ismember(closesttrpeak,a)))
        %disp('Good');
        GoodTransient(i) = 1;
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
FrameList = FrameList(GoodTransient);
ObjList = ObjList(GoodTransient);
PixelIdxList = PixelIdxList(GoodTransient);
CircMask = CircMask(GoodTransient);
PixelAvg = PixelAvg(GoodTransient);
Xcent = Xcent(GoodTransient);
Ycent = Ycent(GoodTransient);
BigPixelAvg = BigPixelAvg(GoodTransient);
NumTransients = sum(GoodTransient);
Trans2ROI = 1:NumTransients;

disp('Computing pixel overlaps');
Overlaps = zeros(NumTransients,NumTransients,'single');
MaxDist = 20;

for i = 1:NumTransients
    [xi,yi] = ind2sub([Xdim Ydim],PixelIdxList{i});
    minxi = min(xi);
    minyi = min(yi);
    maxxi = max(xi);
    maxyi = max(yi);
    
    for j = 1:NumTransients
        if (i == j)
            continue;
        end
        if (i > j)
            Overlaps(i,j) = Overlaps(j,i);
            continue;
        end
        CentDist = sqrt((Xcent(i)-Xcent(j)).^2+(Ycent(i)-Ycent(j)).^2);
        if(CentDist > MaxDist)
            continue;
        end
        [xj,yj] = ind2sub([Xdim Ydim],PixelIdxList{j});
        minxj = min(xj);
        minyj = min(yj);
        maxxj = max(xj);
        maxyj = max(yj);
        
        % Make sure everything is in range
        if((minxi <= maxxj) && (minxj <= maxxi) && (minyi <= maxyj) && (minyj <= maxyi))
            Overlaps(i,j) = length(intersect(PixelIdxList{i},PixelIdxList{j}));
        end
    end
end

disp('saving data');
save UngarbagedROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelAvg PixelIdxList BigPixelAvg CircMask Overlaps;

end

