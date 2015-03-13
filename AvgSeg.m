function [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% [seg,Xcent,Ycent,MeanArea,frames] = AvgSeg(SegChain,cc,Xdim,Ydim)
% BIG TODO: fix this fucking function


%   Detailed explanation goes here
    seg = zeros(Xdim,Ydim);
    Xcent = 0;
    Ycent = 0;
    MeanArea = 0;
    frames = [];
    
    for j = 1:length(SegChain)
        FrameNum = SegChain{j}(1);
        ObjNum = SegChain{j}(2);
        frames = [frames,FrameNum];
        ts = regionprops(cc{FrameNum},'all');
        
       
        tempFrame = zeros(Xdim,Ydim);
        %keyboard;
        tempFrame(ts(ObjNum).PixelIdxList) = 1;
        Xcent = Xcent + ts(ObjNum).Centroid(1);
        Ycent = Ycent + ts(ObjNum).Centroid(2);
        MeanArea = MeanArea + ts(ObjNum).Area;
        seg = seg + tempFrame;
    end
    Xcent = Xcent / length(SegChain);
    Ycent = Ycent / length(SegChain);
    MeanArea = MeanArea / length(SegChain);
    seg = seg./length(SegChain);
end

