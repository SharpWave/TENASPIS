function [] = ROImerge(inputArg1,inputArg2)

% merge ROIs in a smart way

load('EvenBetterROIs.mat');
% loads variables: BigPixelAvg CircMask FrameList ObjList PixelAvg PixelIdxList ROIcorrP ROIcorrR Trans2ROI Xcent Ycent CorrBlobIdx CorrIsolation Overlaps;
NumROIs = length(CircMask);
threshlist = prctile(CorrIsolation,[90 80 70 60 50 40 30 20 10 0]);
WasDeleted = zeros(1,NumROIs);


for i = 1:length(threshlist)
    threshold = threshlist(i);
    first = 1;
    NumMerged = 0;
    while(NumMerged > 0 | first == 1)
        PairsToMerge = [];
        first = 0;
        
        EligibleROIs = find((CorrIsolation > threshold) & ~WasDeleted);
        display([int2str(length(EligibleROIs)),' eligible for merge at threshold: ',num2str(threshold)]);
        
        % Go down the list of eligible ROIs.  On each iteration of this
        % while loop, an ROI can participate in at most one merge with
        % another ROI. Thus each iteration finds a set of pairs to merge.
        % When merging, the ROI with the lower index accepts the new stats,
        %  and the WasDeleted bit is set for the higher index.
        % Because merges don't happen until the end of the while loop, and
        % the test for merging is symmetric, we proceed over the Overlap
        % matrix in a triangle fashion
        
        WasMerged = zeros(1,NumROIs);
        
        for m = 1:length(EligibleROIs)
            CurrROI = EligibleROIs(m);
            if (WasMerged(CurrROI))
                continue;
            end
            
            OverlapList = find(Overlaps(CurrROI,:));
            
            ROIsToTry = intersect(EligibleROIs,OverlapList);
            ROIsToTry = ROIsToTry(~WasMerged);
            ROIsToTry = ROIsToTry(ROIsToTry > CurrROI);
            MatchFound = 0;
            
            for n = 1:length(ROIsToTry)
                TargetROI = ROIsToTry(n);
                
                % if target's ROI fits in Curr's corrblob, or if Curr's
                % ROI fits in target's corrblob, it's a match
                if(length(intersect(PixelIdxList{TargetROI},CorrBlobIdx{CurrROI})) == length(PixelIdxList{TargetROI}))                    
                    MatchFound = 1;
                    break;
                end
                
                if(length(intersect(PixelIdxList{CurrROI},CorrBlobIdx{TargetROI})) == length(PixelIdxList{CurrROI}))                    
                    MatchFound = 1;
                    break;
                end
                
                
            end
            
            if (MatchFound)
                PairsToMerge = [PairsToMerge;[CurrROI TargetROI]];
                WasMerged(CurrROI) = 1;
                WasMerged(TargetROI) = 1;
                WasDeleted(TargetROI) = 1;
                NumMerged = NumMerged + 1;
            end
        end
        
        % do the heavy lifting for the merges
        for j = 1:size(PairsToMerge,1)
            CurrROI = PairsToMerge(j,1);
            TargetROI = PairsToMerge(j,2);
            
            % Merge FrameLists
            
            % Merge Object Lists
            
            % Update Trans2ROI (mapping from previous step into final ROI
            
            % Recalculate the ROI
            
            % Recalculate the centroids
            
            % Recalculate CircWindow and BigPixelAvg
            
            % Recalculate the correlation map           
            
        end
        % Recalculate the overlaps
