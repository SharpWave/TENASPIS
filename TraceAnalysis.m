function [] = TraceAnalysis(NeuronPixelIdxList,BigNeuronAvg,LPtrace,MaxError,OldGoodPeaks)

load MovieDims.mat;
global T_MOVIE;

PeakWinLen = 6;
MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;

NumNeurons = length(NeuronPixelIdxList);

p = ProgressBar(NumNeurons);
GoodPeakAvg = cell(1,NumNeurons);
GoodPeaks = cell(1,NumNeurons);
PixelIdxList = cell(1,NumNeurons);

for i = 1:NumNeurons
    NeuronAvg{i} = BigNeuronAvg{i}(NeuronPixelIdxList{i});
    p.progress;
    
    
    [~,b] = findpeaks(LPtrace(i,:),'MinPeakDistance',10,'MinPeakProminence',0.005,'MinPeakHeight',0.005);
    PeakIsOld = zeros(1,length(b));
    
    if(exist('OldGoodPeaks','var'))
        IsDup = zeros(1,length(b));
        for j = 1:length(OldGoodPeaks{i})
            PeakDist = abs(OldGoodPeaks{i}(j)-b);
            IsDup = IsDup | (PeakDist <= 10);
        end
        b = b(~IsDup);
        PeakIsOld = zeros(1,length(b));
        PeakIsOld = [PeakIsOld,ones(1,length(OldGoodPeaks{i}))];
        b = [b,OldGoodPeaks{i}];
        [b,bidx] = sort(b);
        PeakIsOld = PeakIsOld(bidx);
    end
    
    
    GoodPeakAvg{i} = zeros(Xdim,Ydim,'single');
    GoodPeak = zeros(1,length(b));
    
    [a2,xOff2,yOff2] = BoxGradient(NeuronPixelIdxList{i},NeuronAvg{i},Xdim,Ydim);
    [cx,cy] = ind2sub([Xdim Ydim],NeuronPixelIdxList{i});
    cx2 = cx-xOff2+1;
    cy2 = cy-yOff2+1;
    BoxCombPixIdx2 = sub2ind(size(a2),cx2,cy2);
    
    for j = 1:length(b)
        
        mv = mean(T_MOVIE(:,:,max(b(j)-PeakWinLen,1):min(b(j)+PeakWinLen,NumFrames)),3);
        [a1,xOff1,yOff1] = BoxGradient(NeuronPixelIdxList{i},mv(NeuronPixelIdxList{i}),Xdim,Ydim);
        
        % Left shift indices for a1's coordinates
        cx1 = cx-xOff1+1;
        cy1 = cy-yOff1+1;
        BoxCombPixIdx1 = sub2ind(size(a1),cx1,cy1);
        
        phasediffs = angdiff(deg2rad(a1(BoxCombPixIdx1)),deg2rad(a2(BoxCombPixIdx2)));
        PhaseError = rad2deg(mean(abs(phasediffs)));
        
        if ((PhaseError <= MaxError) || PeakIsOld(j))
            GoodPeak(j) = 1;
            GoodPeakAvg{i} = GoodPeakAvg{i} + mv;
        end
    end
    GoodPeakAvg{i} = GoodPeakAvg{i}./sum(GoodPeak);
    GoodPeaks{i} = b(find(GoodPeak));
    
    PixelIdxList{i} = RecalcROI(NeuronPixelIdxList{i},GoodPeaks{i});
    
    
    
    %     if(~isempty(PixelIdxList{i}))
    %         figure(1);
    %         imagesc(GoodPeakAvg{i});hold on;axis image;
    %         caxis([0.005 max(GoodPeakAvg{i}(NeuronPixelIdxList{i}))]);
    %         temp = zeros(Xdim,Ydim);
    %         temp(PixelIdxList{i}) = 1;
    %         PlotRegionOutline(temp,'g');
    %         NeuronImage{i} = zeros(Xdim,Ydim,'single');
    %         NeuronImage{i}(NeuronPixelIdxList{i}) = 1;
    %         PlotRegionOutline(NeuronImage{i},'r');
    %         rp = regionprops(NeuronImage{i},'Centroid');
    %         axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);hold off;
    %         pause;
    %     end
    
end
p.stop;


save TraceA.mat GoodPeakAvg GoodPeaks LPtrace PixelIdxList -v7.3


