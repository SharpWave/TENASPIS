function [] = DetectGoodSlopes()

load expPosTr.mat;
load NormTraces.mat;
load('ProcOut.mat','NeuronPixels','NeuronImage');

NumNeurons = size(expPosTr,1);
NumFrames = size(expPosTr,2);

aCaTr = zeros(size(expPosTr));

display('Calculating positive slopes');
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
        
        if ((dfdt(curr) > 0) & inTr)
           aCaTr(i,curr) = 1;
        end
        
        if(inTr & (dfdt(curr) < 0))
            inTr = 0;
        end
        curr = curr + 1;
        end
    end
    p.progress;
end
p.stop;

% Calculate Overlaps
display('calculating overlaps');
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    overl{i} = [];
    for j = 1:NumNeurons
      if(~isempty(intersect(NeuronPixels{i},NeuronPixels{j})) && (i ~= j))
          overl{i} = [overl{i},j];
      end
    end
    p.progress;
end
p.stop;

for i = 1:NumNeurons
    CaEpochs = NP_FindSupraThresholdEpochs(aCaTr(i,:),eps);
    for j = 1:size(CaEpochs,1)
        Buddyspikes = [];
        for k = 1:length(overl{i})
            if (sum(aCaTr(overl{i}(k),CaEpochs(j,1):CaEpochs(j,2))) > 0)
                Buddyspikes = [Buddyspikes,overl{i}(k)];
            end
        end
        if(~isempty(Buddyspikes))
            display('conflict');
            f = loadframe('DFF.h5',CaEpochs(j,2));
            fmean = mean(f(NeuronPixels{i}));
            bmean = [];
            for k = 1:length(Buddyspikes)
                bmean(k) = mean(f(NeuronPixels{Buddyspikes(k)}));
            end
            if (fmean > max(bmean))
                display('winner');
                for k = 1:length(Buddyspikes)
                    aCaTr(Buddyspikes(k),CaEpochs(j,1):CaEpochs(j,2)) = 0;
                end
            end
        end
    end
end
                
FT = aCaTr;                
                


save T2output.mat NeuronPixels NeuronImage FT; 
