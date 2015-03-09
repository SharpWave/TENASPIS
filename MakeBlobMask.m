function [] = MakeBlobMask()
%[] = MakeBlobMask(file)
% creates an image of all naively detected blobs, asks the user to draw the
% good stuff, then saves the mask to disk



%ExtractCaEvents2(file,0);
mask = roipoly;
save mask.mat mask


end

