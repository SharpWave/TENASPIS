function [] = PFstats( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load PlaceMaps.mat; % x y t xOutline yOutline speed minspeed FT TMap RunOccMap OccMap SpeedMap RunSpeedMap NeuronImage NeuronPixels cmperbin pval Xbin Ybin;

% Which pixels are in place field?

% what should the threshold be?  peaks range from .1 to .35
% i.e. the BEST place cell is active in 35% of crossings?

Min_pT = 0.02; % minimum probability of transient
NumNeurons = length(NeuronImage);

for i = 1:NumNeurons
    ThreshMap = TMap{i}.*(TMap{i} > Min_pT);
    BoolMap = ThreshMap > 0;
    b{i} = bwconncomp(BoolMap);
    r{i} = regionprops(b{i},'all');
end

for i = 1:NumNeurons
    NumPF(i) = b{i}.NumObjects;
    
    

