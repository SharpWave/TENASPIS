function [varargout] = PixelSetMovieAvg(varargin)
% [varargout] = PixelSetMovieAvg(varargin)
% calculates averages of pixel sets
% inputs are NxT boolean activation matrices followed by length N cell
% arrays containing pixel indices

[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

% check that input is formatted right
NumInputs = length(varargin)/2;
if(mod(NumInputs,1) ~= 0)
    error('PixelSetMovieAvg requires an even number of inputs, see help');
end

%% Chunking variables
FrameChunkSize = FrameChunkSize;
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

%% initialize outputs and unpack some variables from varargin for clarity
for i = 1:NumInputs
    NumROIs(i) = length(varargin{i*2});
    for j = 1:NumROIs(i)
      PixelAvg{i}{j} = single(zeros(size(varargin{i*2}{j})));
      PixelIdx{i}{j} = varargin{i*2}{j};
      ActBool{i}{j} = logical(varargin{(i-1)*2+1}(j,:));
    end
end

%% load the movie chunks and average that shit!
p = ProgressBar(NumChunks);
for i = 1:1 % this can be parallelized
    % load chunk
    tic
    FrameList = ChunkStarts(i):ChunkEnds(i);
    %FrameChunk = LoadFrames('BPDFF.h5',FrameList);
    FrameChunk = LoadFrames('BPDFF.h5',FrameList);
    % average each pixel set
    
    ChunkAvg{i} = AvgChunk(FrameChunk,FrameList,NumInputs,NumROIs,PixelIdx,ActBool);
    

    p.progress;
    toc,
end
p.stop;
keyboard;
for j = 1:NumInputs
    for k = 1:NumROIs(j)
        for i = 1:NumChunks
          PixelAvg{j}{k} = PixelAvg{j}{k} + ChunkAvg{i}{j}{k};
        end
        PixelAvg{j}{k}./sum(ActBool{j}{k});
    end
    varargout(j) = PixelAvg(j);
end


        

    




end

