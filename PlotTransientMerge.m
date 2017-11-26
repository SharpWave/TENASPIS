function [] = PlotTransientMerge(CurrBigPixelAvg,CandBigPixelAvg,idx1,idx2,CircMaskCurr,CircMaskCand,CurrPixelIdx,CandPixelIdx,Trans2ROI,CurrClu,CandIdx,a1,a2,CombPixIdx,BoxCombPixIdx1,BoxCombPixIdx2)

% Plot the BigPixelAvg for both. with colorbar, # frames on top. Plot The ROI for both as a line.
% Plot the points in the union as a scatter

[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');

blankframe = zeros(Xdim,Ydim,'single');

figure(1);

s(1) = subplot(2,3,1);
tempframeCurr = blankframe;
tempframeCurr(CircMaskCurr) = CurrBigPixelAvg;
MaxVal = max(tempframeCurr(CurrPixelIdx));
imagesc(tempframeCurr);axis image;caxis([0.01 MaxVal]);hold on;colorbar;
title(['# transients',int2str(length(find(Trans2ROI == CurrClu)))])
tempframeOL = blankframe;
tempframeOL(CurrPixelIdx) = 1;
b1 = bwboundaries(tempframeOL);
plot(b1{1}(:,2),b1{1}(:,1),'-r','LineWidth',1);

s(2) = subplot(2,3,2);
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
[xs,ys] = ind2sub([Xdim Ydim],CurrPixelIdx);

axis([median(ys)-20 median(ys)+20 median(xs)-20 median(xs)+20]);

s(1) = subplot(2,3,1);
plot(b2{1}(:,2),b2{1}(:,1),'-m','LineWidth',1);

subplot(2,3,3);
plot(CurrBigPixelAvg(idx1),CandBigPixelAvg(idx2),'*');axis square;
[cr,cp] = corr(CurrBigPixelAvg(idx1),CandBigPixelAvg(idx2),'type','Spearman');
title(['Corr R: ',num2str(cr),' Corr P: ',num2str(cp)]);

subplot(2,3,6),plot(wrapTo360(a1(BoxCombPixIdx1)),wrapTo360(a2(BoxCombPixIdx2)),'*');axis equal;axis([0 360 0 360]);
[circ_rVal,circ_pVal] = circ_corrcc(deg2rad(a1(BoxCombPixIdx1)),deg2rad(a2(BoxCombPixIdx2)));
title(['Corr R: ',num2str(circ_rVal),' Corr P: ',num2str(circ_pVal)]);

aa2 = zeros(size(a2));
aa2(BoxCombPixIdx2) = a2(BoxCombPixIdx2);

aa1 = zeros(size(a1));
aa1(BoxCombPixIdx1) = a1(BoxCombPixIdx2);

 subplot(2,3,5);imagesc(rad2deg(aa2));axis image;colorbar;hold off;

 subplot(2,3,4);imagesc(rad2deg(aa1));axis image;colorbar;hold off;

linkaxes(s);


end

