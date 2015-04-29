function [ACG] = NeuronBodyCCG(meanX,meanY,Xdim,Ydim)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

NumNeurons = length(meanX);

Xbinc = (0:0.5:Xdim);
Ybinc = (0:0.5:Ydim);

NumXBins = length(Xbinc);
NumYBins = length(Ybinc);

[Xcount,Xbinidx] = histc(meanX,Xbinc);
[Ycount,Ybinidx] = histc(meanY,Ybinc);

ACG = zeros(NumXBins*2+1,NumYBins*2+1);

for i = 1:NumNeurons
    i
    for j = 1:NumNeurons
        xdiff = Xbinidx(i)-Xbinidx(j);
        ydiff = Ybinidx(i)-Ybinidx(j);
        if (i ~= j)
            ACG(xdiff+NumXBins+1,ydiff+NumYBins+1) = ACG(xdiff+NumXBins+1,ydiff+NumYBins+1)+1;
            
        end
    end
end
keyboard;
        




end

