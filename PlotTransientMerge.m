function [] = PlotTransientMerge(CurrBigPixelAvg,CandBigPixelAvg,idx1,idx2,CircMaskCurr,CircMaskCand,CurrPixelIdx,CandPixelIdx,Trans2ROI,CurrClu,CandIdx)

% Plot the BigPixelAvg for both. with colorbar, # frames on top. Plot The ROI for both as a line.
% Plot the points in the union as a scatter

[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');

blankframe = zeros(Xdim,Ydim,'single');

figure(1);

s(1) = subplot(1,3,1);
tempframeCurr = blankframe;
tempframeCurr(CircMaskCurr) = CurrBigPixelAvg;
MaxVal = max(tempframeCurr(CurrPixelIdx));
imagesc(tempframeCurr);axis image;caxis([0.01 MaxVal]);hold on;colorbar;
title(['# transients',int2str(length(find(Trans2ROI == CurrClu)))])
tempframeOL = blankframe;
tempframeOL(CurrPixelIdx) = 1;
b1 = bwboundaries(tempframeOL);
plot(b1{1}(:,2),b1{1}(:,1),'-r','LineWidth',1);

s(2) = subplot(1,3,2);
tempframeCand = blankframe;
tempframeCand(CircMaskCand) = CandBigPixelAvg;
MaxVal = max(tempframeCand(CandPixelIdx));
imagesc(tempframeCand);axis image;caxis([0.01 MaxVal]);hold on;colorbar;
title(['# transients',int2str(length(find(Trans2ROI == CandIdx)))])
tempframeOL = blankframe;
tempframeOL(CandPixelIdx) = 1;
b2 = bwboundaries(tempframeOL);
plot(b2{1}(:,2),b2{1}(:,1),'-r','LineWidth',1);
plot(b1{1}(:,2),b1{1}(:,1),'-m','LineWidth',1);hold off;

subplot(1,3,1);
plot(b2{1}(:,2),b2{1}(:,1),'-m','LineWidth',1);hold off;

subplot(1,3,3);
plot(CurrBigPixelAvg(idx1),CandBigPixelAvg(idx2),'*');axis square;
[cr,cp] = corr(CurrBigPixelAvg(idx1),CandBigPixelAvg(idx2),'type','Spearman');
title(['Corr R: ',num2str(cr),' Corr P: ',num2str(cp)]);

linkaxes(s);
pause

end

