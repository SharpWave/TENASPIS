function [] = BrowseEditedOverlapsCorr()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load ROImerge.mat;

NumROIs = length(CircMask);
figure(1);
CorrThresh = sqrt(0.75);

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

for i = 1:NumROIs
    OverlapList = find(Overlaps(i,:));
    
    
    
    
    
    
    for j = 1:length(OverlapList)
        TargetROI = OverlapList(j);
        t = TargetROI;
        CurrROI = i;
        
        % now calculate what it would look like if we merged the two
        [NewFrameList,NewObjList,Trans2ROI,NewXcent,NewYcent,NewCircMask,NewPixelIdxList,NewBigPixelAvg,NewROIcorrR,NewROIcorrP,NewROIcorrSig,NewCorrBlobIdx,NewCorrIsolation] = ...
            MergeEm(CurrROI,TargetROI,FrameList,ObjList,Trans2ROI,Xcent,Ycent,CircMask,PixelIdxList,BigPixelAvg,ROIcorrR,ROIcorrP,ROIcorrSig,CorrBlobIdx,CorrIsolation);
        
        subplot(2,3,1);hold on; % ROI i brightness
        a = zeros(Xdim,Ydim);
        a(CircMask{i}) = BigPixelAvg{i};
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([0 max(BigPixelAvg{i})]);
        colorbar;
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        PlotRegionOutline(PixelIdxList{t},'b');
        PlotRegionOutline(CorrBlobIdx{t},'c');
        MinCorrBlob = min(length(CorrBlobIdx{i}),length(CorrBlobIdx{t}));
        
        title(['similarity of smaller corr blob: ',num2str(length(intersect(CorrBlobIdx{i},CorrBlobIdx{t}))/MinCorrBlob)]);
        hold off;
        
        subplot(2,3,4);hold on;
        a(CircMask{i}) = ROIcorrSig{i};
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([0 1]);colorbar;
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        PlotRegionOutline(PixelIdxList{t},'b');
        PlotRegionOutline(CorrBlobIdx{t},'c');hold off;
        title(['NumFrames: ',int2str(length(FrameList{i}))]);

        
        subplot(2,3,2);hold on; % ROI i brightness
        a = zeros(Xdim,Ydim);
        a(CircMask{t}) = BigPixelAvg{t};
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([0 max(BigPixelAvg{t})]);
        colorbar;
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        PlotRegionOutline(PixelIdxList{t},'b');
        PlotRegionOutline(CorrBlobIdx{t},'c');hold off;
        MinROI = min(length(PixelIdxList{i}),length(PixelIdxList{t}));
        title(['similarity of smaller ROI: ',num2str(length(intersect(PixelIdxList{i},PixelIdxList{t}))/MinROI)]);
        
        subplot(2,3,5);hold on;
        a(CircMask{t}) = ROIcorrSig{t};
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([0 1]);colorbar;
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        PlotRegionOutline(PixelIdxList{t},'b');
        PlotRegionOutline(CorrBlobIdx{t},'c');hold off;
        title(['NumFrames: ',int2str(length(FrameList{t}))]);
        
        subplot(2,3,6);hold on;
        a = zeros(Xdim,Ydim);
        a(NewCircMask) = NewROIcorrSig;
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([0 1]);colorbar;
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        PlotRegionOutline(PixelIdxList{t},'b');
        PlotRegionOutline(CorrBlobIdx{t},'c');
        PlotRegionOutline(NewPixelIdxList,[0.6 0.6 0.6]);
        PlotRegionOutline(NewCorrBlobIdx,'k')
        hold off;
        
        subplot(2,3,3);hold on;
        a = zeros(Xdim,Ydim);
        a(NewCircMask) = NewBigPixelAvg;
        imagesc(a);
        axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
        caxis([0 max(NewBigPixelAvg)]);
        colorbar;
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        PlotRegionOutline(PixelIdxList{t},'b');
        PlotRegionOutline(CorrBlobIdx{t},'c');
        PlotRegionOutline(NewPixelIdxList,[0.6 0.6 0.6]);
        PlotRegionOutline(NewCorrBlobIdx,'k');hold off;
        Dist = sqrt((Xcent(i)-Xcent(t)).^2+(Ycent(i)-Ycent(t)).^2);
        title(['peak distance (pixels): ',num2str(Dist)]);
        
        GoodKey = false;
        while(~GoodKey)
            w = waitforbuttonpress;
            
            buttonpressed = get(gcf,'CurrentKey');
            if(strcmp(buttonpressed,'leftarrow'))
                MergeAssessment{i}(t) = 0;
                GoodKey = true;
            end
            if(strcmp(buttonpressed,'rightarrow'))
                MergeAssessment{i}(t) = 1;
                GoodKey = true;
            end
        end
        save MergeAssessment.mat MergeAssessment i t;
    end
    
    
end

