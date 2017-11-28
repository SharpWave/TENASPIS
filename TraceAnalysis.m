function [outputArg1,outputArg2] = TraceAnalysis()

close all;
load SegmentationROIs.mat;

load MovieDims.mat;
global T_MOVIE;


MinBlobRadius = Get_T_Params('MinBlobRadius');
MinBlobArea = MinBlobRadius^2*pi;

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
    
    thresh = 0.005;
    foundit = 0;
    oldsize = length(NeuronPixelIdxList{i});
    while(~foundit)
        
        tr = regionprops(GoodPeakAvg{i} > thresh,'PixelIdxList','Solidity');
        [~,midx] = max(NeuronAvg{i});
        foundit = 0;
        PixelIdxList{i} = [];
        for j = 1:length(tr)
            if(ismember(NeuronPixelIdxList{i}(midx),tr(j).PixelIdxList))
                PixelIdxList{i} = tr(j).PixelIdxList;
                break;
            end
        end
        
        if(isempty(PixelIdxList{i}) || (length(tr) == 0))
            PixelIdxList{i} = [];
            disp('killed a cluster');
            break;
        end
        if((length(PixelIdxList{i}) < 1.25*oldsize) && (tr(j).Solidity >= 0.9) )
            foundit = 1;
        end
        thresh = thresh + 0.001;
        
    end
    
    if (length(PixelIdxList{i}) < MinBlobArea)
        PixelIdxList{i} = [];
        disp(' a cluster got too small');
    end
    
%     if(~isempty(PixelIdxList{i}))
%         figure(1);
%         imagesc(GoodPeakAvg{i});hold on;axis image;
%         caxis([0.005 max(GoodPeakAvg{i}(NeuronPixelIdxList{i}))]);
%         temp = zeros(Xdim,Ydim);
%         temp(PixelIdxList{i}) = 1;
%         PlotRegionOutline(temp,'g');
%         PlotRegionOutline(NeuronImage{i},'r');
%         rp = regionprops(NeuronImage{i},'Centroid');
%         axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);hold off;
%         pause;
%     end
    
    
    %for j = 1:length(
    %     imagesc(GoodPeakAvg{i});
    %     hold on
    %     PlotRegionOutline(NeuronImage{i},'r');axis image;hold off;
    %     caxis([0.01 max(GoodPeakAvg{i}(NeuronPixelIdxList{i}))]);
    %     rp = regionprops(NeuronImage{i},'Centroid');
    %     axis([rp.Centroid(1)-20 rp.Centroid(1)+20 rp.Centroid(2)-20 rp.Centroid(2)+20]);pause;
    
end

save TraceA.mat GoodPeakAvg GoodPeaks LPtrace PixelIdxList -v7.3
keyboard;

