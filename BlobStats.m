function [ ] = BlobStats( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load CC.mat;

Bsizes = [];
NumBlobs = 1;
for i = 1:length(cc)
  for j = 1:length(cc{i}.PixelIdxList)
      Bsizes = [Bsizes,length(cc{i}.PixelIdxList{j})];
      Bidx{NumBlobs} = [i,j];
      NumBlobs = NumBlobs + 1;
  end
end

keyboard;
end

