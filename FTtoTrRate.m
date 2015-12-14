function [CaTrRate,NumTr] = FTtoTrRate(FT,sr)
% Takes a binary neuron activation matrix(NumNeurons by NumFrames) and
% converts this to Transients per second by convolving the beginning of the
% events with a 1-second window.
if (nargin < 2)
    sr = 20;
end

NumNeurons = size(FT,1);
NumFrames = size(FT,2);

CaTrRate = zeros(size(FT));

for i = 1:NumNeurons
    temp = NP_FindSupraThresholdEpochs(FT(i,:),eps,0);
    NumTr(i) = size(temp,1);
    if (isempty(temp))
        continue;
    end
    TrStarts = temp(:,1);
    TrBool = zeros(NumFrames,1);
    TrBool(TrStarts) = 1;
    CaTrRate(i,:) = convtrim(TrBool,ones(1,sr));
end

