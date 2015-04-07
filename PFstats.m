function [] = PFstats( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load PlaceMaps.mat; % x y t xOutline yOutline speed minspeed FT TMap RunOccMap OccMap SpeedMap RunSpeedMap NeuronImage NeuronPixels cmperbin pval Xbin Ybin;

% Which pixels are in place field?

% what should the threshold be?  peaks range from .1 to .35
% i.e. the BEST place cell is active in 35% of crossings?

Min_pT = 0.02; % minimum probability of transient
NumNeurons = length(NeuronImage);
NumFrames = length(Xbin);

% some analysis using bwconncomp and regionprops

for i = 1:NumNeurons
    ThreshMap = TMap{i}.*(TMap{i} > Min_pT);
    BoolMap = ThreshMap > 0;
    b{i} = bwconncomp(BoolMap);
    r{i} = regionprops(b{i},'all');
end

for i = 1:NumNeurons
    NumPF(i) = b{i}.NumObjects;
    for j = 1:NumPF(i)
        PFpixels{i,j} = b{i}.PixelIdxList{j};
        PFsize(i,j) = r{i}(j).Area;
        PFcentroid{i,j} = r{i}(j).Centroid;
    end
    [~,MaxPF(i)] = 
end

% for every place field, figure out how many times the mouse passed through
% it

% convert Xbin and Ybin into a single number denoting where the mouse is
loc_index = sub2ind(size(TMap{1}),Xbin,Ybin); % Y and X purposely switched.  I 

for i = 1:NumNeurons
    for j = 1:NumPF(i)
        PixelBool = zeros(1,NumFrames);
        for k = 1:NumFrames
            PixelBool(k) = ismember(loc_index(k),PFpixels{i,j});
        end
        PFepochs{i,j} = NP_FindSupraThresholdEpochs(PixelBool,eps,0);
    end
end
keyboard;

    
    

