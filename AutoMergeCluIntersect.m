function [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeCluIntersect(RadiusMultiplier,c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap,thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NumClusters = length(unique(c));
CluToMerge = unique(c);
ValidClu = unique(c);

CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);


% for each unique cluster index, find sufficiently close clusters and merge
for i = CluToMerge'
    i
    
    if(ismember(i,ValidClu) == 0)
        continue;
    end
    
    currpix = find(MeanNeuron{i});
    for j = CluToMerge'
        if (CluDist(i,j) > 50)
            continue;
        end
        if (i == j)
            continue;
        end
        if(ismember(j,ValidClu) == 0)
            continue;
        end
        targpix = find(MeanNeuron{j});
        comm = length(intersect(targpix,currpix));
        targrat(i,j) = comm/length(targpix);
        currrat(i,j) = comm/length(currpix);
        
        if ((targrat(i,j) > thresh) && (currrat(i,j) > thresh))
            if (targrat(i,j) > 0) display(num2str(targrat(i,j))); end
            if (currrat(i,j) > 0) display(num2str(currrat(i,j)));end
            c(find(c == j)) = i;
            ValidClu = unique(c);
            display(['merging clu ',num2str(i),' and ',num2str(j)]);
            [MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames,i,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);
            CluDist = pdist([meanX',meanY'],'euclidean');
            CluDist = squareform(CluDist);
        end
    end
end
keyboard



end

