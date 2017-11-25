function [] = MakeTransientROIs()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Calculating ROIs for linked blobs (putative transients)');

%% Get parameters
[Xdim,Ydim,NumFrames,MinPixelPresence,ROICircleWindowRadius,MinBlobRadius] = Get_T_Params('Xdim','Ydim','NumFrames','MinPixelPresence','ROICircleWindowRadius','MinBlobRadius');

DebugPlot = 0;

%% load data
disp('loading data');
load('VettedTransients.mat','FrameList','ObjList');
load('Blobs.mat','BlobPixelIdxList');

%% setup some variables
NumTransients = length(FrameList);
[PixelIdxList,BinCent,BigAvg,CircMask,PixelAvg] = deal(cell(1,NumTransients));
TranBool = false(NumTransients,NumFrames);
[Xcent,Ycent] = deal(zeros(1,NumTransients,'single'));

%% get pixel participation average and determine ROI
disp('determining calcium transient ROIs');
blankframe = zeros(Xdim,Ydim,'single');
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
    BinCent{i} = props.Centroid;
    CircMask{i} = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,BinCent{i}(1),BinCent{i}(2));
    BigAvg{i} = zeros(size(CircMask{i}),'single');
    TranBool(i,FrameList{i}) = true;
end

%% go through the movie and get the average pixel values
disp('averaging preliminary ROIs over the movie');
[BigPixelAvg] = PixelSetMovieAvg(TranBool,CircMask);

%% calculate stuff
for i = 1:NumTransients
    TempFrame = blankframe;
    TempFrame(CircMask{i}) = BigPixelAvg{i};
    PixelAvg{i} = TempFrame(PixelIdxList{i});
    [~,idx] = max(PixelAvg{i});
    [Ycent(i),Xcent(i)] = ind2sub([Xdim Ydim],PixelIdxList{i}(idx));
end

Trans2ROI = single(1:NumTransients);

%% save outputs
disp('saving data');
save TransientROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelAvg PixelIdxList BigPixelAvg CircMask;



end


