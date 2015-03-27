function [c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,seg,Xcent,Ycent,frames,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap)
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
    
    tempb = bwconncomp(MeanNeuron{i},4);
    tempp = regionprops(tempb(1),'all');
    maxdist = tempp(1).MinorAxisLength*RadiusMultiplier;
    
    %maxdist = sqrt(meanareas(i)/pi)*RadiusMultiplier;
    
    nearclust = setdiff(intersect(ValidClu,find(CluDist(i,:) < maxdist)),i);
    
    currpix = find(MeanNeuron{i});
    
    % merge all clusters in nearclust into i
    DidMerge = 0;
    for k = 1:length(nearclust)
        cidx = nearclust(k); % cidx is cluster number of close transient
        targpix = find(MeanNeuron{cidx});
        
        comm = length(intersect(targpix,currpix));
        targrat = comm/length(targpix),
        currrat = comm/length(currpix),
        
        if ((targrat < 0.5) && (currrat < 0.5))
            display('SUSPECTED BAD MERGE');
            continue;
            %           
            %           figure(901);
            %           set(gcf,'Position',[534 72 1171 921]);
            %
            %           temp = zeros(size(MeanNeuron{i}))-2;
            %           temp(currpix) = 1;
            %           temp = temp-MeanNeuron{cidx};
            %           imagesc(temp);
            %           pause;
            
        end
        b = bwconncomp(MeanNeuron{cidx}.*MeanNeuron{i},4);
        if (b.NumObjects > 1)
            display('Degenerate Cluster Avoided');
            continue;
        end
        if (b.NumObjects == 0)
            display('somehow no common pixels in merge'); 
            continue;
        end
        
        c(find(c == cidx)) = i;
        DidMerge = 1;
        display(['merging cluster # ',int2str(i),' and ',int2str(cidx)]);
        [MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames,i,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap);
    end
    ValidClu = unique(c);
    display([int2str(length(ValidClu)),' clusters']);
    if (DidMerge)
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

