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
MinPeak = zeros(1,NumNeurons);           
MaxPeak = zeros(1,NumNeurons);          
AvgLength = zeros(1,NumNeurons);        


disp('Expanding transients part 1...'); 
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    tr = trace(i,:);
    activefr = find(FT(i,:));
    
    for j = 1:length(activefr)
        if (PosTr(i,activefr(j)))
            continue;
        end
               
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
        
        
    end
    Epochs = NP_FindSupraThresholdEpochs(PosTr(i,:),eps);
    NumTr(i) = size(Epochs,1);
    for j = 1:NumTr(i)
        TrLength{i}(j) = Epochs(j,2)-Epochs(j,1)+1;
        [TrPeakVal{i}(j),idx] = max(tr(Epochs(j,1):Epochs(j,2)));
        TrPeakIdx{i}(j) = idx+Epochs(j,1)-1;
    end
    if (NumTr(i) == 0)
        MinPeak(i) = -inf;
        MaxPeak(i) = -inf;
        AvgLength(i) = 0;
    else
        MinPeak(i) = min(TrPeakVal{i});
        MaxPeak(i) = max(TrPeakVal{i});
        AvgLength(i) = mean(TrLength{i});
    end
    p.progress;
end
p.stop;

% find potential missed transients
PrePoPosTr = zeros(NumNeurons,NumFrames);
for i = 1:NumNeurons
    tr = trace(i,:);
    PrePoPosTr(i,1:NumFrames) = (tr >= MinPeak(i)*0.25).*(PosTr(i,:) == 0);
end

disp('Expanding transients part 2...'); 
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    tr = trace(i,:);
    PoPosTr(i,1:NumFrames) = 0;
    activefr = find(PrePoPosTr(i,:));
    PoNumTr(i) = 0;
    for j = 1:length(activefr)
        if (PoPosTr(i,activefr(j)))
            continue;
        end
               
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
        
    end

    Epochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps);
    PoNumTr(i) = size(Epochs,1);
    for j = 1:PoNumTr(i)
        PoTrLength{i}(j) = Epochs(j,2)-Epochs(j,1)+1;
        [PoTrPeakVal{i}(j),idx] = max(tr(Epochs(j,1):Epochs(j,2)));
        PoTrPeakIdx{i}(j) = idx+Epochs(j,1)-1;
    end
    
    p.progress;
end
p.stop;

save ExpTransients.mat MaxPeak MinPeak PosTr PoPosTr PrePoPosTr PoTrPeakIdx PoNumTr;  

if Todebug
    for i = 1:NumNeurons
        plot(FT(i,:)*5);hold on;plot(PosTr(i,:)*5);plot(trace(i,:));plot(zscore(difftrace(i,:)));plot(PoPosTr(i,:),'-r','LineWidth',2);hold off;set(gca,'YLim',[-10 10]);pause;
    end
end

end

