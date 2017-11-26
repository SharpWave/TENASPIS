function [outputArg1,outputArg2] = TraceAnalysis()

close all;
load SegmentationROIs.mat;

load MovieDims.mat;
global T_MOVIE;

p = ProgressBar(NumNeurons);

for i = 1:NumNeurons
    [xidx,yidx] = ind2sub([Xdim Ydim],NeuronPixelIdxList{i});
    LPtrace{i} = mean(T_MOVIE(xidx,yidx,1:NumFrames),1);
    
    LPtrace{i} = squeeze(mean(LPtrace{i}));
    LPtrace{i} = convtrim(LPtrace{i},ones(10,1)/10);
    
    a = find(NeuronActivity(i,:));
    [~,b] = findpeaks(LPtrace{i},'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
    
    segframe = zeros(Xdim,Ydim);
    segframe(NeuronPixelIdxList{i}) = NeuronAvg{i};
    
    MaxError = 25;
    
    GoodPeakAvg{i} = zeros(Xdim,Ydim,'single');
    GoodPeak = zeros(1,length(b));
    
    [a2,xOff2,yOff2] = BoxGradient(NeuronPixelIdxList{i},NeuronAvg{i},Xdim,Ydim);
    [cx,cy] = ind2sub([Xdim Ydim],NeuronPixelIdxList{i});
    cx2 = cx-xOff2+1;
    cy2 = cy-yOff2+1;
    BoxCombPixIdx2 = sub2ind(size(a2),cx2,cy2);
    
    for j = 1:length(b)
        
        mv = mean(T_MOVIE(:,:,b(j)-2:b(j)+2),3);
        [a1,xOff1,yOff1] = BoxGradient(NeuronPixelIdxList{i},mv(NeuronPixelIdxList{i}),Xdim,Ydim);
        
        % Left shift indices for a1's coordinates
        cx1 = cx-xOff1+1;
        cy1 = cy-yOff1+1;
        BoxCombPixIdx1 = sub2ind(size(a1),cx1,cy1);
        
        phasediffs = angdiff(deg2rad(a1(BoxCombPixIdx1)),deg2rad(a2(BoxCombPixIdx2)));
        PhaseError = rad2deg(mean(abs(phasediffs)));
        
        if (PhaseError <= MaxError)
            GoodPeak(j) = 1;
            GoodPeakAvg{i} = GoodPeakAvg{i} + mv;
        end
    end
    GoodPeakAvg{i} = GoodPeakAvg{i}./sum(GoodPeak);
    GoodPeaks{i} = b(find(GoodPeak));
    imagesc(GoodPeakAvg{i});
    hold on
    PlotRegionOutline(NeuronImage{i},'r');axis image;hold off;
    caxis([0.01 max(GoodPeakAvg{i}(NeuronPixelIdxList{i}))]);
    rp = regionprops(NeuronImage{i},'Centroid');
    axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);pause;
    p.progress;
end
p.stop;
save TraceA.mat GoodPeakAvg GoodPeaks LPtrace -v7.3
keyboard;

