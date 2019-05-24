function [OutChunk] = MakeTraceChunk(FrameList,PixelIdxList,PixelAvg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SampleRate = Get_T_Params('SampleRate');
Set_T_Params('BPDFF.h5', SampleRate);
NumFrames = Get_T_Params('NumFrames');
NumNeurons = length(PixelIdxList);

[CorrR,CorrP,RawTrace] = deal(zeros(NumNeurons,NumFrames,'single'));

FrameChunk = LoadFrames('BPDFF.h5',FrameList);

for j = 1:size(FrameChunk,3)
    frame = squeeze(FrameChunk(:,:,j));    
    for m = 1:NumNeurons
        RawTrace(m,FrameList(j)) = mean(frame(PixelIdxList{m}));
        [CorrR(m,FrameList(j)),CorrP(m,FrameList(j))] = corr(frame(PixelIdxList{m}),PixelAvg{m},'type','Spearman');
    end    
end

OutChunk.RawTrace = RawTrace;
OutChunk.CorrR = CorrR;
OutChunk.CorrP = CorrP;

end

