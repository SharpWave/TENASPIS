function ExpandTransients(Todebug)
% Takes the information from MakeNeurons (rough idea of when a transient is
% occuring for each neuron) and NormalTraces and identifies when traces
% actually start and end.  This is necessary because the output of
% MakeNeurons only identifies when large events that are easily separable
% from neighboring neurons are occurring.  This function identifies the
% actual start and end of the neuron's activity and fills in any missed
% transients.  Criteria = z-scored trace is above 0. 
%
% Additionally it also calculates potential future transients by looking
% for sections of a neuron's trace that exceed 25% of the smallest peak
% identified above.  These potential transients are vetted later in
% AddPoTransients.
%
% INPUTS - all loaded from worspace variables
%
%   from NormTraces.mat (see NormalTraces): trace, difftrace
%
%   from ProcOut.mat
%
%
% OUTPUTS - all saved in ExpTransients.mat
%
%   PosTr (Positive Transients): A NumNeurons x NumFrames logical array 
%   identified the start and end of the expanded transients identified by 
%   the criteria above.
%
%   PrePoPosTr (Pre-expansion Potential Positive Transients): Same format 
%   as PosTr, but for parts of the trace not identified by MakeNeurons (FT 
%   variable) that meet criteria for being a potential transient above.
%
%   PoPosTr (Potential Positive Transients): expanded version of the
%   PrePoPosTr
% 
%   PoTrPeakIdx (Potential Transient Peak Index) : A cell array where each 
%   entry contains the frame number index of peak value for each transient
%   for all neurons
%
%   PoNumTr (Potential Number of Transients): A 1 x NumNeurons array that
%   contains the number of potential transients for each neuron
%
%   MaxPeak: 1 x NumNeurons array containing the value of largest peak of
%   all transients identified in PosTr.
%
%   MinPeak: 1 x NumNeurons array containing the value of smallest peak of
%   all transients identified in PosTr.
%
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
% 
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
MinPeak = zeros(1,NumNeurons); % Value of the smallest transient peak       
MaxPeak = zeros(1,NumNeurons); % Value of the largest transient peak
AvgLength = zeros(1,NumNeurons); % Average length (in frames) of all the transients
PoPosTr = PosTr; % Potential positive transients
PoNumTr = NumTr; % Potential number traces
PoTrLength = TrLength; % Potential trace length
PoTrPeakVal = TrPeakVal; % Potential Trace Peak Value
PoTrPeakIdx = TrPeakIdx; % Potential Trace Peak Indices

%% Part 1
disp('Expanding transients part 1 (expand confirmed transients)...'); 

% Initialize progress bar
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    tr = trace(i,:); % Pull trace for neuron i
    activefr = find(FT(i,:)); % Identify active frame indices determined from image segmentation for neuron i
    for j = 1:length(activefr)
        
        % If active frame j has already been identified as a positive
        % transient, continue to next active frame without doing any
        % calculations below
        if (PosTr(i,activefr(j)))
            continue;
        end
               
        % Find forward extent of transient (since trace is z-scored, valid 
        % extent of trace continues as long as the trace is above its mean 
        % value - i.e. trace is above 0)
         curr = activefr(j); % Grab 1st active frame of normalized trace
        while (tr(curr) > 0) && (curr < NumFrames) 
            curr = curr + 1; % Step through until you don't meet criteria
        end
        
        TrEnd = max(curr - 1,activefr(j)); % Identify frame number at end of trace
        
        % Find backward extent of transient (trace is above its mean
        % value)
        curr = activefr(j);
        while (tr(curr) > 0) && (curr > 1)
            curr = curr - 1; % Step backward until you don't meet criteria
        end
        
        TrStart = min(curr + 1,activefr(j)); % Identify frame number at start of trace
        
        PosTr(i,TrStart:TrEnd) = 1; % Set all frames where a positive trace is detected to one
        
    end
    
    Epochs = NP_FindSupraThresholdEpochs(PosTr(i,:),eps); % Identify epochs of activity
    NumTr(i) = size(Epochs,1); % Get number of traces for each neuron
    
    % Pull out trace information
    for j = 1:NumTr(i)
        TrLength{i}(j) = Epochs(j,2)-Epochs(j,1)+1; % Length of trace in frames for neuron i
        [TrPeakVal{i}(j),idx] = max(tr(Epochs(j,1):Epochs(j,2))); % The peak value and index for trace j of neuron i
        TrPeakIdx{i}(j) = idx+Epochs(j,1)-1; % transform frame index within of peak for trace j to frame number index
    end
    
    % Calculate the smallest peak, largest peak, and average transient
    % length
    if (NumTr(i) == 0) % If no transients detected, set values to those below
        MinPeak(i) = -inf;
        MaxPeak(i) = -inf;
        AvgLength(i) = 0;
    else % If there are transients, actually calculate these values
        MinPeak(i) = min(TrPeakVal{i});
        MaxPeak(i) = max(TrPeakVal{i});
        AvgLength(i) = mean(TrLength{i});
    end
    
    p.progress; % update progress bar
end
p.stop;

%% Find potential missed transients
PrePoPosTr = zeros(NumNeurons,NumFrames); % Initialize

% Identify pre-expansion potential positive transients
for i = 1:NumNeurons
    tr = trace(i,:); % Get trace
    
    % Potential transients must a) have trace values above 25% of the
    % minimum peak detected above, and b) not already be a valid transient
    PrePoPosTr(i,1:NumFrames) = (tr >= MinPeak(i)*0.25).*(PosTr(i,:) == 0);
end

disp('Expanding transients part 2 (identify potential new transients)...'); 
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
               
        % Find forward extent of transient (intensity above mean value)
        curr = activefr(j);
        
        while (tr(curr) > 0) && (curr < NumFrames)
            curr = curr + 1;
        end
        
        TrEnd = max(curr - 1,activefr(j));
        
        curr = activefr(j);
        
         % Find backward extent of transient (intensity above mean value)
        while (tr(curr) > 0) && (curr > 1)
            curr = curr - 1;
        end
        
        TrStart = min(curr + 1,activefr(j));
        
        PoPosTr(i,TrStart:TrEnd) = 1;
        
    end

    Epochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps);
    PoNumTr(i) = size(Epochs,1); % Get number of potential transients
    for j = 1:PoNumTr(i)
        PoTrLength{i}(j) = Epochs(j,2)-Epochs(j,1)+1; % Save potential transient length for epoch j
        [PoTrPeakVal{i}(j),idx] = max(tr(Epochs(j,1):Epochs(j,2))); % ID the peak potential transient value and index in epoch j
        PoTrPeakIdx{i}(j) = idx+Epochs(j,1)-1; % Convert index for peak value from epoch j numbering to frame number
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

