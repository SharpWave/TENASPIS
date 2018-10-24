function [] = MakeLocalTransientCorrelations()

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
% New approach based on correlation structures
load UngarbagedROIs.mat;

global T_MOVIE;

NumROIs = length(PixelAvg);
convwin = ones(1,2)/2;

display('making correlations between ROI traces and pixels in their neighborhood');
p = ProgressBar(NumROIs);
for i = 1:NumROIs
    t1 = FrameList{i}(1);
    t2 = FrameList{i}(end);
    c1 = squeeze(T_MOVIE(Ycent(i),Xcent(i),t1:t2));
    [ROIcorrR{i} ROIcorrP{i}]= TraceCorrelationMap(PixelIdxList{i},CircMask{i},t1:t2);
    p.progress;
end
p.stop;

% for i = 1:NumROIs
%     corrmap = zeros(Xdim,Ydim);
%     
%     
%     for j = 1:length(ROIcorr{i})
%         [xp,yp] = ind2sub([Xdim Ydim],CircMask{i}(j));
%         corrmap(xp,yp) = ROIcorr{i}(j);        
%     end
%     
%     figure(1);
%     imagesc(corrmap);hold on;
%     PlotRegionOutline(PixelIdxList{i});
%     axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
%     caxis([0 1]);
%     pause;
%     caxis([.866 1]);
%     pause;
%     close(1);
% end

save ROIcorr.mat ROIcorrR ROIcorrP;

end

