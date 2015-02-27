function [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NumClusters = length(unique(c));
CluToMerge = unique(c);
ValidClu = unique(c);


CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);

for i = CluToMerge'
  i
  if(ismember(i,ValidClu) == 0)
      continue;
  end
  display(['merging cluster # ',int2str(i)]);
  
  maxdist = sqrt(meanareas(i)/pi)*RadiusMultiplier; 

  nearclust = setdiff(intersect(ValidClu,find(CluDist(i,:) < maxdist)),i);
  spsize = ceil(sqrt(length(nearclust)));
  
  for k = 1:length(nearclust)
      cidx = nearclust(k); % cidx is cluster number of close transient
      if (c(cidx) ~= c(i)) 
        c(find(c == cidx)) = i;
      end
  end
  ValidClu = unique(c);
  display([int2str(length(ValidClu)),' clusters']);
  if (length(nearclust) > 0)
    [MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames,i,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);
    CluDist = pdist([meanX',meanY'],'euclidean');
    CluDist = squareform(CluDist); 
  end
  % for each nearclust
  % look at pixel overlap, in both directions, decide if it's egregious
  % If one is contained within the other, OK
  % If neither is contained within the other, want overlap in both
  % directions over X% (use high X)
  % If switch is made, call updateClusterInfo with indices of both clusters
  % changed
  
  % 2nd round with user interaction and lower X after this
  
end

end

