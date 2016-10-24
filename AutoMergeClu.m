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
display([int2str(length(ValidClu)),' clusters left']);
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
    MergeClus = [];
    for k = 1:length(nearclust)
        % Grab pixels for the nearest cluster
        cidx = nearclust(k); % cidx is cluster number of close transient

        [a,ia,ib] = intersect(PixelList{i},PixelList{cidx});
        u = union(PixelList{i},PixelList{cidx});
        [~,idx1] = ismember(u,cm{i});
        [~,idx2] = ismember(u,cm{cidx});
        
        [Bigcorrval,Bigcorrp] = corr(BigPixelAvg{i}(idx1),BigPixelAvg{cidx}(idx2));
        
        [corrval,corrp] = corr(PixelAvg{i}(ia),PixelAvg{cidx}(ib),'type','Spearman');
        

        
        
        if ((Bigcorrp > 0.001) || (Bigcorrval < 0.05))
                    
%             figure(1);
%             
%             lf1 = length(frames{i});
%             lf2 = length(frames{cidx});
%             
%             subh(1) = subplot(2,4,1);
%             temp = zeros(Xdim,Ydim);
%             temp(PixelList{i}) = PixelAvg{i};
%             imagesc(temp);axis image;caxis([0.01 max(PixelAvg{i})]);
%             title(int2str(length(frames{i})));
%             
%             subh(2)=subplot(2,4,2);
%             temp1 = zeros(Xdim,Ydim);
%             temp1(PixelList{cidx}) = PixelAvg{cidx};
%             imagesc(temp1);axis image;caxis([0.01 max(PixelAvg{cidx})]);
%             title(int2str(length(frames{cidx})));
%             
%             subh(3)=subplot(2,4,3);
%             imsum = (temp1*lf2+temp*lf1)./(lf1+lf2);
%             imagesc(imsum);axis image;caxis([0.01 max(imsum(:))]);
%             
%             subplot(2,4,4);
%             plot(PixelAvg{i}(ia),PixelAvg{cidx}(ib),'*');axis equal;
%             
%             subh(4) = subplot(2,4,5);
%             temp = zeros(Xdim,Ydim);
%             temp(cm{i}) = BigPixelAvg{i};
%             imagesc(temp);axis image;caxis([0.01 max(PixelAvg{i})]);
%             
%             subh(5) = subplot(2,4,6);
%             temp1 = zeros(Xdim,Ydim);
%             temp1(cm{cidx}) = BigPixelAvg{cidx};
%             imagesc(temp1);axis image;caxis([0.01 max(PixelAvg{cidx})]);
%             
%             subh(6) = subplot(2,4,7);
%             imsum = (temp1*lf2+temp*lf1)./(lf1+lf2);
%             imagesc(imsum);axis image;caxis([0.01 max(imsum(:))]);
%             
%             subplot(2,4,8);
%             plot(BigPixelAvg{i}(idx1),BigPixelAvg{cidx}(idx2),'*');axis equal;
%             
%             
%             
%             corrp,corrval,Bigcorrval,Bigcorrp,linkaxes(subh);
%             pause
        
            % reject the merge
            continue;
        end
        MergeClus = [MergeClus,cidx];
        c(c == cidx) = i; % Update cluster number for merged clusters

    end
    ValidClu = unique(c);
    
    % If a merge happened, update all the cluster info for the next
    % iteration
    if ~isempty(MergeClus)
        MergeClus = [i,MergeClus];
        [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,frames] = UpdateClusterInfo(...
            MergeClus,Xdim,Ydim,PixelList,PixelAvg,BigPixelAvg,cm,Xcent,Ycent,frames,i);
        temp = UpdateCluDistances(Xcent,Ycent,i); % Update distances for newly merged clusters to all other clusters
        CluDist(i,:) = temp;
        CluDist(:,i) = temp;
    end
    
end
%p.stop;

end
