function [a,xOff,yOff] = BoxGradient(PixelList,PixelAvg,Xdim,Ydim)
% We want to calculate gradients but not on the whole fucking window filled
% with zeros because that is killing performance

% so, we make a smaller window, put the data in there, and compute

[Xidx,Yidx] = ind2sub([Xdim Ydim],PixelList);

Xmin = min(Xidx);
Xmax = max(Xidx);

Ymin = min(Yidx);
Ymax = max(Yidx);

newXidx = Xidx-Xmin+1;
newYidx = Yidx-Ymin+1;

newXdim = Xmax-Xmin+1;
newYdim = Ymax-Ymin+1;

newMidx = sub2ind([newXdim newYdim],newXidx,newYidx);
newAvg = zeros(newXdim,newYdim);
newAvg(newMidx) = PixelAvg;
[~,a] = imgradient(newAvg);
xOff = Xmin;
yOff = Ymin;

end

