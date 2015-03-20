function [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% goes through all of the frames of a particular transient and calculates
% some basic stats 



%   Detailed explanation goes here
    seg = zeros(Xdim,Ydim);
    Xcent = 0;
    Ycent = 0;
    MeanArea = 0;
    frames = [];
    CommonPixels = [];
    
    for i = 1:length(SegChain)
        FrameNum = SegChain{i}(1);
        ObjNum = SegChain{i}(2);
        frames = [frames,FrameNum];
        ts = regionprops(cc{FrameNum},'all');   
        if (i == 1)
            CommonPixels = ts(ObjNum).PixelIdxList;
        else
            CommonPixels = intersect(CommonPixels,ts(ObjNum).PixelIdxList);
        end
    end
    
    if (length(CommonPixels) > 0)
        seg = single(zeros(Xdim,Ydim));
        seg(CommonPixels) = 1;

        b = bwconncomp(seg,4);
        bstat = regionprops(b,'all');

        Xcent = bstat(1).Centroid(1);
        Ycent = bstat(1).Centroid(2);
        MeanArea = bstat(1).Area;
    else
       seg = zeros(Xdim,Ydim);
       Xcent = 0;
       Ycent = 0;
       MeanArea = 0;
    end
end
