function [outputArg1,outputArg2] = ReduceROIs()
close all;
load SegmentationROIs.mat;

load MovieDims.mat;
load TraceA.mat;

global T_MOVIE;

GoodROI = zeros(1,NumNeurons);

for i = 1:NumNeurons
    if(~isempty(GoodPeaks{i}))
        GoodROI(i) = 1;
    end
end

Overlaps = zeros(NumNeurons,NumNeurons);
for i = 1:NumNeurons
    for j = i+1:NumNeurons
        
        if(length(intersect(NeuronPixelIdxList{i},NeuronPixelIdxList{j})) > 50)
            Overlaps(i,j) = 1;
            Overlaps(j,i) = 1;
        end
    end
end




figure(1);set(gcf,'Position',[1 1 1920 700]);

for i = 1:NumNeurons
    if(~GoodROI(i))
        continue;
    end
    rp = regionprops(NeuronImage{i},'Centroid');
    Neighbors = find(Overlaps(i,:));
    for j = 1:length(Neighbors)
        
        if(~GoodROI(Neighbors(j)))
            continue;
        end
        
        [~,m1] = imgradient(GoodPeakAvg{Neighbors(j)});
        [~,m2] = imgradient(GoodPeakAvg{i});
        CombList = union(NeuronPixelIdxList{i},NeuronPixelIdxList{Neighbors(j)});
        phasediffs = angdiff(deg2rad(m1(CombList)),deg2rad(m2(CombList)));
        PhaseError = rad2deg(mean(abs(phasediffs)));
        if ((PhaseError >= 35) || (Neighbors(j) <= i))
            continue;
        end
        PhaseError,
        a1 = subplot(3,2,1);
        imagesc(GoodPeakAvg{i});title(int2str(i));
        axis image;hold on;caxis([0.005 max(GoodPeakAvg{i}(NeuronPixelIdxList{i}))]);colorbar
        PlotRegionOutline(NeuronImage{i},'r');
        PlotRegionOutline(NeuronImage{Neighbors(j)},'g');
        hold off;
        
        a2 = subplot(3,2,2);
        imagesc(GoodPeakAvg{Neighbors(j)});title(int2str(Neighbors(j)));
        axis image;hold on;caxis([0.005 max(GoodPeakAvg{Neighbors(j)}(NeuronPixelIdxList{Neighbors(j)}))]);colorbar
        PlotRegionOutline(NeuronImage{i},'r');
        PlotRegionOutline(NeuronImage{Neighbors(j)},'g');
        hold off;
        linkaxes([a1 a2],'xy');
        axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
        

        
        
        a3 = subplot(3,2,3:4);plot(LPtrace{i});axis tight;hold on;plot(GoodPeaks{i},LPtrace{i}(GoodPeaks{i}),'ro');hold off;
        a4 = subplot(3,2,5:6);plot(LPtrace{Neighbors(j)});axis tight;hold on;plot(GoodPeaks{Neighbors(j)},LPtrace{Neighbors(j)}(GoodPeaks{Neighbors(j)}),'ro');hold off;
        linkaxes([a3 a4],'x');
        pause;
    end
end
% the figure: top row is the two averages
% then, the two traces with the peaks highlighted

    
