function [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,CluDist] = AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,plotdist)
% [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,CluDist] = AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,plotdist)
%   Detailed explanation goes here
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
% 
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (~exist('plotdist'))
    plotdist = 0;
end

NumClusters = length(unique(c));
CluToMerge = unique(c);
ValidClu = unique(c);


CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);
if (plotdist)
    figure;
    dists = [];
    maxovers = [];
    minovers = [];
    for j = 1:length(ValidClu)
        
        for k = 1:j-1
            if (CluDist(ValidClu(j),ValidClu(k)) < 10)
            dists = [dists,CluDist(ValidClu(j),ValidClu(k))];
            dmin = min([length(PixelList{ValidClu(j)}),length(PixelList{ValidClu(k)})]);
            dmax = max([length(PixelList{ValidClu(j)}),length(PixelList{ValidClu(k)})]);
            maxovers = [maxovers,length(intersect(PixelList{ValidClu(j)},PixelList{ValidClu(k)}))/dmax];
            minovers = [minovers,length(intersect(PixelList{ValidClu(j)},PixelList{ValidClu(k)}))/dmin];
            end
        end
    end
    hist3([maxovers',dists'],[40 40]);
    set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
   
end

% for each unique cluster index, find sufficiently close clusters and merge
for i = CluToMerge'
    if(ismember(i,ValidClu) == 0)
        continue;
    end
    BitMap = logical(zeros(Xdim,Ydim));
    BitMap(PixelList{i}) = 1;
    tempb = bwconncomp(BitMap,4);
    tempp = regionprops(tempb(1),'all');
    maxdist = RadiusMultiplier; 
    
    [sortdist,sortidx] = sort(CluDist(i,:));
    
    nearclust = setdiff(intersect(ValidClu,sortidx(find(sortdist < maxdist))),i);
    
    currpix = PixelList{i};
    
    % merge all clusters in nearclust into i
    DidMerge = 0;
    for k = 1:length(nearclust)
        cidx = nearclust(k); % cidx is cluster number of close transient
        targpix = PixelList{cidx};
        
        NumCurrClust = length(find(c == i))
        NumTargClust = length(find(c == cidx))
        
        comm = length(intersect(targpix,currpix));
        targrat = comm/length(targpix),
        currrat = comm/length(currpix),
        
        if (NumCurrClust > NumTargClust)
            denom = length(currpix);
        else
            denom = length(targpix);
        end
        
        lowrat = min([targrat,currrat]);
        highrat = max([targrat,currrat]);
        
        commremains = comm/denom
        
%         if (highrat < 0.33333)
%              display('low OVERLAP, aborting merge');
%              continue;  
%         end
%         
        if ((targrat < 0.3) && (currrat < 0.3))
            display('LOW MUTUAL OVERLAP, aborting merge');
            continue;
        end

        if (commremains < 0.1)
            display('too much reduction in mutual area, aborting merge');
            continue;
        end
        
        BitMap1 = logical(zeros(Xdim,Ydim));
        BitMap2 = logical(zeros(Xdim,Ydim));
        BitMap1(PixelList{cidx}) = 1;
        BitMap2(PixelList{i}) = 1;
        
        
   
        b = bwconncomp((BitMap1+BitMap2) > 0,4);
        b1 = bwconncomp(BitMap1);
        b2 = bwconncomp(BitMap2);
        
        r1 = regionprops(b1,'MinorAxisLength')
        r2 = regionprops(b2,'MinorAxisLength')
        CluDist(i,cidx)
        if (r1.MinorAxisLength < CluDist(i,cidx))
            display('Distance too high relative to minor axis length');
            continue;
        end
        
        if (r2.MinorAxisLength < CluDist(i,cidx))
            display('Distance too high relative to minor axis length');
            continue;
        end
        
        if (length(union(currpix,targpix)) > 150)
            display('merge would create an area too big; merge aborted');
            continue;
        end
        
        if (length(intersect(currpix,targpix)) < 40)
            display('merge would create an area too small; merge aborted');
            continue;
        end
        
        if (b.NumObjects > 1)
            display('Merge would create neuron with discontiguous pixels; merge aborted');
            continue;
        end
        if (b.NumObjects == 0)
            display('somehow no common pixels in merge');
            continue;
        end
        
        %% check for overlapping frames
        if(length(intersect(frames{i},frames{cidx}) > 0))
            display('overlapping frames, this should never happen');
            keyboard;
            continue;
        end
        
        c(find(c == cidx)) = i;
        DidMerge = 1;
        display(['merging cluster # ',int2str(i),' and ',int2str(cidx)]);
        [PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,i,meanareas,meanX,meanY,NumEvents,frames);
        
    end
    ValidClu = unique(c);
    
    if (DidMerge)
        [PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,i,meanareas,meanX,meanY,NumEvents,frames);
        [CluDist] = UpdateCluDistances(CluDist,meanX,meanY,ValidClu,i);
    end
    
end

end

