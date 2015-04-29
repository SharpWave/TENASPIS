function [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames] = AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NumClusters = length(unique(c));
CluToMerge = unique(c);
ValidClu = unique(c);


CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);

% for each unique cluster index, find sufficiently close clusters and merge
for i = CluToMerge'
    if(ismember(i,ValidClu) == 0)
        continue;
    end
    BitMap = logical(zeros(Xdim,Ydim));
    BitMap(PixelList{i}) = 1;
    tempb = bwconncomp(BitMap,4);
    tempp = regionprops(tempb(1),'all');
    maxdist = RadiusMultiplier; % try it straight up
    
    %maxdist = tempp(1).MinorAxisLength*RadiusMultiplier;
    
    %maxdist = sqrt(meanareas(i)/pi)*RadiusMultiplier;
    
    nearclust = setdiff(intersect(ValidClu,find(CluDist(i,:) < maxdist)),i);
    
    currpix = PixelList{i};
    
    % merge all clusters in nearclust into i
    DidMerge = 0;
    for k = 1:length(nearclust)
        cidx = nearclust(k); % cidx is cluster number of close transient
        targpix = PixelList{cidx};
        
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
        BitMap1 = logical(zeros(Xdim,Ydim));
        BitMap2 = logical(zeros(Xdim,Ydim));
        BitMap1(PixelList{cidx}) = 1;
        BitMap2(PixelList{i}) = 1;
        
        b = bwconncomp(BitMap1.*BitMap2,4);
        if (b.NumObjects > 1)
            display('Degenerate Cluster Avoided');
            continue;
        end
        if (b.NumObjects == 0)
            display('somehow no common pixels in merge'); 
            continue;
        end
        
        %% check for overlapping frames
        if(length(intersect(frames{i},frames{cidx}) > 0))
            display('overlapping frames');
            keyboard;
            continue;
        end
        
        c(find(c == cidx)) = i;
        DidMerge = 1;
        display(['merging cluster # ',int2str(i),' and ',int2str(cidx)]);
        
            
        %[PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,i,meanareas,meanX,meanY,NumEvents,frames);
        % TODO: put CluDist code here, BUT ONLY UPDATE THE NEURON I
        % ACTUALLY leave after the merge
        
    end
    ValidClu = unique(c);
    
    if (DidMerge)
        [PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,i,meanareas,meanX,meanY,NumEvents,frames);
        [CluDist] = UpdateCluDistances(CluDist,meanX,meanY,ValidClu,i);
%         CluDist = pdist([meanX',meanY'],'euclidean');
%         CluDist = squareform(CluDist);
%         display([int2str(length(ValidClu)),' clusters']);
    end
    
end

end

