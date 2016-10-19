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
% Copyright 2016 by David Sullivan and Nathaniel Kinsky
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
load('NormTraces.mat','trace','difftrace','rawtrace');
load('ProcOut.mat','NumNeurons','NumFrames','FT');

%% Initialize variables
PosTr = zeros(NumNeurons,NumFrames);    % Positive transients
NumTr = zeros(1,NumNeurons);            % Number transients         
TrLength = cell(1,NumNeurons);          % Trace Length       
TrPeakVal = cell(1,NumNeurons);         % Trace Peak Value       
TrPeakIdx = cell(1,NumNeurons);         % Trace Peak Indices     
MinPeak = zeros(1,NumNeurons);          % Value of the smallest transient peak       
MaxPeak = zeros(1,NumNeurons);          % Value of the largest transient peak
AvgLength = zeros(1,NumNeurons);        % Average length (in frames) of all the transients
PoPosTr = PosTr;                        % Potential positive transients
PoNumTr = NumTr;                        % Potential number traces
PoTrLength = TrLength;                  % Potential trace length
PoTrPeakVal = TrPeakVal;                % Potential Trace Peak Value
PoTrPeakIdx = TrPeakIdx;                % Potential Trace Peak Indices

Threshold = 0.005;

%% Part 1
disp('Expanding transients part 1 (expand confirmed transients)...'); 

% Initialize progress bar
p = ProgressBar(NumNeurons);
for n = 1:NumNeurons
    
    p.progress; % update progress bar
    
    tr = rawtrace(n,:); % Pull trace for neuron n
    activefr = find(FT(n,:)); % Identify active frame indices determined from image segmentation for neuron i
    for f = activefr
        
        % If active frame f has already been identified as a positive
        % transient, continue to next active frame without doing any
        % calculations below
        if (PosTr(n,f))
            continue;
        end
               
        % Find forward extent of transient (since trace is z-scored, valid 
        % extent of trace continues as long as the trace is above its mean 
        % value - i.e. trace is above 0)
        curr = f; % Grab 1st active frame of normalized trace
        while (tr(curr) > 0) && (curr < NumFrames) 
            curr = curr + 1; % Step through until you don't meet criteria
        end
        
        TrEnd = max(curr - 1,f); % Identify frame number at end of trace
        
        % Find backward extent of transient (trace is above its mean
        % value)
        curr = f;
        while (tr(curr) > 0) && (curr > 1)
            curr = curr - 1; % Step backward until you don't meet criteria
        end
        
        TrStart = min(curr + 1,f); % Identify frame number at start of trace
        
        PosTr(n,TrStart:TrEnd) = 1; % Set all frames where a positive trace is detected to one
        
    end
    
    Epochs = NP_FindSupraThresholdEpochs(PosTr(n,:),eps); % Identify epochs of activity
    NumTr(n) = size(Epochs,1); % Get number of traces for each neuron
    
    % Pull out trace information
    for thisTrace = 1:NumTr(n)
        TrLength{n}(thisTrace) = Epochs(thisTrace,2)-Epochs(thisTrace,1)+1;                 % Length of trace in frames for neuron n
        [TrPeakVal{n}(thisTrace),idx] = max(tr(Epochs(thisTrace,1):Epochs(thisTrace,2)));   % The peak value and index for thisTrace of neuron n
        TrPeakIdx{n}(thisTrace) = idx+Epochs(thisTrace,1)-1;                                % transform frame index within of peak for thisTrace to frame number index
    end
    
    % Calculate the smallest peak, largest peak, and average transient
    % length
    if (NumTr(n) == 0) % If no transients detected, set values to those below
        MinPeak(n) = -inf;
        MaxPeak(n) = -inf;
        AvgLength(n) = 0;
    else % If there are transients, actually calculate these values
        MinPeak(n) = min(TrPeakVal{n});
        MaxPeak(n) = max(TrPeakVal{n});
        AvgLength(n) = mean(TrLength{n});
    end
    
end
p.stop;

%% Find potential missed transients
PrePoPosTr = zeros(NumNeurons,NumFrames); % Initialize

% Identify pre-expansion potential positive transients
for n = 1:NumNeurons
    tr = rawtrace(n,:); % Get trace
    
    % Potential transients must a) have trace values above 25% of the
    % minimum peak detected above, and b) not already be a valid transient
    PrePoPosTr(n,1:NumFrames) = (tr >= Threshold).*(PosTr(n,:) == 0);
end

disp('Expanding transients part 2 (identify potential new transients)...'); 
p = ProgressBar(NumNeurons);
for n = 1:NumNeurons
    tr = trace(n,:);
    PoPosTr(n,1:NumFrames) = 0;
    activefr = find(PrePoPosTr(n,:));
    PoNumTr(n) = 0;
    for f = activefr
        if (PoPosTr(n,f))
            continue;
        end
               
        % Find forward extent of transient (intensity above mean value)
        curr = f;
        
        while (tr(curr) > 0) && (curr < NumFrames)
            curr = curr + 1;
        end
        
        TrEnd = max(curr - 1,f);
        
        curr = f;
        
         % Find backward extent of transient (intensity above mean value)
        while (tr(curr) > 0) && (curr > 1)
            curr = curr - 1;
        end
        
        TrStart = min(curr + 1,f);
        
        PoPosTr(n,TrStart:TrEnd) = 1;
        
    end

    Epochs = NP_FindSupraThresholdEpochs(PoPosTr(n,:),eps);
    PoNumTr(n) = size(Epochs,1); % Get number of potential transients
    for thisTrace = 1:PoNumTr(n)
        PoTrLength{n}(thisTrace) = Epochs(thisTrace,2)-Epochs(thisTrace,1)+1; % Save potential transient length for epoch j
        [PoTrPeakVal{n}(thisTrace),idx] = max(tr(Epochs(thisTrace,1):Epochs(thisTrace,2))); % ID the peak potential transient value and index in epoch j
        PoTrPeakIdx{n}(thisTrace) = idx+Epochs(thisTrace,1)-1; % Convert index for peak value from epoch j numbering to frame number
    end
    
    p.progress;
end
p.stop;

save ExpTransients.mat MaxPeak MinPeak PosTr PoPosTr PrePoPosTr PoTrPeakIdx PoNumTr;  

if Todebug
    for n = 1:NumNeurons
        plot(FT(n,:)*5);hold on;plot(PosTr(n,:)*5);plot(trace(n,:));plot(zscore(difftrace(n,:)));plot(PoPosTr(n,:),'-r','LineWidth',2);hold off;set(gca,'YLim',[-10 10]);pause;
    end
end

end
