function [] = EditTransientROIs()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

close all;
load TransientROIs.mat;
load('BlobLinks.mat','BlobPixelIdxList');
load MovieDims.mat;

NumROIs = length(FrameList);
MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = ceil((MinBlobRadius^2)*pi);

PeakWinLen = 6;

global T_MOVIE;
assert(~isempty(T_MOVIE), 'load the movie');

ToPlot = false;
p = ProgressBar(NumROIs);

TraceWinSec = 600;

GoodTransient = zeros(1,NumROIs);

NumTransients = 0;

for i = 1:NumROIs
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
    olda = a-MinWin+1;
    
    % create trace
    LPtrace = CalcROITrace(PixelIdxList{i},tidx);
    LPtrace = convtrim(LPtrace,ones(2,1)/2);
    
    % find peaks
    [~,b] = findpeaks(LPtrace,'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
    
    if(isempty(b))
        % if there were actually any peaks, they were really weak and this
        % transient was mis-detected
        continue;
    end
    FoundOne = false;
    % Check each peak
    for j = 1:length(b)
        if(~ismember(b(j),olda))
            
            continue;
        end
        FoundOne = true;
        gooda = (abs(olda-b(j)) <= PeakWinLen);
        
        newa = olda(gooda);
        mv = mean(T_MOVIE(:,:,newa+MinWin-1),3);
        
        % Recalculate the ROI based on the new pixel set
        PixFreq = CalcPixFreq(FrameList{i}(gooda),ObjList{i}(gooda),BlobPixelIdxList);
        InROI = PixFreq >= 0.5;
        templist = single(find(InROI));
        
        if((max(PixFreq(:)) < 1) || (length(templist) < MinBlobArea))
            %disp('re-calculating the ROI caused this one to be discarded');
            continue;
        end
        
        NumTransients = NumTransients + 1;
        
        temp_BigPixelAvg{NumTransients} = mv(CircMask{i});
        temp_PixelAvg{NumTransients} = mv(templist);
        [~,idx] = max(temp_PixelAvg{NumTransients});
        [temp_Ycent(NumTransients),temp_Xcent(NumTransients)] = ind2sub([Xdim Ydim],templist(idx));
        temp_FrameList{NumTransients} = FrameList{i}(gooda);
        temp_ObjList{NumTransients} = ObjList{i}(gooda);
        temp_CircMask{NumTransients} = CircMask{i};
        temp_PixelIdxList{NumTransients} = templist;
        
        if(ToPlot)
            figure(1);
            subplot(1,6,1:5);
            plot(LPtrace,'-b');hold on;
            plot(olda,LPtrace(olda),'-g','LineWidth',5);
            plot(newa,LPtrace(newa),'-r*','LineWidth',2);
            
            plot(b,LPtrace(b),'ko','MarkerSize',10);hold off;axis tight;
            
            subplot(1,6,6);
            imagesc(mv);axis image;hold on;
            caxis([0 max(temp_PixelAvg{NumTransients})]);
            axis([temp_Xcent(NumTransients)-20 temp_Xcent(NumTransients)+20 temp_Ycent(NumTransients)-20 temp_Ycent(NumTransients)+20]);
            PlotRegionOutline(temp_PixelIdxList{NumTransients},'r');
            hold off;
            pause;
        end
    end
    p.progress;
    if(~FoundOne)
        %disp('junked a weak ROI');
    end
end
p.stop;



% edit down all of the variables

Xcent = temp_Xcent;
Ycent = temp_Ycent;
FrameList = temp_FrameList;
ObjList = temp_ObjList;
PixelAvg = temp_PixelAvg;
PixelIdxList = temp_PixelIdxList;
BigPixelAvg = temp_BigPixelAvg;
CircMask = temp_CircMask;

Trans2ROI = 1:length(Xcent);

disp('Computing pixel overlaps');

%Overlaps = CalcOverlaps(PixelIdxList);

disp('saving data');
save UngarbagedROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelAvg PixelIdxList BigPixelAvg CircMask;

end

