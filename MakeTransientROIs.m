function [] = MakeTransientROIs()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Calculating ROIs for linked blobs (putative transients)');

%% Get parameters
[Xdim,Ydim,NumFrames,MinPixelPresence,ROICircleWindowRadius,threshold] = Get_T_Params('Xdim','Ydim','NumFrames','MinPixelPresence','ROICircleWindowRadius','threshold');

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
    PixFreq = blankframe;
    for j = 1:length(FrameList{i})
        BlobPix = BlobPixelIdxList{FrameList{i}(j)}{ObjList{i}(j)};
        PixFreq(BlobPix) = PixFreq(BlobPix)+1;
    end
    PixFreq = PixFreq./length(FrameList{i});
    InROI = PixFreq > MinPixelPresence;
    PixelIdxList{i} = single(find(InROI));
    props = regionprops(InROI,'Centroid');
    BinCent{i} = props.Centroid;
    CircMask{i} = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,BinCent{i}(1),BinCent{i}(2));
    BigAvg{i} = zeros(size(CircMask{i}),'single');
    
end

%% go through the movie and get the average pixel values
disp('averaging preliminary ROIs over the movie');
[BigPixelAvg] = PixelSetMovieAvg(TranBool,CircMask);

%% Refine the ROIs
for i = 1:NumTransients
    TempFrame = blankframe;
    TempFrame(CircMask{i}) = BigPixelAvg{i};
    ThreshFrame = TempFrame > threshold;
    b = bwconncomp(ThreshFrame,4);
    for j = 1:b.NumObjects
        if (sum(ismember(PixelIdxList{i},b.PixelIdxList{j})) > 0)
            break;
        end
    end
    PixelIdxList{i} = b.PixelIdxList{j};
    PixelAvg{i} = TempFrame(PixelIdxList{i});
end
   

disp('calculating weighted centroids');
for i = 1:NumTransients
    boolframe = blankframe;
    boolframe(PixelIdxList{i}) = 1;
    valframe = blankframe;
    valframe(PixelIdxList{i}) = PixelAvg{i};
    props = regionprops(boolframe,valframe,'WeightedCentroid');
    Xcent(i) = props.WeightedCentroid(1);
    Ycent(i) = props.WeightedCentroid(2);
end

%% save outputs
disp('saving data');
Trans2ROI = single(1:NumTransients);

save TransientROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelAvg PixelIdxList BigPixelAvg CircMask;

end

