function [rmap,pmap] = TraceCorrelationMap(TargetPixelIdxList,PixelsToMap,Frames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global T_MOVIE;
TargetTrace = CalcROITrace(TargetPixelIdxList,Frames);
NumPixels = length(PixelsToMap)

for i = 1:NumPixels
    temptrace = CalcROItrace(PixelsToMap(i),Frames);
    [rmap(i),pmap(i)] = corr(TargetTrace,temptrace);
end

