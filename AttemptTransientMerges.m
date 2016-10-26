function [Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg] = AttemptTransientMerges(DistThresh,Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg,CircMask)
%
%  Attempt to merge all cluster pairs where centroid distance is less than
%  DistThresh
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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
%
%% Get parameters
[

%% setup some variables
ClusterList = unique(Trans2ROI); % this ends up being the indices into the input data array elements that contain currently remaining clusters
display([int2str(length(ClusterList)),' clusters left']);

% Get distance from each cluster to all the others
CluDist = pdist([Xcent',Ycent'],'euclidean');
CluDist = squareform(CluDist);

%% Run actual merging functionality
for i = 1:length(ClusterList)
    CurrClu = ClusterList(i);
    
    if (Trans2ROI(CurrClu) ~= CurrClu)
        % cluster already merged during this call, move to next iteration
        continue;
    end
    
    % Sort the Clusters from closest to farthest away from cluster i
    [sortdist,sortidx] = sort(CluDist(CurrClu,:));
    
    % clusters that are within the distance threshold that aren't CurrClu
    NearCluIdx = setdiff(intersect(ClusterList,sortidx(sortdist <= DistThresh)),CurrClu);
        
    % try merging each cluster in NearCluIdx into CurrClu 
    for k = 1:length(NearCluIdx)
        CandIdx = NearCluIdx(k); % CandIdx is index of candidate cluster
        
        if (Trans2ROI(CandIdx) ~= CandIdx)
        % cluster already merged during this call, move to next iteration
          continue;
        end
        
        % determine correleation values for the union of CurrClu and
        % CandIdx        

        u = union(PixelList{i},PixelList{CandIdx});
        [~,idx1] = ismember(u,CircMask{i});
        [~,idx2] = ismember(u,CircMask{CandIdx});
        
        [BigCorrVal,BigCorrP] = corr(BigPixelAvg{i}(idx1),BigPixelAvg{CandIdx}(idx2),'Spearman');        
        
        if ((BigCorrP > 0.001) || (BigCorrVal < 0.05))        
            % reject the merge
            continue;
        end
        MergeClus = [MergeClus,CandIdx];
        Trans2ROI(Trans2ROI == CandIdx) = i; % Update cluster number for merged clusters
    end
        
    % If a merge happened, update all the cluster info for the next
    % iteration
    if ~isempty(MergeClus)
        MergeClus = [i,MergeClus];
        [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,FrameList] = UpdateClusterInfo(...
            MergeClus,Xdim,Ydim,PixelList,PixelAvg,BigPixelAvg,CircMask,Xcent,Ycent,FrameList,i);
        temp = UpdateCluDistances(Xcent,Ycent,i); % Update distances for newly merged clusters to all other clusters
        CluDist(i,:) = temp;
        CluDist(:,i) = temp;
    end
    
end
%p.stop;

end
