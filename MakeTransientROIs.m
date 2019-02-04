function [] = MakeTransientROIs(param_file_use)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 1
    param_file_use = '';
end
disp('Calculating ROIs for linked blobs (putative transients)');

%% Get parameters
[Xdim,Ydim,NumFrames,MinPixelPresence,ROICircleWindowRadius,threshold,MinBlobRadius] = ...
    Get_T_Params('Xdim','Ydim','NumFrames','MinPixelPresence','ROICircleWindowRadius',...
    'threshold','MinBlobRadius');

threshold = threshold * 2;

%% load data
disp('loading data');
load('VettedTransients.mat','FrameList','ObjList');
load('Blobs.mat','BlobPixelIdxList');

%% setup some variables
NumTransients = length(FrameList);
[PixelIdxList,BinCent,BigAvg,CircMask,PixelAvg] = deal(cell(1,NumTransients));
TranBool = false(NumTransients,NumFrames);
[Xcent,Ycent] = deal(zeros(1,NumTransients,'single'));
MinBlobArea = ceil((MinBlobRadius^2)*pi);

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
    TranBool(i,FrameList{i}) = true;
end

%% go through the movie and get the average pixel values
disp('averaging preliminary ROIs over the movie');
[BigPixelAvg] = PixelSetMovieAvg(TranBool,CircMask,param_file_use);

%% Refine the ROIs
GoodROI = false(1,NumTransients);

for i = 1:NumTransients
    % threshold the averaged transient
    TempFrame = blankframe;
    TempFrame(CircMask{i}) = BigPixelAvg{i};
    
    tryagain = true;
    tempthresh = threshold;
    while((tryagain) && (tempthresh <= max(TempFrame(:))))
        tempthresh = tempthresh*1.1;
        pidxlist = SegmentFrame(TempFrame,[],false,tempthresh);
        
        % find the matching segment
        for j = 1:length(pidxlist)
            if (ismember(sub2ind([Xdim Ydim],round(BinCent{i}(2)),round(BinCent{i}(1))),pidxlist{j}))
                [~,idx] = max(TempFrame(pidxlist{j}));
                %keyboard;
                if(ismember(pidxlist{j}(idx),PixelIdxList{i}))
                    % if new peak is in old ROI things are good
                    tryagain = false;
                    GoodROI(i) = true;
                    PixelIdxList{i} = pidxlist{j};
                    PixelAvg{i} = TempFrame(PixelIdxList{i});
                    
                end
                break;
            end
        end
        
    end
end

%% Include only GoodROI (ROI that had some average pixels over threshold)
FrameList = FrameList(GoodROI);
ObjList = ObjList(GoodROI);
PixelAvg = PixelAvg(GoodROI);
PixelIdxList = PixelIdxList(GoodROI);
BigPixelAvg = BigPixelAvg(GoodROI);
CircMask = CircMask(GoodROI);

NumTransients = sum(GoodROI);

disp([int2str(sum(GoodROI)),' out of ',int2str(length(GoodROI)),' transients kept after thresholding the averages']);

% % calculate centroids
% disp('calculating weighted centroids');
% for i = 1:NumTransients
%     boolframe = blankframe;
%     boolframe(PixelIdxList{i}) = 1;
%     valframe = blankframe;
%     valframe(PixelIdxList{i}) = PixelAvg{i};
%     props = regionprops(boolframe,valframe,'WeightedCentroid');
%     oldXcent(i) = props.WeightedCentroid(1);
%     oldYcent(i) = props.WeightedCentroid(2);
% end

%% calculate peaks
for i = 1:NumTransients
    [~,idx] = max(PixelAvg{i});
    [Ycent(i),Xcent(i)] = ind2sub([Xdim Ydim],PixelIdxList{i}(idx));
end

%% save outputs
disp('saving data');
Trans2ROI = single(1:NumTransients);

save TransientROIs.mat Trans2ROI Xcent Ycent FrameList ObjList PixelAvg PixelIdxList BigPixelAvg CircMask;



end


