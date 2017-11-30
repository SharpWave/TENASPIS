function BlobChunk = SegmentFrameChunk(FrameList,PrepMask)
%BlobChunk = SegmentFrameChunk(FrameList,PrepMask)
%   Detailed explanation goes here

FrameChunk = LoadFrames('BPDFF.h5',FrameList); 

NumFrames = size(FrameChunk,3);
BlobChunk.BlobPixelIdxList = cell(1,NumFrames);
BlobChunk.BlobWeightedCentroids = cell(1,NumFrames);
BlobChunk.BlobMinorAxisLength = cell(1,NumFrames);

for i = 1:NumFrames
    [BlobChunk.BlobPixelIdxList{i},...
        BlobChunk.BlobWeightedCentroids{i},...
        BlobChunk.BlobMinorAxisLength{i}] = ...
        NewSegmentFrame(squeeze(FrameChunk(:,:,i)),PrepMask);
end

end