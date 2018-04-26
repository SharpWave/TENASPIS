function [Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg] = AttemptTransientMerges(DistThresh,Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg,CircMask)
% [Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg] = AttemptTransientMerges(DistThresh,Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg,CircMask)
%  Attempt to merge all cluster pairs where centroid distance is less than DistThresh
%
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
[MinTransientMergeCorrR,MaxTransientMergeCorrP] = ...
    Get_T_Params('MinTransientMergeCorrR','MaxTransientMergeCorrP');

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
        % of the for loop
        continue;
    end
    
    % Sort the Clusters from closest to farthest away from CurrClu
    [sortdist,sortidx] = sort(CluDist(CurrClu,:));
    
    % keep clusters that are within the distance threshold that aren't CurrClu
    NearCluIdx = setdiff(intersect(ClusterList,sortidx(sortdist <= DistThresh)),CurrClu);
    
    % try merging each cluster in NearCluIdx into CurrClu
    MergeOK = [];
    for k = 1:length(NearCluIdx)
        CandIdx = NearCluIdx(k); % CandIdx is index of candidate cluster
        
        if (Trans2ROI(CandIdx) ~= CandIdx)
            % cluster already merged during this call, move to next iteration
            continue;
        end
        
        % determine correleation values for the union of CurrClu and
        % CandIdx

        u = union(PixelList{CurrClu},PixelList{CandIdx});

        [~,idx1] = ismember(u,CircMask{CurrClu});
        [~,idx2] = ismember(u,CircMask{CandIdx});
        
        try
        [BigCorrVal,BigCorrP] = corr(BigPixelAvg{CurrClu}(idx1),BigPixelAvg{CandIdx}(idx2),'type','Spearman');
        catch
            keyboard;
        end
        
%         if ((BigCorrVal >= 0.2) && (BigCorrVal < 0.3))
%         PlotTransientMerge(BigPixelAvg{CurrClu},BigPixelAvg{CandIdx},idx1,idx2,CircMask{CurrClu},CircMask{CandIdx},PixelList{CurrClu},PixelList{CandIdx},Trans2ROI,CurrClu,CandIdx);
%         end

        
        if ((BigCorrP >= MaxTransientMergeCorrP) || (BigCorrVal < MinTransientMergeCorrR))
            % reject the merge
            
            
            continue;
        end

        if (~isempty(intersect(FrameList{CandIdx},FrameList{CurrClu})))
            % just in case by some messed up edge case it wants to merge
            % temporally overlapping clusters
            continue;
        end
        MergeOK = [MergeOK,CandIdx];
        Trans2ROI(Trans2ROI == CandIdx) = CurrClu; % Update cluster number for all transients part of CandIdx to CurrClu
    end
    
    % If a merge happened, update all the cluster info for the next
    % iteration
    if ~isempty(MergeOK)
        [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,FrameList,ObjList] = UpdateClusterInfo(...
            MergeOK,PixelList,PixelAvg,BigPixelAvg,CircMask,Xcent,Ycent,FrameList,ObjList,CurrClu);
        temp = UpdateCluDistances(Xcent,Ycent,CurrClu); % Update distances for newly merged clusters to all other clusters
        CluDist(CurrClu,:) = temp;
        CluDist(:,CurrClu) = temp;
    end
    
end

end
