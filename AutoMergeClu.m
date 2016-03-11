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

    maxdist = RadiusMultiplier; 
    
    [sortdist,sortidx] = sort(CluDist(i,:));
    
    nearclust = setdiff(intersect(ValidClu,sortidx(find(sortdist < maxdist))),i);
    
    currpix = PixelList{i};
    
    % merge all clusters in nearclust into i
    DidMerge = 0;
    for k = 1:length(nearclust)
        cidx = nearclust(k); % cidx is cluster number of close transient
        targpix = PixelList{cidx};
        length(currpix),length(targpix),length(union(currpix,targpix)),

        if (length(union(currpix,targpix)) > max(length(currpix),length(targpix))*1.3)
            display('Merge would inflate cluster too much');
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

