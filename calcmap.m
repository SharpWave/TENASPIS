function [ FMap,TMap] = calcmap(trace,movmap,Xbin,Ybin)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


FMap = zeros(size(movmap));
TMap = zeros(size(movmap));

Flength = length(trace);
for j = 1:Flength
    
        FMap(Xbin(j),Ybin(j)) = FMap(Xbin(j),Ybin(j)) + trace(j);
        TMap(Xbin(j),Ybin(j)) = TMap(Xbin(j),Ybin(j)) + (trace(j) > 0);
    
end
FMap = FMap./movmap;
TMap = TMap./movmap;

FMap(find(isnan(FMap))) = 0;
TMap(find(isnan(TMap))) = 0;

fsum = sum(FMap(:));

FMap = smooth2a(FMap,5,5);
TMap = smooth2a(TMap,5,5);

FMap = FMap.*fsum./sum(FMap(:));
TMap = TMap.*fsum./sum(TMap(:));
end

