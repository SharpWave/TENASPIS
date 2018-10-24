function [] = NewStep()
% Will replace everything between MakeTransientROIs and ROImerge

load TransientROIs.mat;
global T_MOVIE;

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
NumROIs = length(CircMask);
ToPlot = 1;
for i = 1:NumROIs
    NumPixels = length(CircMask{i});
    FrameLength = length(FrameList{i});
    TempTrace = zeros(NumPixels,FrameLength);
    
    for j = 1:NumPixels
        TempTrace(j,:) = CalcROITrace(CircMask{i}(j),FrameList{i});
    end
    
    BigPixelAvg{i} = mean(TempTrace,2);
    
    [ROIcorrR{i},ROIcorrP{i}] = TraceCorrelationMap(PixelIdxList{i},CircMask{i},FrameList{i});
    ROIcorrSig{i} = ROIcorrR{i}.*(ROIcorrP{i} < 0.01);
    
    % Recalculate the correlation blob
    [CorrBlobIdx{i},CorrIsolation(i)] = MakeCorrBlob(PixelIdxList{i},CircMask{i},ROIcorrSig{i});
    
    
    if (ToPlot)
        figure(1);
        temp = zeros(Xdim,Ydim);
        temp(CircMask{i}) = BigPixelAvg{i};
        
        [NewPixelIdxList{i},PixelAvg{i}] = RecalcROI_Corr(PixelIdxList{i},CircMask{i},BigPixelAvg{i});
        
        subplot(1,2,1);hold on;
        imagesc(temp);set(gca,'YDir','normal');
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(PixelIdxList{i},'k');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        axis([Ycent(i)-25 Ycent(i)+25 Xcent(i)-25 Xcent(i)+25]);
        caxis([-0.01 1.1*temp(ceil(Xcent(i)),ceil(Ycent(i)))]);colorbar;
        title(['isolation factor = ',num2str(CorrIsolation(i))]);
        hold off;
        
        subplot(1,2,2);hold on;
        temp(CircMask{i}) = ROIcorrR{i};
        imagesc(temp);set(gca,'YDir','normal');
        PlotRegionOutline(PixelIdxList{i},'r');
        PlotRegionOutline(PixelIdxList{i},'k');
        PlotRegionOutline(CorrBlobIdx{i},'m');
        axis([Ycent(i)-25 Ycent(i)+25 Xcent(i)-25 Xcent(i)+25]);
        caxis([-1 1]);
        title([int2str(FrameLength),' frames in ROI']);
        hold off;
        pause;
    end
end


