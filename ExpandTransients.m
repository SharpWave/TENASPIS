function ExpandTransients(Todebug)
% Takes the information from MakeNeurons (rough idea of when a transient is
% occuring for each neuron) and NormalTraces and identifies when traces
% actually start and end.  This is necessary because the output of
% MakeNeurons only identifies when large events that are easily separable
% from neighboring neurons are occurring.  This function identifies the
% actual start and end of the neuron's activity and fills in any missed
% transients

%% Load relevant variables
disp('Loading relevant variables from NormTraces and ProcOut')
load('NormTraces.mat','trace','difftrace');
load('ProcOut.mat','NumNeurons','NumFrames','FT');

%% Initialize variables
PosTr = zeros(NumNeurons,NumFrames); % Positive transients
NumTr = zeros(1,NumNeurons); % Number transients         
TrLength = cell(1,NumNeurons); % Trace Length       
TrPeakVal = cell(1,NumNeurons); % Trace Peak Value       
TrPeakIdx = cell(1,NumNeurons); % Trace Peak Indices     
MinPeak = zeros(1,NumNeurons);           
MaxPeak = zeros(1,NumNeurons);          
AvgLength = zeros(1,NumNeurons);        
PoPosTr = PosTr; % Potential positive transients
PoNumTr = NumTr; % Potential number traces
PoTrLength = TrLength; % Potential trace length
PoTrPeakVal = TrPeakVal; % Potential Trace Peak Value
PoTrPeakIdx = TrPeakIdx; % Potential Trace Peak Indices

%% Part 1
disp('Expanding transients part 1...'); 

% Initialize progress bar
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    
    p.progress; % update progress bar
    
    tr = trace(i,:); % Pull trace for neuron i
    activefr = find(FT(i,:)); % Identify active frame indices for neuron i
    for j = 1:length(activefr)
        if (PosTr(i,activefr(j)))
            continue;
        end
               
        %Find forward extent of transient
        curr = activefr(j); % Grab 1st active frame of normalized trace
        while (tr(curr) > 0) && (curr < NumFrames)
            curr = curr + 1; % Step through until end of
        end
        
        TrEnd = max(curr - 1,activefr(j)); % Identify frame number at end of trace
        
        % Find backward extent of transient
        curr = activefr(j);
        while (tr(curr) > 0) && (curr > 1)
            curr = curr - 1;
        end
        
        TrStart = min(curr + 1,activefr(j)); % Identify frame number at start of trace
        
        PosTr(i,TrStart:TrEnd) = 1; % Set all frames where a positive trace is detected to one
        
    end
    
    Epochs = NP_FindSupraThresholdEpochs(PosTr(i,:),eps); % Identify epochs of activity
    NumTr(i) = size(Epochs,1); % Get number of traces
    
    % Pull out trace information
    for j = 1:NumTr(i)
        TrLength{i}(j) = Epochs(j,2)-Epochs(j,1)+1; % Length of trace in frames
        [TrPeakVal{i}(j),idx] = max(tr(Epochs(j,1):Epochs(j,2))); % 
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
    
end
p.stop;

%% find potential missed transients
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

