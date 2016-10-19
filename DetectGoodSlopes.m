function DetectGoodSlopes()
% DetectGoodSlopes
%
% Detects rising events for each neuron's transients.  Then,
% detects any rising events in buddy neurons (those with overlapping pixels) that
% occur concurrently and assigns the rising event to the neuron with the
% largest mean pixel intensity.
%
%
% INPUTS - all loaded from workspace variables
%
%   from ProcOut.mat (see MakeNeurons): NeuronPixels, NeuronImage
%
%   from NormTraces.mat (see NormalTraces): all variables
%
%   from expPosTr.mat (see AddPoTransients): all variables
%
%
% OUTPUTS - saved to T2Output
%
%   NeuronPixels: a 1 x NumNeurons cell with the pixel indices for each
%   neuron corresponding to NeuronImage, below.
%
%   NeuronImage: a 1 x NumNeurons cell with a binary array indicating the
%   each neuron's mask
%
%   FT: a NumNeurons x NumFrames array where 1 = rising event, 0 = no
%   detected calcium activity.
%
%% Copyright 2016 by David Sullivan and Nathaniel Kinsky
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
load expPosTr.mat;
load NormTraces.mat;
load('ProcOut.mat','NeuronPixels','NeuronImage');
load CorrTrace.mat;

MinDur = 2;

NumNeurons = size(expPosTr,1);

%% Calculate Good Slopes
disp('Calculating good slopes...')

% Initialize variable
aCaTr = zeros(size(expPosTr));

% normalize difftrace (temporal derivative of trace)
dfdt = zscore(difftrace,[],2); 

% Initialize ProgressBar
resol = 1;                                  % Percent resolution for progress bar, in this case 1%
update_inc = round(NumNeurons/(100/resol)); % Get increments for updating ProgressBar
p = ProgressBar(100/resol);
% Run through each neuron's transients and identify positive slopes
for i = 1:NumNeurons
    
    epochs = NP_FindSupraThresholdEpochs(expPosTr(i,:),eps); % ID epochs where transients occur
    
    % Step through each epoch for neuron i
    for j = 1:size(epochs,1)
        curr = epochs(j,1); % set current frame to epoch start
        inTr = 0; % set inTransient variable to 0 to start
        while (curr <= epochs(j,2)) % Continue until you reach end of epoch j
            
            % If slope is >= 2stds above the mean, keep as a good slope
            if (dfdt(i,curr) >= 2)
                aCaTr(i,curr) = 1;
                inTr = 1; % Set inTransient to 1
            end
            
            % If the previous frame is already within a good transient,
            % keep as a good slope if slope is above the mean (is positive)
            if (dfdt(i,curr) > 0) && inTr
                aCaTr(i,curr) = 1;
            end
            
            % If slope goes negative, do not add a good slope
            if inTr && (dfdt(i,curr) < 0)
                inTr = 0;
            end
            curr = curr + 1; % Move to next frame
        end
    end
    
     if round(i/update_inc) == (i/update_inc)
        p.progress;
    end
end
p.stop; % terminate progress bar 

% check transients for correlation agreement
for i = 1:NumNeurons
   epochs = NP_FindSupraThresholdEpochs(aCaTr(i,:),eps); % ID epochs where transients occur 
   for j = 1:size(epochs,1)
      if (fCorrTrace(i,epochs(j,2)) < 0.5)
          % this slope of the transient is invalid
          aCaTr(i,epochs(j,1):epochs(j,2)) = 0;
      end
   end
end

% kill transients lasting less than 2
for i = 1:size(aCaTr,1)
    tEpochs = NP_FindSupraThresholdEpochs(aCaTr(i,:),eps);
    for j = 1:size(tEpochs,1)
        if ((tEpochs(j,2)-tEpochs(j,1)+1) < MinDur)
            aCaTr(i,tEpochs(j,1):tEpochs(j,2)) = 0;
        end
    end
end

% Rename aCaTr
FT = aCaTr;

% Check for ROIs with no transients
GoodROI = zeros(1,size(FT,1));
for i = 1:size(FT,1)
    tEpochs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    GoodROI(i) = size(tEpochs,1) > 0;
    if ~GoodROI(i)
        display(['ROI ',int2str(i),' had no transients']);
    end
end
ROIidx = find(GoodROI);
FT = FT(ROIidx,:);
NeuronImage = NeuronImage(ROIidx);
NeuronPixels = NeuronPixels(ROIidx);


%% Save variables

save T2output.mat NeuronPixels NeuronImage FT ROIidx;

end


