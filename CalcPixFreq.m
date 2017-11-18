function [PixFreq] = CalcPixFreq(FrameList,ObjList,BlobPixelIdxList)
% Calculates for each pixel, for this transient, how often it was in a blob

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
PixFreq = zeros(Xdim,Ydim);

for i = 1:length(FrameList)
    FrameNum = FrameList(i);
    ObjNum = ObjList(i);
    PixFreq(BlobPixelIdxList{FrameNum}{ObjNum}) = PixFreq(BlobPixelIdxList{FrameNum}{ObjNum}) + 1;
end
PixFreq = PixFreq/length(FrameList);

