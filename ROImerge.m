function [] = ROImerge(ToPlot)

% merge ROIs in a smart way

load('EvenBetterROIs.mat');
% loads variables: BigPixelAvg CircMask FrameList ObjList PixelAvg PixelIdxList ROIcorrP ROIcorrR Trans2ROI Xcent Ycent CorrBlobIdx CorrIsolation Overlaps;
NumROIs = length(CircMask);
threshlist = prctile(CorrIsolation,96:-8:0);
WasDeleted = zeros(1,NumROIs);

[Xdim,Ydim,NumFrames,ROICircleWindowRadius] = Get_T_Params('Xdim','Ydim','NumFrames','ROICircleWindowRadius');

for i = 1:length(threshlist)
    
    first = 1;
    NumMerged = 0;
    while(NumMerged > 0 || first == 1)
        threshlist = prctile(CorrIsolation(find(~WasDeleted)),96:-8:0);
        threshold = threshlist(i);
        NumMerged = 0;
        PairsToMerge = [];
        first = 0;
        
        EligibleROIs = find((CorrIsolation > threshold) & ~WasDeleted);
        display([int2str(length(EligibleROIs)),' out of ',int2str(sum(~WasDeleted)),' ROIs eligible for merge at threshold: ',num2str(threshold)]);
        
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
            CurrCent = sub2ind([Xdim Ydim],Ycent(CurrROI),Xcent(CurrROI));
            
            if (WasMerged(CurrROI))
                continue;
            end
            
            OverlapList = find(Overlaps(CurrROI,:));
            
            ROIsToTry = intersect(EligibleROIs,OverlapList);
            ROIsToTry = intersect(ROIsToTry,find(~WasMerged));
            ROIsToTry = ROIsToTry(ROIsToTry > CurrROI);
            MatchFound = 0;
            
            RTTOverlaps = Overlaps(CurrROI,ROIsToTry);
            [~,idx] = sort(RTTOverlaps,'descend');
            ROIsToTry = ROIsToTry(idx);
            
            for n = 1:length(ROIsToTry)
                TargetROI = ROIsToTry(n);
                TargetCent = sub2ind([Xdim Ydim],Ycent(TargetROI),Xcent(TargetROI));
                
                % if target's ROI fits in Curr's corrblob, or if Curr's
                % ROI fits in target's corrblob, it's a match
                Dist = sqrt((Xcent(CurrROI)-Xcent(TargetROI)).^2+(Ycent(CurrROI)-Ycent(TargetROI)).^2);
                
                
                if ((Dist < 10) && ismember(CurrCent,PixelIdxList{TargetROI}) ...
                        && ismember(TargetCent,PixelIdxList{CurrROI}) ...
                        && ((length(intersect(PixelIdxList{TargetROI},CorrBlobIdx{CurrROI})) == length(PixelIdxList{TargetROI})) ...
                        && (length(intersect(PixelIdxList{CurrROI},CorrBlobIdx{TargetROI})) == length(PixelIdxList{CurrROI}))))
                        MatchFound = 1;
                end

                
                if (sum(~WasDeleted) < 2500) %& threshold < 0.8
              
                    % plot shit for the current ROI
                    figure(1);
                    subplot(2,2,1);hold on; % ROI i brightness
                    a = zeros(Xdim,Ydim);
                    a(CircMask{CurrROI}) = BigPixelAvg{CurrROI};
                    imagesc(a);
                    axis([Xcent(CurrROI)-25 Xcent(CurrROI)+25 Ycent(CurrROI)-25 Ycent(CurrROI)+25]);
                    caxis([0 max(PixelAvg{CurrROI})]);colorbar;
                    PlotRegionOutline(PixelIdxList{CurrROI},[1 0 0]);
                    PlotRegionOutline(CorrBlobIdx{CurrROI},[0.75 0 0]);
                    PlotRegionOutline(PixelIdxList{TargetROI},[0 0 1]);
                    PlotRegionOutline(CorrBlobIdx{TargetROI},[0 0 .75]);hold off;
                    title(['Match found: ',int2str(MatchFound)]);
                    
                    subplot(2,2,3);hold on;
                    a(CircMask{CurrROI}) = ROIcorrR{CurrROI};
                    imagesc(a.^2);
                    axis([Xcent(CurrROI)-25 Xcent(CurrROI)+25 Ycent(CurrROI)-25 Ycent(CurrROI)+25]);
                    caxis([0 1]);colorbar;
                    PlotRegionOutline(PixelIdxList{CurrROI},[1 0 0]);
                    PlotRegionOutline(CorrBlobIdx{CurrROI},[0.75 0 0]);
                    PlotRegionOutline(PixelIdxList{TargetROI},[0 0 1]);
                    PlotRegionOutline(CorrBlobIdx{TargetROI},[0 0 .75]);hold off;
                    
                    subplot(2,2,2);hold on; % ROI i brightness
                    a = zeros(Xdim,Ydim);
                    a(CircMask{TargetROI}) = BigPixelAvg{TargetROI};
                    imagesc(a);
                    axis([Xcent(CurrROI)-25 Xcent(CurrROI)+25 Ycent(CurrROI)-25 Ycent(CurrROI)+25]);
                    caxis([0 max(PixelAvg{TargetROI})]);colorbar;
                    PlotRegionOutline(PixelIdxList{CurrROI},[1 0 0]);
                    PlotRegionOutline(CorrBlobIdx{CurrROI},[0.75 0 0]);
                    PlotRegionOutline(PixelIdxList{TargetROI},[0 0 1]);
                    PlotRegionOutline(CorrBlobIdx{TargetROI},[0 0 .75]);hold off;
                    
                    subplot(2,2,4);hold on;
                    a(CircMask{TargetROI}) = ROIcorrR{TargetROI};
                    imagesc(a.^2);
                    axis([Xcent(CurrROI)-25 Xcent(CurrROI)+25 Ycent(CurrROI)-25 Ycent(CurrROI)+25]);
                    caxis([0 1]);colorbar;
                    PlotRegionOutline(PixelIdxList{CurrROI},[1 0 0]);
                    PlotRegionOutline(CorrBlobIdx{CurrROI},[0.75 0 0]);
                    PlotRegionOutline(PixelIdxList{TargetROI},[0 0 1]);
                    PlotRegionOutline(CorrBlobIdx{TargetROI},[0 0 .75]);hold off;
                    pause;
                end
                if (MatchFound)
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
        display(['merging ',int2str(size(PairsToMerge,1)),' ROI pairs']);
        
        for j = 1:size(PairsToMerge,1)
            CurrROI = PairsToMerge(j,1);
            TargetROI = PairsToMerge(j,2);
            
            
            
            
            % Merge FrameLists
            FrameList{CurrROI} = [FrameList{CurrROI} FrameList{TargetROI}];
            
            % Merge Object Lists
            ObjList{CurrROI} = [ObjList{CurrROI} ObjList{TargetROI}];
            
            % Update Trans2ROI (mapping from previous step into final ROI
            Trans2ROI(TargetROI) = CurrROI;
            
            % Recalculate the centroids (average the x and y)
            Xcent(CurrROI) = (Xcent(CurrROI) + Xcent(TargetROI))/2;
            Ycent(CurrROI) = (Ycent(CurrROI) + Ycent(TargetROI))/2;
            
            % Recalculate CircMask
            CircMask{CurrROI} = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,Xcent(CurrROI),Ycent(CurrROI));
            
            % Recalc BigPixelAvg
            NumPixels = length(CircMask{CurrROI});
            TempTrace = zeros(NumPixels,length(FrameList{CurrROI}),'single');
            
            for k = 1:NumPixels
                TempTrace(k,:) = CalcROITrace(CircMask{CurrROI}(k),FrameList{CurrROI});
            end
            
            BigPixelAvg{CurrROI} = mean(TempTrace,2);
            
            % Recalculate the ROI
            %try
            [PixelIdxList{CurrROI},PixelAvg{CurrROI}] = RecalcROI_Corr(union(PixelIdxList{CurrROI},PixelIdxList{TargetROI}),CircMask{CurrROI},BigPixelAvg{CurrROI});
            %             catch
            %                 keyboard;
            %             end
            
            [~,idx] = max(PixelAvg{CurrROI});
            MaxPixel = PixelIdxList{CurrROI}(idx);
            [Ycent(CurrROI),Xcent(CurrROI)] = ind2sub([Xdim Ydim],MaxPixel);
            
            
            
            % Recalculate the correlation map
            
            [ROIcorrR{CurrROI},ROIcorrP{CurrROI}] = TraceCorrelationMap(PixelIdxList{CurrROI},CircMask{CurrROI},FrameList{CurrROI});
            ROIcorrR{CurrROI} = ROIcorrR{CurrROI}.*(ROIcorrP{CurrROI} < 0.01);
            
            % Recalculate the correlation blob
            [CorrBlobIdx{CurrROI},CorrIsolation(CurrROI)] = MakeCorrBlob(PixelIdxList{CurrROI},CircMask{CurrROI},ROIcorrR{CurrROI});
            
            % Readjust the ROI
            PixelIdxList{CurrROI} = intersect(PixelIdxList{CurrROI},CorrBlobIdx{CurrROI});
            
            if (ToPlot)
                figure(1);
                subplot(2,3,3);hold on; % ROI i brightness
                a = zeros(Xdim,Ydim);
                a(CircMask{CurrROI}) = BigPixelAvg{CurrROI};
                imagesc(a);
                axis([Xcent(CurrROI)-25 Xcent(CurrROI)+25 Ycent(CurrROI)-25 Ycent(CurrROI)+25]);
                caxis([0 max(PixelAvg{CurrROI})]);colorbar;
                PlotRegionOutline(PixelIdxList{CurrROI},[0 1 0]);
                PlotRegionOutline(CorrBlobIdx{CurrROI},[0 0.75 0]);hold off;
                
                subplot(2,3,6);hold on;
                a(CircMask{CurrROI}) = ROIcorrR{CurrROI};
                imagesc(a);
                axis([Xcent(CurrROI)-25 Xcent(CurrROI)+25 Ycent(CurrROI)-25 Ycent(CurrROI)+25]);
                caxis([-1 1]);colorbar;
                PlotRegionOutline(PixelIdxList{CurrROI},[0 1 0]);
                PlotRegionOutline(CorrBlobIdx{CurrROI},[0 0.75 0]);hold off;
                pause
            end
            
        end
        % Recalculate the overlaps
        display('recalculating overlaps');
        OverlapsToFix = find(WasMerged & ~WasDeleted);
        for j = 1:length(OverlapsToFix)
            Curr = OverlapsToFix(j);
            TargetsToFix = find(~WasDeleted);
            for k = 1:length(TargetsToFix)
                Dist = sqrt((Xcent(Curr)-Xcent(TargetsToFix(k))).^2+(Ycent(Curr)-Ycent(TargetsToFix(k))).^2);
                if (Dist > 25)
                    continue;
                end
                Overlaps(Curr,TargetsToFix(k)) = length(intersect(PixelIdxList{Curr},PixelIdxList{TargetsToFix(k)}));
                Overlaps(TargetsToFix(k),Curr) = Overlaps(Curr,TargetsToFix(k));
            end
        end
    end
end
save ROImerge.mat;
