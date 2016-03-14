function [] = DetectGoodSlopes()

load expPosTr.mat;
load NormTraces.mat;
load('ProcOut.mat','NeuronPixels','NeuronImage');

NumNeurons = size(expPosTr,1);
%NumFrames = size(expPosTr,2);

aCaTr = zeros(size(expPosTr));

p = ProgressBar(NumNeurons); 
for i = 1:NumNeurons
    dfdt = zscore(difftrace(i,:));
    epochs = NP_FindSupraThresholdEpochs(expPosTr(i,:),eps);
    for j = 1:size(epochs,1)
        curr = epochs(j,1);
        inTr = 0;
        while (curr <= epochs(j,2))
        
        
        
        if (dfdt(curr) >= 2)
            aCaTr(i,curr) = 1;
            inTr = 1;
        end
        
        if (dfdt(curr) > 0) && inTr
           aCaTr(i,curr) = 1;
        end
        
        if inTr && (dfdt(curr) < 0)
            inTr = 0;
        end
        curr = curr + 1;
        end
    end

    p.progress;
end
p.stop;

FT = aCaTr;

save T2output.mat NeuronPixels NeuronImage FT; 
