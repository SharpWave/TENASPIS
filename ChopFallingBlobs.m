function [outputArg1,outputArg2] = ChopFallingBlobs(inputArg1,inputArg2)

% The idea is that calcium transient segmentation is less noisy during the
% rise than during the fall - we're gonna chop the portion of the
% transients with the fall so that the ROIs are cleaner

[Xdim,Ydim,MinNumFrames,SampleRate] = Get_T_Params('Xdim','Ydim','MinNumFrames','SampleRate');

%% load data
disp('Loading blob and link data');
load('BlobLinks.mat');

global T_MOVIE;

NumTransients = length(FrameList);

for i = 1:NumTransients
    if ((length(FrameList{i}) <= 2) || (FrameList{i}(1) < 1000))
        continue;
    end
    
    AllPixels = [];
    for j = 1:length(FrameList{i})
        Blob = BlobPixelIdxList{FrameList{i}(j)}{ObjList{i}(j)};
        
        AllPixels = [AllPixels;Blob];
    end
    
    Cent = BlobWeightedCentroids{FrameList{i}(1)}{ObjList{i}(1)};
    
    [BlobUnion,ia,ic ] = unique(AllPixels);
    BlobUnion_freq = accumarray(ic,1)/length(FrameList{i});
    
    
    % make a trace for this thing
    TempTrace = CalcROITrace(BlobUnion,FrameList{i});
    
    
    
    
    % First sample of trace is detection level
    % anything less than detection level gets tossed
    % Remaining rising samples are ok
    % falling samples greater than half the peak height are ok
    
    DetectionLevel = TempTrace(1);
    GoodFrame = logical(ones(length(TempTrace),1));
    GoodFrame(TempTrace < DetectionLevel) = false;
    Slopes = [0,diff(TempTrace)];
    HalfPeak = max(TempTrace)/2;
    GoodFrame((Slopes < 0) & (TempTrace < HalfPeak)) = false;
    
    GreenFrames = find(GoodFrame == true);
    if (length(GreenFrames) <= 5)
        continue;
    end
    RedFrames = find(GoodFrame == false);
    
    
    figure(1);
    subplot(2,4,[1 5]);
    plot(FrameList{i},TempTrace,'-b');hold on;
    plot(FrameList{i}(GreenFrames),TempTrace(GreenFrames),'og');hold on;
    plot(FrameList{i}(RedFrames),TempTrace(RedFrames),'or');hold off;
    
    
    AllMeanFrames = mean(T_MOVIE(:,:,FrameList{i}),3);
    subplot(2,4,2);
    imagesc(AllMeanFrames);axis image;hold on;
    
    axis([Cent(1)-25 Cent(1)+25 Cent(2)-25 Cent(2)+25]);
    MaxC = max(max(AllMeanFrames(BlobUnion)),eps);
    caxis([0 MaxC]);
    title('All')
    
    AllGreenFrames = mean(T_MOVIE(:,:,FrameList{i}(GreenFrames)),3);
    subplot(2,4,3);
    imagesc(AllGreenFrames);axis image;hold on;
    MaxC = max(max(AllGreenFrames(BlobUnion)),eps);
    caxis([0 MaxC]);
    AllGreenPixels = [];
    for j = 1:length(GreenFrames)
        Blob = BlobPixelIdxList{FrameList{i}(GreenFrames(j))}{ObjList{i}(GreenFrames(j))};
        AllGreenPixels = [AllGreenPixels;Blob];
        
        PlotRegionOutline(Blob,'g');
    end
    
    [GreenBlob,~,ic] = unique(AllGreenPixels);
    Green_freq = accumarray(ic,1)/length(GreenFrames);
    
    axis([Cent(1)-25 Cent(1)+25 Cent(2)-25 Cent(2)+25]);

    title('Good');hold off;
    
    AllRedFrames = mean(T_MOVIE(:,:,FrameList{i}(RedFrames)),3);
    subplot(2,4,4);
    imagesc(AllRedFrames);axis image;hold on;
    MaxC = max(max(AllRedFrames(BlobUnion)),eps);
    caxis([0 MaxC]);
    AllRedPixels = [];
    for j = 1:length(RedFrames)
        Blob = BlobPixelIdxList{FrameList{i}(RedFrames(j))}{ObjList{i}(RedFrames(j))};
        AllRedPixels = [AllRedPixels;Blob];
        PlotRegionOutline(Blob,'r');
    end
    
    [RedBlob,~,ic] = unique(AllRedPixels);
    Red_freq = accumarray(ic,1)/length(RedFrames);
    
    axis([Cent(1)-25 Cent(1)+25 Cent(2)-25 Cent(2)+25]);

    title('Bad');hold off;
    
    MinFreq = [0 0.2 0.4 0.6 0.8 1];
    clist{1} = 'k';
    clist{2} = 'b';
    clist{3} = 'c';
    clist{4} = 'y';
    clist{5} = 'r';
    clist{6} = 'w';
    
    subplot(2,4,6);
    imagesc(AllMeanFrames);axis image;hold on;
    axis([Cent(1)-25 Cent(1)+25 Cent(2)-25 Cent(2)+25]);
    MaxC = max(max(AllMeanFrames(BlobUnion)),eps);
    caxis([0 MaxC]);
    for j = 1:length(MinFreq)
        idx = find(BlobUnion_freq >= MinFreq(j));
        PlotRegionOutline(BlobUnion(idx),clist{j});
    end
    hold off;
    
    subplot(2,4,7);
    imagesc(AllGreenFrames);axis image;hold on;
    axis([Cent(1)-25 Cent(1)+25 Cent(2)-25 Cent(2)+25]);
     MaxC = max(max(AllGreenFrames(BlobUnion)),eps);
    caxis([0 MaxC]);
    for j = 1:length(MinFreq)
        idx = find(Green_freq >= MinFreq(j));
        PlotRegionOutline(GreenBlob(idx),clist{j});
    end
    hold off;
    
    subplot(2,4,8);
    imagesc(AllRedFrames);axis image;hold on;
    axis([Cent(1)-25 Cent(1)+25 Cent(2)-25 Cent(2)+25]);
     MaxC = max(max(AllRedFrames(BlobUnion)),eps);
    caxis([0 MaxC]);
    for j = 1:length(MinFreq)
        idx = find(Red_freq >= MinFreq(j));
        PlotRegionOutline(RedBlob(idx),clist{j});
    end
    hold off;   
    
    pause;
end

