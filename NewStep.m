function [] = NewStep()
% Will replace everything between MakeTransientROIs and ROImerge

load TransientROIs.mat;
global T_MOVIE;

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
MaxROIViolation = 0.2;


NumROIs = length(CircMask);
ToPlot = 0;

p = ProgressBar(NumROIs);
GoodROI = logical(ones(NumROIs,1));
FixedROI = zeros(NumROIs,1);

Trans2ROI = (1:NumROIs);

for i = 1:NumROIs
    NumPixels = length(CircMask{i});
    FrameLength = length(FrameList{i});
    TempTrace = zeros(NumPixels,FrameLength);
    
    % average the movie for the pixels in CircMask for the Frames in
    % FrameList
    for j = 1:NumPixels
        TempTrace(j,:) = CalcROITrace(CircMask{i}(j),FrameList{i});
    end
    
    BigPixelAvg{i} = mean(TempTrace,2);
    
    PixelIdxList{i} = RecalcROI_Corr(PixelIdxList{i},CircMask{i},BigPixelAvg{i});
    
    % calculate the correlation between the trace for this ROI and the pixels in CircMask
    [ROIcorrR{i},ROIcorrP{i}] = TraceCorrelationMap(PixelIdxList{i},CircMask{i},FrameList{i});
    ROIcorrSig{i} = ROIcorrR{i}.*(ROIcorrP{i} < 0.01);
    
    % Find the pixels that are highly, significantly correlated
    CorrBlobIdx{i} = MakeCorrBlob(PixelIdxList{i},CircMask{i},ROIcorrSig{i});
    [~,OutsideIdx] = setdiff(CircMask{i},CorrBlobIdx{i});
    CorrIsolation(i) = 1 - sum(BigPixelAvg{i}(OutsideIdx) > 0.05)/length(OutsideIdx);
    
    % Now, decide if we keep it or trash it
    BadPixels = setdiff(PixelIdxList{i},CorrBlobIdx{i}); % pixels in the ROI that aren't well correlated with the trace
    if (length(BadPixels) > MaxROIViolation*length(PixelIdxList{i}))
        
        GoodROI(i) = 0;
    else
        if (~isempty(BadPixels))
            PixelIdxList{i} = setdiff(PixelIdxList{i},BadPixels);
            % Redo the correlation
            [ROIcorrR{i},ROIcorrP{i}] = TraceCorrelationMap(PixelIdxList{i},CircMask{i},FrameList{i});
            ROIcorrSig{i} = ROIcorrR{i}.*(ROIcorrP{i} < 0.01);
            [CorrBlobIdx{i}] = MakeCorrBlob(PixelIdxList{i},CircMask{i},ROIcorrSig{i});
            [~,OutsideIdx] = setdiff(CircMask{i},CorrBlobIdx{i});
            CorrIsolation(i) = 1 - sum(BigPixelAvg{i}(OutsideIdx) > 0.05)/length(OutsideIdx);
            FixedROI(i) = 1;
        end
    end
    
    [~,loc] = ismember(PixelIdxList{i},CircMask{i});    
    [~,Peak] = max(BigPixelAvg{i}(loc));
    PeakIdx(i) = PixelIdxList{i}(Peak);
    [Xcent(i) Ycent(i)] = ind2sub([Xdim Ydim],PixelIdxList{i}(Peak));
    
    if (ToPlot)
        figure(1);
        temp = zeros(Xdim,Ydim);
        temp(CircMask{i}) = BigPixelAvg{i};
        
        
        
        subplot(1,2,1);hold on;
        imagesc(temp);set(gca,'YDir','normal');
        PlotRegionOutline(PixelIdxList{i},'r');
        
        PlotRegionOutline(CorrBlobIdx{i},'m');
        axis([Ycent(i)-20 Ycent(i)+20 Xcent(i)-20 Xcent(i)+20]);
        caxis([-0.01 1.1*temp(ceil(Xcent(i)),ceil(Ycent(i)))]);colorbar;
        title(['isolation factor = ',num2str(CorrIsolation(i))]);
        hold off;
        
        subplot(1,2,2);hold on;
        temp(CircMask{i}) = ROIcorrSig{i};
        imagesc(temp);set(gca,'YDir','normal');
        PlotRegionOutline(PixelIdxList{i},'r');
        
        PlotRegionOutline(CorrBlobIdx{i},'m');
        axis([Ycent(i)-20 Ycent(i)+20 Xcent(i)-20 Xcent(i)+20]);
        caxis([0 1]);colorbar;
        StatusText = [];
        if (FixedROI(i))
            StatusText = ', Fixed';
        end
        if (~GoodROI(i))
            StatusText = ',Trashed';
        end
        
        title([int2str(FrameLength),' frames in ROI',StatusText]);
        
        hold off;
        pause;
    end
    p.progress;
end
p.stop;
BigPixelAvg = BigPixelAvg(GoodROI);
CircMask = CircMask(GoodROI);
FrameList = FrameList(GoodROI);
ObjList = ObjList(GoodROI);
PixelIdxList = PixelIdxList(GoodROI);
ROIcorrP = ROIcorrP(GoodROI);
ROIcorrR = ROIcorrR(GoodROI);
ROIcorrSig = ROIcorrSig(GoodROI);
Trans2ROI = Trans2ROI(GoodROI);
Xcent = Xcent(GoodROI);
Ycent = Ycent(GoodROI);
PeakIdx = PeakIdx(GoodROI);
CorrBlobIdx = CorrBlobIdx(GoodROI);
CorrIsolation = CorrIsolation(GoodROI);


display('Calculating Overlaps');
Overlaps = CalcOverlaps(PixelIdxList);

save EvenBetterROIs.mat BigPixelAvg CircMask FrameList ObjList PixelIdxList ROIcorrP ROIcorrR ROIcorrSig Trans2ROI Xcent Ycent PeakIdx CorrBlobIdx CorrIsolation Overlaps;


