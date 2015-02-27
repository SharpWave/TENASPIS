function [] = InitializeClusters(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim)

AllSeg = zeros(Xdim,Ydim);

% create segment averages
parfor i = 1:NumSegments
    i
    [seg{i},Xcent(i),Ycent(i),MeanArea(i),frames{i}] = AvgSeg(SegChain{i},cc,Xdim,Ydim);
    length(SegChain{i})
    %figure(1);imagesc(AvgSeg{i});colorbar;pause;
end

% sum the average segments
for i = 1:NumSegments
    AllSeg = AllSeg + seg{i};
end

% plot the sum
figure(1);imagesc(AllSeg);

% start clustering
% main variables: X and Y centroids
c = clusterdata([Xcent',Ycent'],1);
[MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames);

save InitClu.mat c Xdim Ydim seg Xcent Ycent frames MeanNeuron meanareas meanX meanY NumEvents Invalid overlap -v7.3;


end

