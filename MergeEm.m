function [NewFrameList,NewObjList,Trans2ROI,NewXcent,NewYcent,NewCircMask,NewPixelIdxList,NewBigPixelAvg,NewROIcorrR,NewROIcorrP,NewROIcorrSig,NewCorrBlobIdx,NewCorrIsolation] = ...
    MergeEm(CurrROI,TargetROI,FrameList,ObjList,Trans2ROI,Xcent,Ycent,CircMask,PixelIdxList,BigPixelAvg,ROIcorrR,ROIcorrP,ROIcorrSig,CorrBlobIdx,CorrIsolation)

% take two ROIs, merge, create new merged ROI
[Xdim,Ydim,NumFrames,ROICircleWindowRadius] = Get_T_Params('Xdim','Ydim','NumFrames','ROICircleWindowRadius');

NewFrameList = [FrameList{CurrROI} FrameList{TargetROI}];

% Merge Object Lists
NewObjList = [ObjList{CurrROI} ObjList{TargetROI}];

% Update Trans2ROI (mapping from previous step into final ROI
Trans2ROI(TargetROI) = CurrROI;

% Recalculate the centroids (average the x and y)
NewXcent = (Xcent(CurrROI) + Xcent(TargetROI))/2;
NewYcent = (Ycent(CurrROI) + Ycent(TargetROI))/2;

% Recalculate CircMask
NewCircMask = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,NewXcent,NewYcent);

% Recalc BigPixelAvg
NumPixels = length(NewCircMask);
TempTrace = zeros(NumPixels,length(NewFrameList),'single');

for k = 1:NumPixels
    TempTrace(k,:) = CalcROITrace(NewCircMask(k),NewFrameList);
end

NewBigPixelAvg = mean(TempTrace,2);

% Recalculate the ROI
%try
NewPixelIdxList = RecalcROI_Corr(union(PixelIdxList{CurrROI},PixelIdxList{TargetROI}),NewCircMask,NewBigPixelAvg);


% Recalculate the correlation map

[NewROIcorrR,NewROIcorrP] = TraceCorrelationMap(NewPixelIdxList,NewCircMask,NewFrameList);
NewROIcorrSig = NewROIcorrR.*(NewROIcorrP < 0.01);


% Recalculate the correlation blob
[NewCorrBlobIdx] = MakeCorrBlob(NewPixelIdxList,NewCircMask,NewROIcorrSig);
[~,NewOutsideIdx] = setdiff(NewCircMask,NewCorrBlobIdx);
NewCorrIsolation = 1 - sum(NewBigPixelAvg(NewOutsideIdx) > 0.05)/length(NewOutsideIdx);

% Readjust the ROI
NewPixelIdxList = intersect(NewPixelIdxList,NewCorrBlobIdx);
[~,loc] = ismember(NewPixelIdxList,NewCircMask);
[~,Peak] = max(NewBigPixelAvg(loc));

NewPeakIdx = NewPixelIdxList(Peak);

[NewYcent NewXcent] = ind2sub([Xdim Ydim],NewPixelIdxList(Peak));
end

