function [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim)

% create segment averages
parfor i = 1:NumSegments
    i
    [seg{i},Xcent(i),Ycent(i),MeanArea(i),frames{i}] = AvgSeg(SegChain{i},cc,Xdim,Ydim);
    length(SegChain{i})
    
    GoodSeg(i) = 1;
    
    if (MeanArea(i) < 60)
        GoodSeg(i) = 0;
    end
    
    if (MeanArea(i) > 160)
        GoodSeg(i) = 0;
    end
end

% edit out the faulty segments
GoodSegs = find(GoodSeg);
seg = seg(GoodSegs);
Xcent = Xcent(GoodSegs);
Ycent = Ycent(GoodSegs);
MeanArea = MeanArea(GoodSegs);
frames = frames(GoodSegs);

NumSegments = length(GoodSegs);

c = (1:NumSegments)'; 

[MeanNeuron,meanareas,meanX,meanY,NumEvents] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames);

save InitClu.mat c Xdim Ydim seg Xcent Ycent frames MeanNeuron meanareas meanX meanY NumEvents -v7.3;



end

