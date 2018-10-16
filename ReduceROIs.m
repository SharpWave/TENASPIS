function [] = ReduceROIs()
close all;

load MovieDims.mat;
load ('TraceA.mat','GoodPeakAvg','GoodPeaks','LPtrace','PixelIdxList');
%load('PlaceMaps2.mat','y','FToffset');
%y = [ones(1,FToffset-2)*min(y),y];

global T_MOVIE;
ToPlot = 1;
NumNeurons = length(PixelIdxList);

GoodROI = zeros(1,NumNeurons);

for i = 1:NumNeurons
    if(~isempty(GoodPeaks{i}) && ~isempty(PixelIdxList{i}))
        GoodROI(i) = 1;
    end
end
sum(GoodROI),
% kill anything eliminated this way
GoodROIidx = find(GoodROI);
GoodPeakAvg = GoodPeakAvg(GoodROIidx);
GoodPeaks = GoodPeaks(GoodROIidx);
PixelIdxList = PixelIdxList(GoodROIidx);
LPtrace = LPtrace(GoodROIidx,:);
figure(1);set(gcf,'Position',[1 1 1920 700]);

MaxErrorList = [10,10,10,15,15,15,20,20,20,25,25,25,30,30,30,35,35,35,40,40,40,45,45,45];
for q = 1:length(MaxErrorList)
    maxerror = MaxErrorList(q)
    % Calculate which pixels overlap
    disp('calculating overlaps');
    Overlaps = CalcOverlaps(PixelIdxList);
    
    
    
    NumMerges = 0;
    disp('assessing cluster merges');
    NumNeurons = length(PixelIdxList),
    p = ProgressBar(NumNeurons);
    MergePairs = [];
    MergeError = [];
    ROIchanged = zeros(1,NumNeurons);
    
    for i = 1:NumNeurons
        if(ROIchanged(i))
            continue;
        end
        p.progress;
        
        
        Neighbors = find(Overlaps(i,:) > 0);
        %ceil(length(PixelIdxList{i})/10));
        
        [~,maxi] = max(GoodPeakAvg{i}(PixelIdxList{i}));
        maxi = PixelIdxList{i}(maxi);
        
        for j = 1:length(Neighbors)
            if (i == Neighbors(j))
                continue;
            end
            if(ROIchanged(Neighbors(j)))
                continue;
            end
            
            if(ROIchanged(i))
                continue;
            end
            
            if(length(GoodPeaks{Neighbors(j)}) > length(GoodPeaks{i}))
                continue;
            end
            
            [~,maxj] = max(GoodPeakAvg{Neighbors(j)}(PixelIdxList{Neighbors(j)}));
            maxj = PixelIdxList{Neighbors(j)}(maxj);
            
            %             if(~ismember(maxi,intersect(PixelIdxList{i},PixelIdxList{Neighbors(j)})) || ~ismember(maxj,intersect(PixelIdxList{i},PixelIdxList{Neighbors(j)})))
            %                 continue;
            %             end
            
            overlapindex = Overlaps(i,Neighbors(j))/min(length(PixelIdxList{i}),length(PixelIdxList{Neighbors(j)}));
            if(overlapindex <= 0.4)
                continue;
            end
            [maxix,maxiy] = ind2sub([Xdim,Ydim],maxi);
            [maxjx,maxjy] = ind2sub([Xdim,Ydim],maxj);
            mergedist = ((maxix-maxjx)^2+(maxiy-maxjy)^2)^0.5;
            
            if mergedist >= 7.5
                continue
            end
            [~,m1] = imgradient(GoodPeakAvg{Neighbors(j)});
            [~,m2] = imgradient(GoodPeakAvg{i});
            
            UnionList = union(PixelIdxList{i},PixelIdxList{Neighbors(j)});
            Unionphasediffs = angdiff(deg2rad(m1(UnionList)),deg2rad(m2(UnionList)));
            UnionPhaseError = rad2deg(mean(abs(Unionphasediffs)));
            
            IntersectList = intersect(PixelIdxList{i},PixelIdxList{Neighbors(j)});
            Intersectphasediffs = angdiff(deg2rad(m1(IntersectList)),deg2rad(m2(IntersectList)));
            IntersectPhaseError = rad2deg(mean(abs(Intersectphasediffs)));
            
            ErrorOK = (UnionPhaseError <= maxerror);
            
            
            
            if(ErrorOK)
                % Merge Clusters
                NumMerges = NumMerges+1;
                MergePairs{NumMerges} = [i,Neighbors(j)];
                MergeUnionPhaseError(NumMerges) = UnionPhaseError;
                MergeIntersectPhaseError(NumMerges) = IntersectPhaseError;
                MergeOverlapIdx(NumMerges) = overlapindex;
                ROIchanged(i) = 1;
                ROIchanged(Neighbors(j)) = 1;
                MergeDistance(NumMerges) = mergedist;
            end
        end
    end
    p.stop;
    disp('merging cluster peaks');
    % Now perform the merges
    DestinationClu = (1:NumNeurons);
    
    
    for i = 1:NumMerges
        Eater = MergePairs{i}(1);
        Food = MergePairs{i}(2);
        
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
        
        if(maxerror >= 40) %
            temp = zeros(Xdim,Ydim);
            temp(PixelIdxList{Eater}) = 1;
            rp = regionprops(temp,'Centroid');
            a1 = subplot(4,2,1);
            imagesc(GoodPeakAvg{Eater});title(int2str(Eater));
            axis image;hold on;caxis([0.000 max(GoodPeakAvg{Eater}(PixelIdxList{Eater}))]);colorbar;
            temp = zeros(Xdim,Ydim);
            temp(PixelIdxList{Eater}) = 1;
            PlotRegionOutline(temp,'r');
            temp2 = zeros(Xdim,Ydim);
            temp2(PixelIdxList{Food}) = 1;
            PlotRegionOutline(temp2,'g');
            hold off;
            
            a2 = subplot(4,2,2);
            imagesc(GoodPeakAvg{Food});title(int2str(Food));
            axis image;hold on;caxis([0.000 max(GoodPeakAvg{Food}(PixelIdxList{Food}))]);colorbar
            PlotRegionOutline(temp,'r');
            PlotRegionOutline(temp2,'g');
            hold off;
            linkaxes([a1 a2],'xy');
            axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);
            
            a3 = subplot(4,2,3:4);plot(LPtrace(Eater,:));axis tight;hold on;plot(GoodPeaks{Eater},LPtrace(Eater,GoodPeaks{Eater}),'ro');hold off;
            
            title(['Union phase error: ',num2str(MergeUnionPhaseError(i)),' Intersect phase error: ',num2str(MergeIntersectPhaseError(i)),' overlap % = ',num2str(MergeOverlapIdx(i)),' distance = ',num2str(MergeDistance(i))]);
            
            a4 = subplot(4,2,5:6);plot(LPtrace(Food,:));axis tight;hold on;plot(GoodPeaks{Food},LPtrace(Food,GoodPeaks{Food}),'ro');hold off;
            
            %a5 = subplot(4,2,7:8);plot(y);axis tight;hold on;plot(GoodPeaks{Eater},y(GoodPeaks{Eater}),'ro','MarkerSize',12,'MarkerFaceColor','r');plot(GoodPeaks{Food},y(GoodPeaks{Food}),'go','MarkerFaceColor','g');hold off;
            %linkaxes([a3 a4 a5],'x');
            linkaxes([a3 a4 ],'x');
            pause;
        end
        DestinationClu(Food) = Eater;
        GoodPeaks{Eater} = sort(union(GoodPeaks{Food},GoodPeaks{Eater}));
        
        GoodPeaks{Food} = [];
        PixelIdxList{Food} = [];
        
        IsDup = zeros(1,length(GoodPeaks{Eater}));
        % sometimes peak locations get offset by a few samples, need to
        % eliminate duplicates created this way
        for j = 2:length(IsDup)
            if(GoodPeaks{Eater}(j)-GoodPeaks{Eater}(j-1) <= 10)
                %disp('found duplicate!!');
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
    LPtrace = LPtrace(GoodROIidx,:);
    ROIchanged = ROIchanged(GoodROIidx);
    
    disp('recalculating cluster ROIs')
    NumNeurons = length(PixelIdxList);
    GoodROI = ones(1,NumNeurons);
    
    for i = 1:NumNeurons
        if(ROIchanged(i) && ~isempty(GoodPeaks(i)))
            [PixelIdxList{i},GoodPeakAvg{i}] = RecalcROI(PixelIdxList{i},GoodPeaks{i});
        end
        if(isempty(PixelIdxList{i}))
            disp('need to write more error checking into the algo');
            GoodROI(i) = 0;
        end
    end
    
    GoodROIidx = find(GoodROI);
    GoodPeakAvg = GoodPeakAvg(GoodROIidx);
    GoodPeaks = GoodPeaks(GoodROIidx);
    PixelIdxList = PixelIdxList(GoodROIidx);
    LPtrace = LPtrace(GoodROIidx,:);
    sum(GoodROI),
    
end

disp('Recalculating traces');
clear LPtrace;
LPtrace = zeros(length(PixelIdxList),NumFrames,'single');

for i = 1:length(PixelIdxList)
    temptrace = CalcROITrace(PixelIdxList{i},1:NumFrames);
    LPtrace(i,:) = convtrim(temptrace,ones(2,1)/2)';
end

save Reduced.mat GoodPeaks GoodROIidx PixelIdxList GoodPeakAvg LPtrace -v7.3;



