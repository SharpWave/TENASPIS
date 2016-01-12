function [ output_args ] = Analyze_TvP(matfile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load(matfile);

% load motion-ADJUSTED FT and ICFT

for i = 1:length(ICimage)
    ICpixels{i} = find(ICimage{i});
end

for i = 1:length(NeuronImage)
    cidx = ClosestT(i);
    FractionOverlap(i) = length(intersect(NeuronPixels{i},ICpixels{cidx}))./length(NeuronPixels{i});
end

for i = 1:length(NeuronImage)
    Num_T_Transients(i) = 
    Num_ClosestI_Transients(i) = 
    Num_Matching_Transients(i) = 
    Fraction_T_Matched(i) = Num_T_Transients(i)./Num_Matching_Transients(i);
    Fraction_ClosestI_Matched(i) = Num_ClosestI_Transients(i)./Num_Matching_Transients(i);
end

keyboard;
