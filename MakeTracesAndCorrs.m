function [DataOut] = MakeTracesAndCorrs(PixelIdxList,PixelAvg)
% [varargout] = MakeTraces(varargin)
% makes traces from pixel sets
% inputs are length N cell arrays containing ROI pixel indices
% vargout is a cell array of structs containing three elements, each a different NxT trace matrix
% RawTrace: the unaltered mean of the pixels in the ROI
% LPtrace: lowpass filter - RawTrace with a 3-pixel uniform window smoothing applied
% DFDTtrace: LPtrace change per sample.

%% get parameters
[NumFrames,FrameChunkSize] = Get_T_Params('NumFrames','FrameChunkSize');

%% set up variables
NumNeurons = length(PixelIdxList);
disp(['making traces for ',int2str(NumNeurons),' ROIs']);

[DataOut.RawTrace,DataOut.LPtrace,DataOut.DFDTtrace,DataOut.CorrR,DataOut.CorrP] = deal(zeros(NumNeurons,NumFrames,'single'));

% Chunking variables
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

%% process the chunks in parallel
p = ProgressBar(NumChunks);
parfor i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    TraceChunk{i} = MakeTraceChunk(FrameList,PixelIdxList,PixelAvg);
    p.progress;
end
p.stop;

%% unpack the chunks
disp('unpacking data chunks');

for i = 1:NumChunks
    DataOut.RawTrace = DataOut.RawTrace+TraceChunk{i}.RawTrace;
    DataOut.CorrR = DataOut.CorrR+TraceChunk{i}.CorrR;
    DataOut.CorrP = DataOut.CorrP+TraceChunk{i}.CorrP;
end

%% filter and take DFDT
disp('filtering traces and calculating DF/DT');

for j = 1:NumNeurons
    DataOut.LPtrace(j,:) = convtrim(DataOut.RawTrace(j,:),ones(1,3))./3;
    DataOut.DFDTtrace(j,:) = zscore(diff(DataOut.LPtrace(j,:)));
end
DataOut.DFDTtrace(j,2:end+1) = DataOut.DFDTtrace{i}(j,:);
DataOut.DFDTtrace(j,1) = 0;

end

