function [CorrBlobIdx,CorrIsolation] = MakeCorrBlob(PixelIdxList,CircMask,ROIcorrR)
    
    [Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
    
    corrblobframe = zeros(Xdim,Ydim,'single');
    threshold = sqrt(0.75);
    corrblobframe(CircMask) = (ROIcorrR > threshold);
    CenterIdx = ceil(length(CircMask)/2);
    
    
    % find the blob containing the centroid

    rp = regionprops(bwconncomp(corrblobframe,4),'PixelIdxList');
    FoundIt = 0;
    okregions = [];
    intersects = [];
    
    for j = 1:length(rp)
      inscount = length(intersect(PixelIdxList,rp(j).PixelIdxList));
      
      if (inscount > 0)
          okregions = [okregions,j];
          intersects = [intersects,inscount];
      end
    end
    
    if (~isempty(okregions))
        [~,idx] = max(intersects);
        FoundIt = okregions(idx);
    end
    
    if (FoundIt == 0)
        display('Dave the correlation blob thingy fucks up');
        keyboard;
    else
        CorrBlobIdx = rp(FoundIt).PixelIdxList;
        OutsidePixels = setdiff(CircMask,CorrBlobIdx);
        corrblobframe(CircMask) = ROIcorrR.*ROIcorrR;
        OutsideValues = corrblobframe(OutsidePixels);
        CorrIsolation = 1-mean(OutsideValues);
    end   
end

