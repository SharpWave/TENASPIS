function [PixelList,Xcent,Ycent,MeanArea,frames] = AvgTransient(SegChain,cc,Xdim,Ydim)
% [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% goes through all of the frames of a particular transient and calculates
% some basic stats


Xcent = 0;
Ycent = 0;
MeanArea = 0;
frames = [];

AvgN = zeros(Xdim,Ydim);

for i = 1:length(SegChain)
    FrameNum = SegChain{i}(1);
    ObjNum = SegChain{i}(2);
    frames = [frames,FrameNum];
    ts = regionprops(cc{FrameNum},'all');
    temp = zeros(Xdim,Ydim);
    temp(ts(ObjNum).PixelIdxList) = 1;
    AvgN = AvgN + temp;
end
AvgN = AvgN./length(SegChain);

if (max(AvgN(:)) == 1)
    AvgN = AvgN > 0.9;
    PixelList = find(AvgN);
        
    b = bwconncomp(AvgN,4);
    bstat = regionprops(b,'all');
    
    Xcent = bstat(1).Centroid(1);
    Ycent = bstat(1).Centroid(2);
    MeanArea = bstat(1).Area;
else
    PixelList = [];
    Xcent = 0;
    Ycent = 0;
    MeanArea = 0;
end
end
