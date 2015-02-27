function [PFok,outmap] = IsPlacefield(TransMap,cmperbin)
% [PFok] = IsPlacefield(FMap)
% PlaceMap is a map of average fluorescence per 2.5 cm pixel
% TransMap is a map of the probability that there was a nonzero
% transient in that pixel

% PFok is a boolean
% roughly based off of Dombeck's criteria
% PFok 

%fThresh = 0.2;

tThresh = 0.10;
minlength = 5; % minimum length of PF in cm

BoolMap = TransMap > tThresh;

cc = bwconncomp(BoolMap,8);
% cc has 3 fields: ImageSize, NumObjects, PixelIdxList
g = regionprops(cc,'all');

PFok = 0;

outmap = zeros(size(BoolMap));

for i = 1:length(g)
    
    if(g(i).MajorAxisLength*cmperbin > minlength)
        Tpix = TransMap(cc.PixelIdxList{i});
        Tpix = Tpix(:);
        g(i).MajorAxisLength*cmperbin
        if (min(Tpix) >= tThresh)
            PFok = 1;
            outmap(cc.PixelIdxList{i}) = 1;
            return;
        end
    end
end


