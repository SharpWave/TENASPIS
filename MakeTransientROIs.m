function [] = MakeTransientROIs()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Calculating ROIs for linked blobs (putative transients)');

%% Get parameters
[Xdim,Ydim,NumFrames,MinPixelPresence,ROICircleWindowRadius,MinBlobRadius] = Get_T_Params('Xdim','Ydim','NumFrames','MinPixelPresence','ROICircleWindowRadius','MinBlobRadius');

DebugPlot = 0;
SummaryPlot = 1;

MinBlobArea = ceil((MinBlobRadius^2)*pi);

%% load data
disp('loading data');
load('VettedTransients.mat','FrameList','ObjList');
load('BlobLinks.mat','BlobPixelIdxList');

%% setup some variables
NumTransients = length(FrameList);
[PixelIdxList,CircMask] = deal(cell(1,NumTransients));
TranBool = false(1,NumTransients);
[Xcent,Ycent] = deal(zeros(1,NumTransients,'single'));

%% get pixel participation average and determine ROI
disp('determining calcium transient ROIs');

for i = 1:NumTransients
    PixFreq = CalcPixFreq(FrameList{i},ObjList{i},BlobPixelIdxList);
    if(DebugPlot)
        figure(1);
        imagesc(PixFreq);colorbar;caxis([0 1]);axis image;        
        pause;
    end
    InROI = PixFreq >= MinPixelPresence;
    PixelIdxList{i} = single(find(InROI));
    props = regionprops(InROI,'Centroid');
    if((isempty(props)) || (max(PixFreq(:)) < 1) || (length(PixelIdxList{i}) < MinBlobArea))
        continue;
    end
    BinCent = props.Centroid;
    Ycent(i) = BinCent(1);
    Xcent(i) = BinCent(2);
    CircMask{i} = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,BinCent(1),BinCent(2));
    TranBool(i) = true;
    
end

GoodTr = find(TranBool);
disp(['kept ',int2str(length(GoodTr)),' out of ',int2str(length(PixelIdxList)),' after eliminating transients without a minimum of ',int2str(MinBlobArea),' pixels present on at least 50% of frames']);

PixelIdxList = PixelIdxList(GoodTr);
CircMask = CircMask(GoodTr);
Xcent = Xcent(GoodTr);
Ycent = Ycent(GoodTr);
FrameList = FrameList(GoodTr);
ObjList = ObjList(GoodTr);
NumTransients = length(PixelIdxList);

Trans2ROI = single(1:NumTransients);

%% save outputs
disp('saving data');
save TransientROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelIdxList CircMask;

if(SummaryPlot)
    figure;
    for i = 1:NumTransients
        PlotRegionOutline(PixelIdxList{i});hold on;
    end
    axis image;
end

end


