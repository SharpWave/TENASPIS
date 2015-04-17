function [TMap] = calcmapdec(trace,occmap,Xbin,Ybin,goodsamples)
% trace is boolean vector of cell on/off
% occmap is the occupancy map
% Xbin is the x coordinate of the mouse
% Ybin is the y coordinate of the mouse
% goodsamples is a boolean, 0 if the sample doesn't get used
% IMPORTANT the 'occmap' parameter and the 'goodsamples' parameter need to be
% consistent

TMap = zeros(size(occmap));
Flength = length(trace);
for j = 1:Flength
    if(goodsamples(j))
        TMap(Xbin(j),Ybin(j)) = TMap(Xbin(j),Ybin(j)) + (trace(j) > 0);
    end
end

TMap = TMap./occmap;
TMap(find(isnan(TMap))) = 0;
Tsum = sum(TMap(:));

sm = fspecial('disk',6);
TMap = imfilter(TMap,sm);

TMap = TMap.*Tsum./sum(TMap(:)); % keep sum the same
end