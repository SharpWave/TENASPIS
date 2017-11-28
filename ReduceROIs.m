function [] = ReduceROIs()
close all;

load MovieDims.mat;
load ('TraceA.mat','GoodPeakAvg','GoodPeaks','LPtrace','PixelIdxList');

global T_MOVIE;
ToPlot = 0;
NumNeurons = length(PixelIdxList);

GoodROI = zeros(1,NumNeurons);

for i = 1:NumNeurons
    if(~isempty(GoodPeaks{i}))
        GoodROI(i) = 1;
    end
end

% kill anything eliminated this way
GoodROIidx = find(GoodROI);
GoodPeakAvg = GoodPeakAvg(GoodROIidx);
GoodPeaks = GoodPeaks(GoodROIidx);
PixelIdxList = PixelIdxList(GoodROIidx);
LPtrace = LPtrace(GoodROIidx);

% Calculate which pixels overlap
Overlaps = CalcOverlaps(PixelIdxList);

figure(1);set(gcf,'Position',[1 1 1920 700]);

NumMerges = 0;
maxerror = 30;
disp('assessing cluster merges');
NumNeurons = length(PixelIdxList);
p = ProgressBar(NumNeurons);

for i = 1:NumNeurons
    p.progress;
    temp = zeros(Xdim,Ydim);
    temp(PixelIdxList{i}) = 1;
    rp = regionprops(temp,'Centroid');
    Neighbors = find(Overlaps(i,:));
    [~,maxi] = max(GoodPeakAvg{i}(PixelIdxList{i}));
    maxi = PixelIdxList{i}(maxi);
    
    for j = 1:length(Neighbors)
        [~,maxj] = max(GoodPeakAvg{Neighbors(j)}(PixelIdxList{Neighbors(j)}));
        maxj = PixelIdxList{Neighbors(j)}(maxj);
        
        [~,m1] = imgradient(GoodPeakAvg{Neighbors(j)});
        [~,m2] = imgradient(GoodPeakAvg{i});
        CombList = union(PixelIdxList{i},PixelIdxList{Neighbors(j)});
        phasediffs = angdiff(deg2rad(m1(CombList)),deg2rad(m2(CombList)));
        PhaseError = rad2deg(mean(abs(phasediffs)));
        
        if((PhaseError <= maxerror) && (ismember(maxi,intersect(PixelIdxList{i},PixelIdxList{Neighbors(j)}))) && (ismember(maxj,intersect(PixelIdxList{i},PixelIdxList{Neighbors(j)}))))
            % Merge Clusters
            NumMerges = NumMerges+1;
            MergePairs{NumMerges} = [i,j];
            if(ToPlot)
                a1 = subplot(3,2,1);
                imagesc(GoodPeakAvg{i});title(int2str(i));
                axis image;hold on;caxis([0.005 max(GoodPeakAvg{i}(PixelIdxList{i}))]);colorbar;
                temp = zeros(Xdim,Ydim);
                temp(PixelIdxList{i}) = 1;
                PlotRegionOutline(temp,'r');
                temp2 = zeros(Xdim,Ydim);
                temp2(PixelIdxList{Neighbors(j)}) = 1;
                PlotRegionOutline(temp2,'g');
                hold off;
                
                
                a2 = subplot(3,2,2);
                imagesc(GoodPeakAvg{Neighbors(j)});title(int2str(Neighbors(j)));
                axis image;hold on;caxis([0.005 max(GoodPeakAvg{Neighbors(j)}(PixelIdxList{Neighbors(j)}))]);colorbar
                PlotRegionOutline(temp,'r');
                PlotRegionOutline(temp2,'g');
                hold off;
                linkaxes([a1 a2],'xy');
                axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
                
                
                
                
                a3 = subplot(3,2,3:4);plot(LPtrace{i});axis tight;hold on;plot(GoodPeaks{i},LPtrace{i}(GoodPeaks{i}),'ro');hold off;
                a4 = subplot(3,2,5:6);plot(LPtrace{Neighbors(j)});axis tight;hold on;plot(GoodPeaks{Neighbors(j)},LPtrace{Neighbors(j)}(GoodPeaks{Neighbors(j)}),'ro');hold off;
                linkaxes([a3 a4],'x');
                pause;
            end
        end
        
        
        
    end
    
end
p.stop;
disp('merging cluster peaks');
% Now perform the merges
DestinationClu = (1:NumNeurons);

for i = 1:NumMerges
    
    Eater = MergePairs{i}(1);
    FirstEater = Eater;
    Food = MergePairs{i}(2);
    FirstFood = Food;
    if((DestinationClu(Eater) ~= Eater) && (DestinationClu(Food) ~= Food))
        % both of these already got merged into something else
        continue;
    end
    
    while(DestinationClu(Eater) ~= Eater)
        Eater = DestinationClu(Eater);
    end
    
    while(DestinationClu(Food) ~= Food)
        Food = DestinationClu(Food);
    end
    
    DestinationClu(Food) = Eater;
    GoodPeaks{Eater} = sort(union(GoodPeaks{Food},GoodPeaks{Eater}));
    GoodPeaks{Food} = [];
    IsDup = zeros(1,length(GoodPeaks{Eater}));
    % sometimes peak locations get offset by a few samples, need to
    % eliminate duplicates created this way
    for j = 2:length(IsDup)
        if(GoodPeaks{Eater}(j)-GoodPeaks{Eater}(j-1) <= 5)
            disp('found duplicate!!');
            IsDup(j) = 1;
            GoodPeaks{Eater}(j) = -5;
        end
    end
    GoodPeaks{Eater} = GoodPeaks{Eater}(~IsDup);
end

GoodROI = zeros(1,NumNeurons);
for i = 1:NumNeurons
    if(DestinationClu(i) == i)
        GoodROI(i) = 1;
    end
end

GoodROIidx = find(GoodROI);
GoodPeakAvg = GoodPeakAvg(GoodROIidx);
GoodPeaks = GoodPeaks(GoodROIidx);
PixelIdxList = PixelIdxList(GoodROIidx);

keyboard;

disp('recalculating cluster ROIs')
NumNeurons = length(PixelIdxList);
for i = 1:NumNeurons
    [PixelIdxList{i},GoodPeakAvg{i}] = RecalcROI(PixelIdxList{i},GoodPeaks{i});
    if(isempty(PixelIdxList{i}))
        disp('need to write more error checking into the algo');
        keyboard;
    end
end




