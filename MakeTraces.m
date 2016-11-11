function [varargout] = MakeTraces(varargin)
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
NumInputs = length(varargin)/2;

% Chunking variables
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);


%% initialize outputs and unpack some variables from varargin for clarity
[RawTrace,CorrP,CorrR,LPtrace,DFDTtrace,varargout] = deal(cell(1,NumInputs));

for i = 1:NumInputs
  RawTrace{i} = zeros(length(varargin{i*2}),NumFrames,'single');
  CorrP{i} = zeros(length(varargin{i*2}),NumFrames,'single');
  CorrR{i} = zeros(length(varargin{i*2}),NumFrames,'single');
  disp(['making traces for ',int2str(length(varargin{i*2})),' ROIs']);
end

%% average the chunks 
p = ProgressBar(NumChunks);
for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames('BPDFF.h5',FrameList);
    for j = 1:size(FrameChunk,3)
        frame = squeeze(FrameChunk(:,:,j));
        for k = 1:NumInputs
            for m = 1:length(varargin{k*2})
                RawTrace{k}(m,FrameList(j)) = mean(frame(varargin{(k-1)*2+1}{m}));
                [CorrR{k}(m,FrameList(j)),CorrP{k}(m,FrameList(j))] = corr(frame(varargin{(k-1)*2+1}{m}),varargin{k*2}{m},'type','Spearman');
            end
        end
    end
    p.progress;    
end

%% filter and take DFDT
disp('filtering traces');
for i = 1:NumInputs
    for j = 1:length(varargin{i*2})
        LPtrace{i}(j,:) = convtrim(RawTrace{i}(j,:),ones(1,3))./3;
        DFDTtrace{i}(j,:) = zscore(diff(LPtrace{i}(j,:)));
    end
    DFDTtrace{i}(j,2:end+1) = DFDTtrace{i}(j,:);
    DFDTtrace{i}(j,1) = 0;
    varargout{i}.RawTrace = RawTrace{i};
    varargout{i}.LPtrace = LPtrace{i};
    varargout{i}.DFDTtrace = DFDTtrace{i};
    varargout{i}.CorrR = CorrR{i};
    varargout{i}.CorrP = CorrP{i};
end


        
p.stop;




        

    




end

