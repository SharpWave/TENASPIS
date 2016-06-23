function [idx] = PercentileCutoff(InMat,val)

InMatSorted = sort(InMat(:));

idx = ceil(val/100*length(InMatSorted));
idx = InMatSorted(idx);


end

