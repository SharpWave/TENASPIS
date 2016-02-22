function [ output_args ] = ExpandTransients(Todebug)
% uses traces and
load('NormTraces.mat','trace','difftrace');
load('ProcOut.mat','NumNeurons','NumFrames','FT');



for i = 1:NumNeurons
    i
    tr = trace(i,:);
    PosTr(i,1:NumFrames) = 0;
    activefr = find(FT(i,:));
    NumTr(i) = 0;
    for j = 1:length(activefr)
        if (PosTr(i,activefr(j)))
            continue;
        end
        
        NumTr(i) = NumTr(i) + 1;
        
        % find backward extent
        curr = activefr(j);
        
        while ((tr(curr) > 0) & (curr < NumFrames))
            curr = curr + 1;
        end
        
        TrEnd = max(curr - 1,activefr(j));
        
        curr = activefr(j);
        
        while ((tr(curr) > 0) & (curr > 1))
            curr = curr - 1;
        end
        
        TrStart = min(curr + 1,activefr(j));
        
        PosTr(i,TrStart:TrEnd) = 1;
        
        % stats

        TrLength{i}(NumTr(i)) = TrEnd-TrStart+1;
        [TrPeakVal{i}(NumTr(i)),idx] = max(tr(TrStart:TrEnd));
        TrPeakIdx{i}(NumTr(i)) = idx+TrStart-1;
    end
    MinPeak(i) = min(TrPeakVal{i});
    MaxPeak(i) = max(TrPeakVal{i});
    AvgLength(i) = mean(TrLength{i});
end



% find potential missed transients
PoPosTr = zeros(NumNeurons,NumFrames);
for i = 1:NumNeurons
    tr = trace(i,:);
    PoPosTr(i,1:NumFrames) = (tr >= MinPeak(i)).*(PosTr(i,:) == 0);
end
 save ExpTransients.mat MaxPeak MinPeak PosTr PoPosTr;   
if (Todebug)
    for i = 1:NumNeurons
        plot(FT(i,:)*5);hold on;plot(PosTr(i,:)*5);plot(trace(i,:));plot(zscore(difftrace(i,:)));plot(PoPosTr(i,:),'-r','LineWidth',2);hold off;set(gca,'YLim',[-10 10]);pause;
    end
end
keyboard;

