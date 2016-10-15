function [c,PixelList,Xcent,Ycent,frames,PixelAvg,BigPixelAvg] = AutoMergeClu(maxdist,c,Xdim,Ydim,PixelList,Xcent,Ycent,frames,PixelAvg,BigPixelAvg,cm)
% [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,CluDist] = ...
%   AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,...
%   meanX,meanY,NumEvents,frames,plotdist)
%   Automatically merges clusters whose centroids are less than RadiusMultiplier
%   apart from one other
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

if ~exist('plotdist','var')
    plotdist = 0;
end

% keyboard
%NumClusters = length(unique(c));

% Identify unique clusters
CluToMerge = unique(c);
ValidClu = unique(c);

% Get distance from each cluster to all the others
CluDist = pdist([Xcent',Ycent'],'euclidean');
CluDist = squareform(CluDist);

%% Run actual merging functionality

% for each unique cluster index, find sufficiently close clusters and merge


for i = CluToMerge'

    % If the cluster is no longer valid (i.e it has already been merged
    % into a previous cluster), skip to next cluster
    if ~ismember(i,ValidClu)
        continue;
    end
    
    % Sort the Clusters from closest to farthest away from cluster i
    [sortdist,sortidx] = sort(CluDist(i,:));
    
    % Get nearest valid clusters (those that are valid, closer than the
    % distance threshold, and are not cluster i itself)
    nearclust = setdiff(intersect(ValidClu,sortidx(sortdist < maxdist)),i);
    
    currpix = PixelList{i};
    
    % Merge all clusters in nearclust into i
    DidMerge = 0;
    for k = 1:length(nearclust)
        % Grab pixels for the nearest cluster
        cidx = nearclust(k); % cidx is cluster number of close transient

        [a,ia,ib] = intersect(PixelList{i},PixelList{cidx});
        
        [corrval,corrp] = corr(PixelAvg{i}(ia),PixelAvg{cidx}(ib),'type','Spearman');
        
        if (maxdist >= 0.5)
            figure(1);
            subh(1) = subplot(1,4,1);
            temp = zeros(Xdim,Ydim);
            temp(PixelList{i}) = PixelAvg{i};
            imagesc(temp);axis image;
            subh(2)=subplot(1,4,2);
            temp1 = zeros(Xdim,Ydim);
            temp1(PixelList{cidx}) = PixelAvg{cidx};
            imagesc(temp1);axis image;
            subh(3)=subplot(1,4,3);
            imagesc(temp1+temp);axis image;
            subplot(1,4,4);
            plot(PixelAvg{i}(ia),PixelAvg{cidx}(ib),'*');
            
            corrp,corrval,linkaxes(subh);
            pause
        end
        
        
        if ((corrp > 0.05) || (corrval < 0.05))
            % reject the merge
            continue;
        end
        
        c(c == cidx) = i; % Update cluster number for merged clusters
        DidMerge = 1; % Flag that you have merged at least one of these clusters
        %display(['merging cluster # ',int2str(i),' and ',int2str(cidx)]);
    end
    ValidClu = unique(c);
    
    % If a merge happened, update all the cluster info for the next
    % iteration
    if DidMerge
        [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,frames] = UpdateClusterInfo(...
            c,Xdim,Ydim,PixelList,PixelAvg,BigPixelAvg,cm,Xcent,Ycent,frames,i);
        temp = UpdateCluDistances(Xcent,Ycent,i); % Update distances for newly merged clusters to all other clusters
        CluDist(i,:) = temp;
        CluDist(:,i) = temp;
    end
    
end
%p.stop;

end
