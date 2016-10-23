function [] = MakeTransientROIs()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Calculating ROIs for linked blobs (putative transients)');

%% Get parameters
[Xdim,Ydim,NumFrames,FrameChunkSize,MinPixelPresence,ROICircleWindowRadius] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize','MinPixelPresence','ROICircleWindowRadius');



%% load data
disp('loading data');
load('VettedTransients.mat','FrameList','ObjList');
load('Blobs.mat','BlobPixelIdxList');

%% setup some variables
NumTransients = length(FrameList);
[PixelList,BinCent,BigAvg,CircMask,PixelAvg] = cell(1,NumTransients);
TranBool = zeros(NumTransients,NumFrames);

%% get pixel participation average and determine ROI
disp('determining calcium transient ROIs');
blankframe = zeros(Xdim,Ydim);
for i = 1:NumTransients
    PixFreq = blankframe;
    for j = 1:length(FrameList{i})
        BlobPix = BlobPixelIdxList{FrameList{i}(j)}{ObjList{i}(j)};
        PixFreq(BlobPix) = PixFreq(BlobPix)+1;
    end
    PixFreq = PixFreq./length(FrameList{i});
    InROI = PixFreq > MinPixelPresence;
    PixelList{i} = find(InROI);
    props = regionprops(InROI,'Centroid');
    BinCent{i} = props.Centroid;
    CircMask{i} = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,BinCent{i}(1),BinCent{i}(2));
    BigAvg{i} = zeros(size(CircMask{i}));
    PixelAvg{i} = zeros(size(PixelList{i}));
    TranBool(i,FrameList{i}) = 1;
end

%% go through the movie and get the average pixel values
disp('averaging ROIs over the movie');
p=ProgressBar(NumChunks);
[BigAvg,PixelAvg] = PixelSetMovieAvg(TranBool,CircMask,TranBool,PixelList);
 
keyboard;
%save InitClu.mat c Xdim Ydim PixelList Xcent Ycent frames NumFrames PixelAvg BigPixelAvg cm min_trans_length -v7.3;

end

