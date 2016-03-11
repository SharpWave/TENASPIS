function [ output_args ] = AddPoTransients()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
load pPeak.mat;
load ExpTransients.mat;
load('ProcOut.mat','NumNeurons','NumFrames','NeuronPixels','NeuronImage');

expPosTr = PosTr;

for i = 1:length(NeuronImage)
    b = bwconncomp(NeuronImage{i});
    r = regionprops(b,'Centroid');
    Cents(i,1:2) = r.Centroid;
end

temp = pdist(Cents);
CentDist = squareform(temp);

display('checking buddies');
for j = 1:NumNeurons
    buddies{j} = [];
    for i = 1:NumNeurons
        if (i == j)
            continue;
        end
        if (CentDist(i,j) <= 15)
            buddies{j} = [buddies{j},i];
        end

    end
end

for i = 1:NumNeurons
    display(['Neuron ',int2str(i)]);
    PoEpochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps);
    for j = 1:size(PoEpochs,1)
        % check for buddies
        buddyspike = 0;
        for k = 1:length(buddies{i})
            if (sum(expPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0)
                buddyspike = 1;
            end
        end
        
        if (buddyspike)
            display('buddy spike');
            continue;
        end
        
        % no buddy spike, check peak
        f = loadframe('DFF.h5',PoTrPeakIdx{i}(j));
        [~,maxidx] = max(f(NeuronPixels{i}));
        peakpeak = pPeak{i}(maxidx);
        peakrank = mRank{i}(maxidx);
        if ((peakpeak > 0) & (peakrank > 0.7))
            display('new transient!');
            expPosTr(i,PoEpochs(j,1):PoEpochs(j,2)) = 1;
        else
            display('pixels off kilter');
        end
        
    end
end

save expPosTr.mat expPosTr;

