function [] = PlotTransientMerge(CurrPixelAvg,CandPixelAvg,CurrBigPixelAvg,CandBigPixelAvg,)
% helper plotter for AttemptTransientMerges

figure(1);

lf1 = length(frames{i});
lf2 = length(frames{cidx});

subh(4) = subplot(2,4,5);
temp = zeros(Xdim,Ydim);
temp(cm{i}) = BigPixelAvg{i};
imagesc(temp);axis image;caxis([0.01 max(PixelAvg{i})]);

subh(5) = subplot(2,4,6);
temp1 = zeros(Xdim,Ydim);
temp1(cm{cidx}) = BigPixelAvg{cidx};
imagesc(temp1);axis image;caxis([0.01 max(PixelAvg{cidx})]);

subh(6) = subplot(2,4,7);
imsum = (temp1*lf2+temp*lf1)./(lf1+lf2);
imagesc(imsum);axis image;caxis([0.01 max(imsum(:))]);

subplot(2,4,8);
plot(BigPixelAvg{i}(idx1),BigPixelAvg{cidx}(idx2),'*');axis equal;



corrp,corrval,Bigcorrval,Bigcorrp,linkaxes(subh);
pause


end

