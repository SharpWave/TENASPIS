function [] = MakeLocalTransientCorrelations()

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
% New approach based on correlation structures
load UngarbagedROIs.mat;

global T_MOVIE;

NumROIs = length(PixelAvg);
convwin = ones(1,2)/2;

for i = 1:225
    t1 = FrameList{i}(1);
    t2 = FrameList{i}(end);
    c1 = squeeze(T_MOVIE(Ycent(i),Xcent(i),t1:t2));
    ROIcorr{i} = TraceCorrelationMap(PixelIdxList{i},CircMask{i},t1:t2);   
end


for i = 1:225
    corrmap = zeros(Xdim,Ydim);
    
    
    for j = 1:length(ROIcorr{i})
        [xp,yp] = ind2sub([Xdim Ydim],CircMask{i}(j));
        corrmap(xp,yp) = ROIcorr{i}(j);        
    end
    
    figure(1);
    imagesc(corrmap);hold on;
    PlotRegionOutline(PixelIdxList{i});
    axis([Xcent(i)-25 Xcent(i)+25 Ycent(i)-25 Ycent(i)+25]);
    caxis([0 1]);
    pause;
    caxis([.866 1]);
    pause;
    close(1);
end

save corrmap.mat ROIcorr;

end

