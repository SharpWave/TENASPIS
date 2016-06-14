function [] = DetectGoodSlopes()
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
% OUTPUTS - saved to T2output
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
%% Copyright 2015 by David Sullivan and Nathaniel Kinsky
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

MinDur = 6;

NumNeurons = size(expPosTr,1);

%% Calculate Good Slopes
disp('Calculating good slopes...')

% Initialize variable
aCaTr = zeros(size(expPosTr));

% Initialize ProgressBar
p = ProgressBar(NumNeurons);

% Run through each neuron's transients and identify positive slopes
for i = 1:NumNeurons
    
    dfdt = zscore(difftrace(i,:)); % normalize difftrace (temporal derivative of trace)
    epochs = NP_FindSupraThresholdEpochs(expPosTr(i,:),eps); % ID epochs where transients occur
    
    % Step throuh each epoch for neuron i
    for j = 1:size(epochs,1)
        curr = epochs(j,1); % set current frame to epoch start
        inTr = 0; % set inTransient variable to 0 to start
        while (curr <= epochs(j,2)) % Continue until you reach end of epoch j
            
            % If slope is >= 2stds above the mean, keep as a good slope
            if (dfdt(curr) >= 2)
                aCaTr(i,curr) = 1;
                inTr = 1; % Set inTransient to 1
            end
            
            % If the previous frame is already within a good transient,
            % keep as a good slope if slope is above the mean (is positive)
            if (dfdt(curr) > 0) && inTr
                aCaTr(i,curr) = 1;
            end
            
            % If slope goes negative, do not add a good slope
            if inTr && (dfdt(curr) < 0)
                inTr = 0;
            end
            curr = curr + 1; % Move to next frame
        end
    end

    p.progress; % update progress bar
end
p.stop; % terminate progress bar

% kill transients lasting less than 6
for i = 1:size(aCaTr,1)
    tEpochs = NP_FindSupraThresholdEpochs(aCaTr(i,:),eps);
    for j = 1:size(tEpochs,1)
        if ((tEpochs(j,2)-tEpochs(j,1)+1) < MinDur)
            aCaTr(i,tEpochs(j,1):tEpochs(j,2)) = 0;
        end
    end
end

%% Calculate Overlaps, detect
overl = cell(1,NumNeurons);
display('Calculating overlaps...');
p = ProgressBar(NumNeurons);% Initialize ProgressBar
for i = 1:NumNeurons
    overl{i} = []; % Initialize overlap variable
    for j = 1:NumNeurons
        
        % If pixels from neuron i and neuron j overlap, note in overlap
        % variable
        if(~isempty(intersect(NeuronPixels{i},NeuronPixels{j})) && (i ~= j))
            overl{i} = [overl{i},j];
        end
    end
    p.progress; % update progress bar
end
p.stop; % terminate progress bar

% Do one last comparison for buddy spikes to make sure none slipped through
info = h5info('DFF.h5','/Object');
for i = 1:NumNeurons
    % Grab epochs of good slope for neuron i
    CaEpochs = NP_FindSupraThresholdEpochs(aCaTr(i,:),eps);
    for j = 1:size(CaEpochs,1)
        Buddyspikes = []; % Initialize buddy spike variable
        
        % Step through each buddy/overlapping neuron and identify if it is
        % spiking concurrently with neuron i
        for k = 1:length(overl{i})
            if (sum(aCaTr(overl{i}(k),CaEpochs(j,1):CaEpochs(j,2))) > 0)
                Buddyspikes = [Buddyspikes,overl{i}(k)];
            end
        end
        
        % If buddy spikes are detected, resolve the conflict and designate
        % the winner spike
        if ~isempty(Buddyspikes)
            %display('conflict');
            
            % Load frame from DFF movie
            f = loadframe('DFF.h5',CaEpochs(j,2),info);
            fmean = mean(f(NeuronPixels{i})); % Get mean of pixels for neuron i
            bmean = zeros(1,length(Buddyspikes)); % Initialize buddy mean

            for k = 1:length(Buddyspikes)
                % Get mean of pixels for buddy neuron k
                bmean(k) = mean(f(NeuronPixels{Buddyspikes(k)}));
            end
            
            % If neuron i is the winner (mean greater than the maximum
            % buddy mean), set all transients in buddies to zero.
            if fmean > max(bmean)
                %display('winner');
                for k = 1:length(Buddyspikes)
                    aCaTr(Buddyspikes(k),CaEpochs(j,1):CaEpochs(j,2)) = 0;
                end
            end
        end
    end
end

% Rename aCaTr
FT = aCaTr;

% Check for ROIs with no transients
for i = 1:size(FT,1)
    tEpochs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    GoodROI(i) = size(tEpochs,1) > 0;
    if (~GoodROI(i))
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
