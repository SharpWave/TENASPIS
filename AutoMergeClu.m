function [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,CluDist,PixelAvg] = ...
    AutoMergeClu(RadiusMultiplier,c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,PixelAvg,plotdist)
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
CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);

%% Run plotting of distance between neurons if specified
if plotdist
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

%% Run actual merging functionality
% for each unique cluster index, find sufficiently close clusters and merge
%nClus = length(CluToMerge);
maxdist = RadiusMultiplier;

% Initialize ProgressBar
% resol = 10; % Percent resolution for progress bar, in this case 10%
% p = ProgressBar(100/resol);
% update_inc = round(nClus/(100/resol)); % Get increments for updating ProgressBar
for i = CluToMerge'
    
    %     if round(i/update_inc) == (i/update_inc)
    %         p.progress; % Also percent = p.progress;
    %     end
    
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
        targpix = PixelList{cidx};
        %         length(currpix),length(targpix),length(union(currpix,targpix)),
        
        % Exclusion criteria - skip to next cluster if the cluster grows
        % too much
        [a,ia,ib] = intersect(PixelList{i},PixelList{cidx});
        
        [corrval,corrp] = corr(PixelAvg{i}(ia),PixelAvg{cidx}(ib),'type','Spearman');
        
        
        figure(1);
        subh(1) = subplot(1,4,1);
        temp = zeros(Xdim,Ydim);
        temp(PixelList{i}) = PixelAvg{i};
        imagesc(temp);
        subh(2)=subplot(1,4,2);
        temp1 = zeros(Xdim,Ydim);
        temp1(PixelList{cidx}) = PixelAvg{cidx};
        imagesc(temp1);
        subh(3)=subplot(1,4,3);
        imagesc(temp1+temp);
        subplot(1,4,4);
        plot(PixelAvg{i}(ia),PixelAvg{cidx}(ib),'*');
        
        corrp,corrval,linkaxes(subh);
        pause
        
        
        
        if ((corrp > 0.05) || (corrval < 0.05))
            
            continue;
        end
        
        c(c == cidx) = i; % Update cluster number for merged clusters
        DidMerge = 1; % Flag that you have merged at least one of these clusters
        %display(['merging cluster # ',int2str(i),' and ',int2str(cidx)]);
        [PixelList,PixelAvg,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(...
            c,Xdim,Ydim,PixelList,PixelAvg,Xcent,Ycent,frames,i,meanareas,meanX,meanY,NumEvents,0);
        
    end
    ValidClu = unique(c);
    
    % If a merge happened, update all the cluster info for the next
    % iteration
    if DidMerge
        [PixelList,PixelAvg,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(...
            c,Xdim,Ydim,PixelList,PixelAvg,Xcent,Ycent,frames,i,meanareas,meanX,meanY,NumEvents,0);
        temp = UpdateCluDistances(meanX,meanY,i); % Update distances for newly merged clusters to all other clusters
        CluDist(i,:) = temp;
        CluDist(:,i) = temp;
    end
    
end
%p.stop;

end
