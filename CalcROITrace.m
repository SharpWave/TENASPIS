function [trace] = CalcROITrace(PixelIdxList,Frames)

% Tenaspis: Calculates a trace for the pixels in PixelIdxList over the time
% range(s) specified by Frames
global T_MOVIE;
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

NumPixels = length(PixelIdxList);
[xidx,yidx] = ind2sub([Xdim Ydim],PixelIdxList);
temptrace = zeros(NumPixels,length(Frames),'single');

for j = 1:NumPixels
    temptrace(j,:) = T_MOVIE(xidx(j),yidx(j),Frames);
end
if(NumPixels > 1)
    trace = mean(temptrace);
else
    trace = temptrace;
end
end

