function ExpandTransients(Todebug)
% uses traces and
load('NormTraces.mat','trace','difftrace');
load('ProcOut.mat','NumNeurons','NumFrames','FT');


p = ProgressBar(NumNeurons);
PosTr = zeros(NumNeurons,NumFrames);    PoPosTr = PosTr; 
NumTr = zeros(1,NumNeurons);            PoNumTr = NumTr; 
TrLength = cell(1,NumNeurons);          PoTrLength = TrLength; 
TrPeakVal = cell(1,NumNeurons);         PoTrPeakVal = TrPeakVal; 
TrPeakIdx = cell(1,NumNeurons);         PoTrPeakIdx = TrPeakIdx;
MinPeak = zeros(1,NumNeurons);          PoMinPeak = MinPeak; 
MaxPeak = zeros(1,NumNeurons);          PoMaxPeak = MaxPeak; 
AvgLength = zeros(1,NumNeurons);        PoAvgLength = AvgLength; 
for i = 1:NumNeurons
    %i
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
        
        while (tr(curr) > 0) && (curr < NumFrames)
            curr = curr + 1;
        end
        
        TrEnd = max(curr - 1,activefr(j));
        
        curr = activefr(j);
        
        while (tr(curr) > 0) && (curr > 1)
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
PrePoPosTr = zeros(NumNeurons,NumFrames);
for i = 1:NumNeurons
    tr = trace(i,:);
    PrePoPosTr(i,1:NumFrames) = (tr >= MinPeak(i)*0.25).*(PosTr(i,:) == 0);
end

for i = 1:NumNeurons
    %i
    tr = trace(i,:);
    PoPosTr(i,1:NumFrames) = 0;
    activefr = find(PrePoPosTr(i,:));
    PoNumTr(i) = 0;
    for j = 1:length(activefr)
        if (PoPosTr(i,activefr(j)))
            continue;
        end
        
        PoNumTr(i) = PoNumTr(i) + 1;
        
        % find backward extent
        curr = activefr(j);
        
        while (tr(curr) > 0) && (curr < NumFrames)
            curr = curr + 1;
        end
        
        TrEnd = max(curr - 1,activefr(j));
        
        curr = activefr(j);
        
        while (tr(curr) > 0) && (curr > 1)
            curr = curr - 1;
        end
        
        TrStart = min(curr + 1,activefr(j));
        
        PoPosTr(i,TrStart:TrEnd) = 1;
        
        % stats

        PoTrLength{i}(PoNumTr(i)) = TrEnd-TrStart+1;
        [PoTrPeakVal{i}(PoNumTr(i)),idx] = max(tr(TrStart:TrEnd));
        PoTrPeakIdx{i}(PoNumTr(i)) = idx+TrStart-1;
    end
    PoMinPeak(i) = min(TrPeakVal{i});
    PoMaxPeak(i) = max(TrPeakVal{i});
    PoAvgLength(i) = mean(TrLength{i});
end

 save ExpTransients.mat MaxPeak MinPeak PosTr PoPosTr PrePoPosTr PoTrPeakIdx PoNumTr;   
if (Todebug)
    for i = 1:NumNeurons
        plot(FT(i,:)*5);hold on;plot(PosTr(i,:)*5);plot(trace(i,:));plot(zscore(difftrace(i,:)));plot(PoPosTr(i,:),'-r','LineWidth',2);hold off;set(gca,'YLim',[-10 10]);pause;
    end
end

end

