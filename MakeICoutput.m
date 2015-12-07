function [] = MakeICoutput(NumIC)

% read in IC, interpret them, save as similar to NeuronImage and
% NeuronPixels.  weighted AND binarry

% select Obj_1 directory
dirname = uigetdir;
cd(dirname);

for i = 1:NumIC
    % get the things
    cd(['Obj_',int2str(i)]);
    load('Obj_1 - IC unmixing image 1.mat');
    RawIC{i} = Object.Data;
    maxval(i) = max(RawIC{i}(:));
    BinaryIC{i} = RawIC{i} > maxval(i)/2;
    load('Obj_2 - IC trace1.mat');
    RawICtrace{i} = Object.Data;
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

GoodIC = zeros(size(NumIC));

for i = 1:NumIC
    if (%major <= 2*minor) 
        GoodIC(i) = 1;
    end
end

NumGoodIC = sum(GoodIC);

% create ROIS
for i = 1:NumGoodIC
    ROI{i} = % centroid pixel +- square radius 1/4 the long axis length
end

% update data structures

% decide where calcium transients exist; see Tonegawa & Schnitzer
%
% Calcium traces were calculated at these ROIs for each processed movie,
% in ImageJ. Calcium events were detected by thresholding (>3 SDs from the ?F/F signal) 
% at the local maxima of the ?F/F signal.

for i = 1:NumGoodIC
    % find transients
end

% make a matrix similar to FT

%%%%%%%%%%%%%%%%%%%%%%

% analysis

% just look at whether Ca2+ transients match

% look at whether IC match (nearest centroid; highest overlap)

% for neurons/IC with good match, how does transient detection fare?