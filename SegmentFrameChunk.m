function [cc,PeakPix] = SegmentFrameChunk(ChunkStart,ChunkEnd,mask,thresh)
% load a chunk of the movie and segment it
FrameList = ChunkStart:ChunkEnd;

display('loading frames');
FrameChunk = LoadFrames('SLPDF.h5',FrameList);

for i = 1:length(FrameList)
  [cc{i},PeakPix{i}] = SegmentFrame2(squeeze(FrameChunk(:,:,i)),mask,thresh);
end

