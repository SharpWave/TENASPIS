function [BlobChunk] = SegmentFrameChunk(FrameChunk,PrepMask)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
NumFrames = size(FrameChunk,3);
BlobChunk.BlobPixelIdxList = cell(1,NumFrames);
BlobChunk.BlobWeightedCentroids = cell(1,NumFrames);
BlobChunk.BlobMinorAxisLength = cell(1,NumFrames);

for i = 1:NumFrames
    [BlobChunk.BlobPixelIdxList{i},BlobChunk.BlobWeightedCentroids{i},BlobChunk.BlobMinorAxisLength] = SegmentFrame(squeeze(FrameChunk(:,:,i)),PrepMask);
end

