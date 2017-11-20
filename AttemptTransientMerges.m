function [Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg] = AttemptTransientMerges(DistThresh,MinCorr,Trans2ROI,PixelList,Xcent,Ycent,FrameList,ObjList,PixelAvg,BigPixelAvg,CircMask,BlobPixelIdxList)
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
[MinTransientMergeCorrR,MaxTransientMergeCorrP,Xdim,Ydim] = Get_T_Params('MinTransientMergeCorrR','MaxTransientMergeCorrP','Xdim','Ydim');

%% setup some variables
ClusterList = unique(Trans2ROI); % this ends up being the indices into the input data array elements that contain currently remaining clusters
display([int2str(length(ClusterList)),' clusters left']);

% Get distance from each cluster to all the others
CluDist = pdist([Xcent',Ycent'],'euclidean');
CluDist = squareform(CluDist);

blankframe = zeros(Xdim,Ydim);

%% Run actual merging functionality
for i = 1:length(ClusterList)
    CurrClu = ClusterList(i);
    
    if (Trans2ROI(CurrClu) ~= CurrClu)
        % cluster already merged during this call, move to next iteration
        % of the for loop
        continue;
    end
%     if(mod(i,400) == 0)
%         i/length(ClusterList),length(unique(Trans2ROI)),
%     end
    % Sort the Clusters from closest to farthest away from CurrClu
    [sortdist,sortidx] = sort(CluDist(CurrClu,:));
    
    % keep clusters that are within the distance threshold that aren't CurrClu
    NearCluIdx = setdiff(intersect(ClusterList,sortidx(sortdist <= DistThresh)),CurrClu);
    
    % try merging each cluster in NearCluIdx into CurrClu
    MergeOK = [];
    
    
    %LowPassFilter = fspecial('disk',3);
    %CurrAvg = imfilter(CurrAvg,LowPassFilter,'replicate');
    
    
    clear a1;
    clear CurrFreq;
    
    for k = 1:length(NearCluIdx)
        CandIdx = NearCluIdx(k); % CandIdx is index of candidate cluster
        
        if (Trans2ROI(CandIdx) ~= CandIdx)
            % cluster already merged during this call, move to next iteration
            continue;
        end
        
        if (~isempty(intersect(FrameList{CandIdx},FrameList{CurrClu})))
            % just in case by some messed up edge case it wants to merge
            % temporally overlapping clusters
            %disp('wow this actually happens');
            continue;
        end
        
        % need overlapping pixels in the ROIs
        commpix = intersect(PixelList{CurrClu},PixelList{CandIdx});
        if(isempty(commpix))
            continue;
        end
        
        % intersection must contain peak of CurrClu
        idx = sub2ind([Xdim,Ydim],Ycent(CurrClu),Xcent(CurrClu));
        if (~ismember(idx,commpix))
            %disp('threw out a sneaky overmerge');
            continue;
        end
        
        idx = sub2ind([Xdim,Ydim],Ycent(CandIdx),Xcent(CandIdx));
        if (~ismember(idx,commpix))
            %disp('threw out a sneaky overmerge');
            continue;
        end
        
        
        
        if(~exist('CurrFreq','var'))
            CurrFreq = CalcPixFreq(FrameList{CurrClu},ObjList{CurrClu},BlobPixelIdxList);
        end
        
        CandFreq = CalcPixFreq(FrameList{CandIdx},ObjList{CandIdx},BlobPixelIdxList);
        CombFreq = zeros(Xdim,Ydim);
        CombFreq = CandFreq*length(FrameList{CandIdx})+CurrFreq*length(FrameList{CurrClu});
        CombFreq = CombFreq/(length(FrameList{CandIdx})+length(FrameList{CurrClu}));
        CombPixIdx = find(CombFreq > 0.5);
        
        CombPixIdx = intersect(CombPixIdx,CircMask{CurrClu});
        CombPixIdx = intersect(CombPixIdx,CircMask{CandIdx});
        
        %CombPixIdx = intersect(PixelList{CurrClu},PixelList{CandIdx});
        
        if(isempty(CombPixIdx))
            disp('empty combo');
            continue;
        end
        
        if(~exist('a1','var'))
            [a1,xOff1,yOff1] = BoxGradient(CircMask{CurrClu},BigPixelAvg{CurrClu},Xdim,Ydim);
        end
        [a2,xOff2,yOff2] = BoxGradient(CircMask{CandIdx},BigPixelAvg{CandIdx},Xdim,Ydim);
        
        % Comb Pix Indices (full coords)
        [cx,cy] = ind2sub([Xdim Ydim],CombPixIdx);
        
        % Left shift indices for a1's coordinates
        cx1 = cx-xOff1+1;
        cy1 = cy-yOff1+1;
        BoxCombPixIdx1 = sub2ind(size(a1),cx1,cy1);
        cx2 = cx-xOff2+1;
        cy2 = cy-yOff2+1;
        
        BoxCombPixIdx2 = sub2ind(size(a2),cx2,cy2);
        
        [circ_rVal,circ_pVal] = circ_corrcc(deg2rad(a1(BoxCombPixIdx1)),deg2rad(a2(BoxCombPixIdx2)));
        phasediffs = angdiff(deg2rad(a1(BoxCombPixIdx1)),deg2rad(a2(BoxCombPixIdx2)));
        meanphasediff = rad2deg(circ_mean(phasediffs));
        [~, s0] = circ_std(phasediffs);
        stdphasediff = rad2deg(s0);
        [~,idx1] = ismember(CombPixIdx,CircMask{CurrClu});
        [~,idx2] = ismember(CombPixIdx,CircMask{CandIdx});
        
        [BigCorrVal,BigCorrP] = corr(BigPixelAvg{CurrClu}(idx1),BigPixelAvg{CandIdx}(idx2),'type','Spearman');
        
        if (stdphasediff > MinCorr)
            
            continue;
        end
        
%         if (CluDist(CurrClu,CandIdx) >= 8)
%                 stdphasediff,
%                 PlotTransientMerge(BigPixelAvg{CurrClu},BigPixelAvg{CandIdx},idx1,idx2,CircMask{CurrClu},CircMask{CandIdx},PixelList{CurrClu},PixelList{CandIdx},Trans2ROI,CurrClu,CandIdx,a1,a2,CombPixIdx,BoxCombPixIdx1,BoxCombPixIdx2);
%                 CluDist(CurrClu,CandIdx),figure(5);polarhistogram(phasediffs);
%                 pause;
%             
%         end
        
        MergeOK = [MergeOK,CandIdx];
        Trans2ROI(Trans2ROI == CandIdx) = CurrClu; % Update cluster number for all transients part of CandIdx to CurrClu
        break; % no more multi-merges in case of non-mutual agreement
    end
    
    % If a merge happened, update all the cluster info for the next
    % iteration
    if ~isempty(MergeOK)
        [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,FrameList,ObjList] = UpdateClusterInfo(...
            MergeOK,PixelList,PixelAvg,BigPixelAvg,CircMask,Xcent,Ycent,FrameList,ObjList,CurrClu,BlobPixelIdxList);
        temp = UpdateCluDistances(Xcent,Ycent,CurrClu); % Update distances for newly merged clusters to all other clusters
        CluDist(CurrClu,:) = temp;
        CluDist(:,CurrClu) = temp;
        %disp(['merge, ',int2str(length(unique(Trans2ROI))),' left']);
    end
    
end

end
