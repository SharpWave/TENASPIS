function InterpretTraces(Todebug)

%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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
% disp('Loading relevant variables from NormTraces and ProcOut')
% load('NormTraces.mat','trace','difftrace','rawtrace');
% load('ProcOut.mat','NumNeurons','NumFrames','FT');

load('SegmentationROIs.mat','NeuronActivity','NumNeurons','NeuronTraces');
NumFrames = Get_T_Params('NumFrames');

SegTrBool = false(NumNeurons,NumFrames);
PoTrBool = false(NumNeurons,NumFrames);

Threshold = 0.001;

%% For each neuron, find samples where there were either segmentation-identified transients or potential transients
disp('analyzing traces for potential transients');
for i = 1:NumNeurons
    % find epochs where the trace was above zero
    PosEpochs = NP_FindSupraThresholdEpochs(NeuronTraces.LPtrace(i,:),Threshold);
    
    for j = 1:size(PosEpochs,1)
        temp = false(1,NumFrames);
        temp(PosEpochs(j,1):PosEpochs(j,2)) = true;
        if (sum(temp.*NeuronActivity(i,:)) > 0)
            SegTrBool(i,PosEpochs(j,1):PosEpochs(j,2)) = true;
        else
            PoTrBool(i,PosEpochs(j,1):PosEpochs(j,2)) = true;
        end
    end
    hold off;
    plot(NeuronTraces.LPtrace(i,:),'-b');hold on;
    plot(NeuronTraces.LPtrace(i,:).*SegTrBool(i,:),'-k');hold on;
    plot(NeuronTraces.LPtrace(i,:).*PoTrBool(i,:),'-r');axis tight;
    plot(NeuronTraces.LPtrace(i,:).*NeuronActivity(i,:),'-c','LineWidth',3);
    pause;

end

keyboard;            
    









% 
% 
% for n = 1:NumNeurons
%     
%     p.progress; % update progress bar
%     
%     tr = NeuronTraces.RawTrace(n,:); % Pull trace for neuron n
%     activefr = find(NeuronActivity(n,:)); % Identify active frame indices determined from image segmentation for neuron i
%     for f = activefr
%         
%         % If active frame f has already been identified as a positive
%         % transient, continue to next active frame without doing any
%         % calculations below
%         if (PosTr(n,f))
%             continue;
%         end
%                
%         % Find forward extent of transient (since trace is z-scored, valid 
%         % extent of trace continues as long as the trace is above its mean 
%         % value - i.e. trace is above 0)
%         curr = f; % Grab 1st active frame of normalized trace
%         while (tr(curr) > 0) && (curr < NumFrames) 
%             curr = curr + 1; % Step through until you don't meet criteria
%         end
%         
%         TrEnd = max(curr - 1,f); % Identify frame number at end of trace
%         
%         % Find backward extent of transient (trace is above its mean
%         % value)
%         curr = f;
%         while (tr(curr) > 0) && (curr > 1)
%             curr = curr - 1; % Step backward until you don't meet criteria
%         end
%         
%         TrStart = min(curr + 1,f); % Identify frame number at start of trace
%         
%         PosTr(n,TrStart:TrEnd) = 1; % Set all frames where a positive trace is detected to one
%         
%     end
%     
%     Epochs = NP_FindSupraThresholdEpochs(PosTr(n,:),eps); % Identify epochs of activity
%     NumTr(n) = size(Epochs,1); % Get number of traces for each neuron
%     
%     % Pull out trace information
%     for thisTrace = 1:NumTr(n)
%         TrLength{n}(thisTrace) = Epochs(thisTrace,2)-Epochs(thisTrace,1)+1;                 % Length of trace in frames for neuron n
%         [TrPeakVal{n}(thisTrace),idx] = max(tr(Epochs(thisTrace,1):Epochs(thisTrace,2)));   % The peak value and index for thisTrace of neuron n
%         TrPeakIdx{n}(thisTrace) = idx+Epochs(thisTrace,1)-1;                                % transform frame index within of peak for thisTrace to frame number index
%     end
%     
%     % Calculate the smallest peak, largest peak, and average transient
%     % length
%     if (NumTr(n) == 0) % If no transients detected, set values to those below
%         MinPeak(n) = -inf;
%         MaxPeak(n) = -inf;
%         AvgLength(n) = 0;
%     else % If there are transients, actually calculate these values
%         MinPeak(n) = min(TrPeakVal{n});
%         MaxPeak(n) = max(TrPeakVal{n});
%         AvgLength(n) = mean(TrLength{n});
%     end
%     
% end
% p.stop;
% 
% %% Find potential missed transients
% PrePoPosTr = zeros(NumNeurons,NumFrames); % Initialize
% 
% % Identify pre-expansion potential positive transients
% for n = 1:NumNeurons
%     tr = NeuronTraces.RawTrace(n,:); % Get trace
%     
%     % Potential transients must a) have trace values above 25% of the
%     % minimum peak detected above, and b) not already be a valid transient
%     PrePoPosTr(n,1:NumFrames) = (tr >= Threshold).*(PosTr(n,:) == 0);
% end
% 
% disp('Expanding transients part 2 (identify potential new transients)...'); 
% p = ProgressBar(NumNeurons);
% for n = 1:NumNeurons
%     tr = trace(n,:);
%     PoPosTr(n,1:NumFrames) = 0;
%     activefr = find(PrePoPosTr(n,:));
%     PoNumTr(n) = 0;
%     for f = activefr
%         if (PoPosTr(n,f))
%             continue;
%         end
%                
%         % Find forward extent of transient (intensity above mean value)
%         curr = f;
%         
%         while (tr(curr) > 0) && (curr < NumFrames)
%             curr = curr + 1;
%         end
%         
%         TrEnd = max(curr - 1,f);
%         
%         curr = f;
%         
%          % Find backward extent of transient (intensity above mean value)
%         while (tr(curr) > 0) && (curr > 1)
%             curr = curr - 1;
%         end
%         
%         TrStart = min(curr + 1,f);
%         
%         PoPosTr(n,TrStart:TrEnd) = 1;
%         
%     end
% 
%     Epochs = NP_FindSupraThresholdEpochs(PoPosTr(n,:),eps);
%     PoNumTr(n) = size(Epochs,1); % Get number of potential transients
%     for thisTrace = 1:PoNumTr(n)
%         PoTrLength{n}(thisTrace) = Epochs(thisTrace,2)-Epochs(thisTrace,1)+1; % Save potential transient length for epoch j
%         [PoTrPeakVal{n}(thisTrace),idx] = max(tr(Epochs(thisTrace,1):Epochs(thisTrace,2))); % ID the peak potential transient value and index in epoch j
%         PoTrPeakIdx{n}(thisTrace) = idx+Epochs(thisTrace,1)-1; % Convert index for peak value from epoch j numbering to frame number
%     end
%     
%     p.progress;
% end
% p.stop;
% 
% save ExpTransients.mat MaxPeak MinPeak PosTr PoPosTr PrePoPosTr PoTrPeakIdx PoNumTr;  
% 
% if Todebug
%     for n = 1:NumNeurons
%         plot(FT(n,:)*5);hold on;plot(PosTr(n,:)*5);plot(trace(n,:));plot(zscore(difftrace(n,:)));plot(PoPosTr(n,:),'-r','LineWidth',2);hold off;set(gca,'YLim',[-10 10]);pause;
%     end
% end
% 
% end
