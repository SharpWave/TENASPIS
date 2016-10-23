function [varargout] = PixelSetMovieAvg(varargin)
% [varargout] = PixelSetMovieAvg(varargin)
% calculates averages of pixel sets
% inputs are NxT boolean activation matrices followed by length N cell
% arrays containing pixel indices

NumInputs = length(varargin/2);

%% Chunking variables
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

%% initialize outputs
for i = 1:NumInputs
    for j = 1:length(varargin{i*2})
      out{i}{j} = zeros(length(varargin{i*2}{j}));
      

%% load the movie chunks and average that shit!





end

