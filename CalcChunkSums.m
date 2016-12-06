function [PixelSum] = CalcChunkSums(FrameList,NumInputs,NumROIs,PixelIdx,ActBool)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Load Chunk
FrameChunk = LoadFrames('BPDFF.h5',FrameList);

%% for each ROI, cut the FrameChunk according to active frames, sum it, and shove the sums into the output data structure
PixelSum = cell(1,NumInputs);
for i = 1:NumInputs % Number of ROI sets    
    PixelSum{i} = cell(1,NumROIs(i));    
    for j = 1:NumROIs(i) 
        % add frames where ROI was active
        ROIChunksum = sum(FrameChunk(:,:,ActBool{i}{j}(FrameList)),3);
        % shove ROIs pixels into PixelSum
        PixelSum{i}{j} = ROIChunksum(PixelIdx{i}{j});
    end
end

end

