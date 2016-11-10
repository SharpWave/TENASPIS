function [varargout] = MakeTraces(varargin)
% [varargout] = MakeTraces(varargin)
% makes traces from pixel sets
% inputs are length N cell arrays containing ROI pixel indices
% vargout is a cell array of structs containing three elements, each a different NxT trace matrix 
% RawTrace: the unaltered mean of the pixels in the ROI 
% LPtrace: lowpass filter - RawTrace with a 3-pixel uniform window smoothing applied
% DFDTtrace: LPtrace change per sample.  

%% get parameters
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

%% set up variables
NumInputs = length(varargin);

% Chunking variables
FrameChunkSize = FrameChunkSize;
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);
ChunkSums = cell(1,NumChunks);

%% initialize outputs and unpack some variables from varargin for clarity
for i = 1:NumInputs
  RawTrace{i} = zeros(length(varargin{i}),NumFrames,'single');
  disp(['making traces for ',int2str(length(varargin{i})),' ROIs']);
end

%% average the chunks 
p = ProgressBar(NumChunks);
for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames('BPDFF.h5',FrameList);
    for j = 1:size(FrameChunk,3)
        frame = squeeze(FrameChunk(:,:,j));
        for k = 1:NumInputs
            for m = 1:length(varargin{k})
                RawTrace{k}(m,FrameList(j)) = mean(frame(varargin{k}{m})) ;
            end
        end
    end
    p.progress;    
end

%% filter and take DFDT
for i = 1:NumInputs
    for j = 1:length(varargin{i})
        LPtrace{i}(j,:) = convtrim(RawTrace{i}(j,:),ones(1,3))./3;
        DFDTtrace{i}(j,:) = zscore(diff(LPtrace{i}(j,:)));
    end
    varargout{i}.RawTrace = RawTrace{i};
    varargout{i}.LPtrace = LPtrace{i};
    varargout{i}.DFDTtrace = DFDTtrace{i};
end


        
p.stop;




        

    




end

