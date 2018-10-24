function [rmap,pmap] = TraceCorrelationMap(TargetPixelIdxList,PixelsToMap,Frames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global T_MOVIE;
TargetTrace = CalcROITrace(TargetPixelIdxList,Frames);
NumPixels = length(PixelsToMap);

temptrace = zeros(length(Frames),NumPixels);

for i = 1:NumPixels
    temptrace(:,i) = CalcROITrace(PixelsToMap(i),Frames)';
end

[rmap,pmap] = corr(TargetTrace',temptrace);


