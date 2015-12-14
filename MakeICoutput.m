function [] = MakeICoutput(NumIC)

% read in IC, interpret them, save as similar to NeuronImage and
% NeuronPixels.  weighted AND binarry

% select Obj_1 directory
dirname = uigetdir;
cd(dirname);
display('loading data');
for i = 1:NumIC
    % get the things
    cd(['Obj_',int2str(i)]);
    load(['Obj_1 - IC unmixing image ',int2str(i),'.mat']);
    RawIC{i} = Object.Data;
    maxval(i) = max(RawIC{i}(:));
    BinaryIC{i} = RawIC{i} > maxval(i)/2;
    load(['Obj_2 - IC trace ',int2str(i),'.mat']);
    RawICtrace{i} = Object.Data;
    cd ..
end

% apply inclusion thresholds; see Tonegawa % Schnitzer Sun et al PNAS:
%
% Finally, it was processed by custom-made code written in ImageJ [dividing
% each image, pixel by pixel, by a low-passed (r = 20 pixels) filtered
% version], a ?F/F signal was calculated, and a spatial mean filter was
% applied to it in Inscopix Mosaic (disk radius = 3). 
%
% Two hundred cell locations were carefully selected from the resulting
% movie by principal component analysis–independent component analysis
% (PCA-ICA) [300 output principal components, 200 independent components
% (ICs), 0.1 weight of temporal information in spatiotemporal ICA, 750
% iterations maximum, 1E-5 fractional change to end iterations] in Inscopix
% Mosaic software, and the ICs were binarized with a threshold equal to
% one-half of the maximum intensity. Regions of interest (ROIs) were
% constructed very small to minimize overlap between ROIs, with width equal
% to one-half the width of the binarized ICs. ROIs that were too elongated
% (if its length exceeded its width by more than two times) were discarded.

%Correlation of Instantaneous Cell Calcium Event Rate vs. Animal Speed. The
%instantaneous rate of calcium event of each individual cell was determined
%from the number of calcium transients that occurred in the 1-s time window
%place symmetrically around that time bin (time bins sampled at 20 Hz, as
%stated before). Linear regression analysis was performed on the
%instantaneous calcium event rate vs. the animal running speed for each
%individual cell, to yield the distribution of regression slopes (Fig. 3C).

GoodIC = zeros(size(NumIC));
display('eliminating bad ICs');
for i = 1:NumIC
    Props{i} = regionprops(BinaryIC{i},'all');
    if (length(Props{i}) > 1)
        display(['Bad IC #',int2str(i)]);
        continue;
    end
    if (Props{i}.MajorAxisLength <= Props{i}.MinorAxisLength*2) 
        GoodIC(i) = 1;
    else
        display(['Bad IC #',int2str(i)]);
    end
end

NumGoodIC = sum(GoodIC);
GoodICidx = find(GoodIC);

% create ROIS
for i = 1:NumGoodIC
    display(int2str(i));
    cidx = GoodICidx(i);
    sqRad = round(Props{cidx}.MinorAxisLength/4);
    ROI{i} = zeros(size(BinaryIC{cidx}));
    xCent = Props{cidx}.Centroid(1);
    yCent = Props{cidx}.Centroid(2);
    xMin = max(xCent-sqRad,1);
    xMax = min(xCent+sqRad,size(BinaryIC{cidx},2));
    
    yMin = max(yCent-sqRad,1);
    yMax = min(yCent+sqRad,size(BinaryIC{cidx},1));
    ROI{i}(yMin:yMax,xMin:xMax) = 1;% centroid pixel +- square radius 1/4 the long axis length
    PixelList{i} = find(ROI{i});
    if (length(PixelList{i}) == 0)
        keyboard;
    end
    ICtrace(i,:) = RawICtrace{cidx};
    ICFT(i,:) = RawICtrace{cidx} > 3;
    
end

ICimage = BinaryIC(GoodICidx);
RawICimage = RawIC(GoodICidx);
ICprops = Props(GoodICidx);

NumFrames = size(ICFT,2);
% make Ca2+ transients per sec traces for each neuron
for i = 1:NumGoodIC
    temp = NP_FindSupraThresholdEpochs(ICFT(i,:),eps,0);
    CaTrStart = temp(:,1);
    CaTrBool = zeros(1,NumFrames);
    CaTrBool(CaTrStart) = 1;
    CaTrRate(i,:) = convtrim(CaTrBool,ones(1,20));
end


save ICoutput.mat ICtrace ICFT ICimage ICprops CaTrRate


% update data structures

% decide where calcium transients exist; see Tonegawa & Schnitzer
%
% Calcium traces were calculated at these ROIs for each processed movie,
% in ImageJ. Calcium events were detected by thresholding (>3 SDs from the ?F/F signal) 
% at the local maxima of the ?F/F signal.
% [filename,pathname] = uigetfile('*.h5','pick the DF/F file');
% cd(pathname);
% [~,Xdim,Ydim,NumFrames] = loadframe(filename,1);
% for i = 1:NumFrames
%     i/NumFrames
%     [frame,Xdim,Ydim,NumFrames] = loadframe(filename,i);
%     for j = 1:NumGoodIC
%         ROItrace(j,i) = sum(frame(PixelList{j}));% find transients
%     end
% end
% keyboard;
% make a matrix similar to FT

%%%%%%%%%%%%%%%%%%%%%%

% analysis

% just look at whether Ca2+ transients match

% look at whether IC match (nearest centroid; highest overlap)

% for neurons/IC with good match, how does transient detection fare?