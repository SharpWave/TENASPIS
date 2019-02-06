function [varargout] = PixelSetMovieAvg(varargin)
% [varargout] = PixelSetMovieAvg(varargin)
% calculates averages of pixel sets
% inputs are NxT boolean activation matrices followed by length N cell
% arrays containing pixel indices

[Xdim, Ydim, NumFrames,FrameChunkSize, SampleRate] = ...
    Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize', 'SampleRate');

% check that input is formatted right
NumInputs = length(varargin)/2;
% if(mod(NumInputs,1) ~= 0)
%     error('PixelSetMovieAvg requires an odd number of inputs, see help');
% end
% param_file_use = varargin{end};

%% Chunking variables
FrameChunkSize = FrameChunkSize;
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);
ChunkSums = cell(1,NumChunks);

%% initialize outputs and unpack some variables from varargin for clarity
for i = 1:NumInputs
    NumROIs(i) = length(varargin{i*2});
    for j = 1:NumROIs(i)
      PixelAvg{i}{j} = single(zeros(size(varargin{i*2}{j})));
      PixelIdx{i}{j} = varargin{i*2}{j};
      ActBool{i}{j} = logical(varargin{(i-1)*2+1}(j,:));
    end
end

%% average the chunks in parallel
p = ProgressBar(NumChunks);
parfor i = 1:NumChunks
    Set_T_Params('BPDFF.h5', SampleRate);
%     Set_Custom_T_Params('BPDFF.h5',param_file_use);
    FrameList = ChunkStarts(i):ChunkEnds(i);
    ChunkSums{i} = CalcChunkSums(FrameList,NumInputs,NumROIs,PixelIdx,ActBool);
    p.progress;    
end
p.stop;

%% unpack the parallelized data, calculate the mean from the sum
for j = 1:NumInputs
    for k = 1:NumROIs(j)
        for i = 1:NumChunks
          PixelAvg{j}{k} = PixelAvg{j}{k} + ChunkSums{i}{j}{k};
        end
        PixelAvg{j}{k} = PixelAvg{j}{k}./sum(ActBool{j}{k});
    end
    varargout(j) = PixelAvg(j);
end


end

