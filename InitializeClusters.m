function [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim)

AllSeg = zeros(Xdim,Ydim);

% create segment averages
parfor i = 1:NumSegments
    i
    [seg{i},Xcent(i),Ycent(i),MeanArea(i),frames{i}] = AvgSeg(SegChain{i},cc,Xdim,Ydim);
    length(SegChain{i})
    
    if (MeanArea(i) == 0)
        GoodSeg(i) = 0;
    else
        GoodSeg(i) = 1;
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

% sum the average segments
for i = 1:NumSegments
    AllSeg = AllSeg + seg{i};
end

% plot the sum
figure(1);imagesc(AllSeg);

% start clustering
% main variables: X and Y centroids
%c = clusterdata([Xcent',Ycent'],1);

c = (1:NumSegments)'; % don't use clusterdata due to possibility of overclustering

[MeanNeuron,meanareas,meanX,meanY,NumEvents] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames);

save InitClu.mat c Xdim Ydim seg Xcent Ycent frames MeanNeuron meanareas meanX meanY NumEvents -v7.3;



end

