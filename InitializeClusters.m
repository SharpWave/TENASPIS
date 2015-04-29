function [] = InitializeClusters()

load Segments.mat; %NumSegments SegChain cc NumFrames Xdim Ydim

% create segment averages
parfor i = 1:NumSegments
    display(['initializing transient # ',int2str(i)]);
    [PixelList{i},Xcent(i),Ycent(i),MeanArea(i),frames{i}] = AvgTransient(SegChain{i},cc,Xdim,Ydim);
    length(SegChain{i})
    
    GoodTr(i) = 1;
    
    if (MeanArea(i) < 60)
        GoodTr(i) = 0;
    end
    
    if (MeanArea(i) > 160)
        GoodTr(i) = 0;
    end
end

% edit out the faulty segments
GoodTrs = find(GoodTr);
PixelList = PixelList(GoodTrs);
Xcent = Xcent(GoodTrs);
Ycent = Ycent(GoodTrs);
MeanArea = MeanArea(GoodTrs);
frames = frames(GoodTrs);

c = (1:length(frames))'; 

[PixelList,meanareas,meanX,meanY,NumEvents] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent);

save InitClu.mat c Xdim Ydim PixelList Xcent Ycent frames meanareas meanX meanY NumEvents -v7.3;

end

