function [ output_args ] = PlotAllBlobs()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure;
load ('CC.mat','cc');

allblobs = zeros(cc{1}.ImageSize);

for i = 1:length(cc)
    for j = 1:cc{i}.NumObjects
        allblobs(cc{i}.PixelIdxList{j}) = allblobs(cc{i}.PixelIdxList{j}) + 1;
    end
end
imagesc(allblobs);

end

