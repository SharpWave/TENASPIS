function AddPoTransients(todebug)
% AddPoTransients()
%
% Takes neuron and transient information in ExpTransients.mat, ProcOut.mat,
% and pPeak.mat and adds in missed transients.  For each potential
% transient for a given neuron, this function looks for calcium activity in
% each neighboring (buddy) neuron that is within the buddy distance
% threshold noted in the code below.  
%
% A new transient is added if three conditions are met: 
% 1) there are no transients in any of the buddy neurons identified on any 
% of the 10 frames prior to the peak of the potential transient, and 2) the 
% peak of the transient does not move too much throughout its duration when
% compared to previously confirmed transients from MakeNeurons, and
% 3) the rank of the peak pixel across all transients is greater than the 
% threshold in the code below, calculated using all the previously
% confirmed transients.
%
%
% INPUTS - all are loaded from workspace variables
%
%   from pPeak.mat (see Calc_pPeak): pPeak and mRank
%
%   from ExpTransients (see ExpandTransients): PosTr, PoPosTr, PoTrPeakIdx
%
%   from ProcOut.mat (see MakeNeurons): NumNeurons, NumFrames, 
%   NeuronPixels, NeuronImage, Xdim, Ydim.
%
%
% OUTPUTS - saved in expPosTr.mat
%
%   expPosTr - expanded positive transients, a NumNeurons x NumFrames
%   logical array for final calcium transient activity
%
%   expPosIdx - indices to the mean-maximum pixel for each added transient
%   in expPosTr
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

%% Parameters
buddy_dist_thresh = 15; % Any neurons with a centroid less than this many pixels away are considered a buddy
rankthresh = 0.55; % DAVE - what is this / how did you come up with this?

%% Parse todebug

if nargin < 1
    todebug = false;
end

%%
disp('Loading relevant variables')
load pPeak.mat;
load('ExpTransients.mat','PosTr','PoPosTr','PoTrPeakIdx');
load('ProcOut.mat','NumNeurons','NumFrames','NeuronPixels','NeuronImage','Xdim','Ydim');

expPosTr = PosTr; % Expanded positive transients - this gets updated below, while PosTr does not
clear PosTr % Clear this to save RAM

% Get centroids
Cents = zeros(length(NeuronImage),2); % Initialize
for i = 1:length(NeuronImage)
    b = bwconncomp(NeuronImage{i});
    r = regionprops(b,'Centroid');
    Cents(i,1:2) = r.Centroid;
end
clear NeuronImage 

temp = pdist(Cents);
CentDist = squareform(temp);

info = h5info('SLPDF.h5','/Object'); % Get movie info for loadframe below

%display('checking buddies');

% Identify buddy neurons for each neuron
for j = 1:NumNeurons
    buddies{j} = [];
    for i = 1:NumNeurons
        
        % Don't count neuron itself as a buddy
        if (i == j) 
            continue;
        end
        
        % Save buddy if it is less than the buddy distance threshold away
        if (CentDist(i,j) <= buddy_dist_thresh)
            buddies{j} = [buddies{j},i];
        end
        
    end
end

%% Nat attempt to load all information on max pixel index for each neuron
% ahead of time to speed up below

maxidx_full = nan(NumNeurons,NumFrames);
meanpix_full = nan(NumNeurons,NumFrames);
% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar

disp('Calculating max pixel location and mean pixel intensity for all neurons'' transients')
for i = 1:NumFrames
            
    f = loadframe('SLPDF.h5', i, info); % Load frame i
    
    % Get max pixel index and mean pixel intensity for each neuron that is
    % active or potentially active
    active_neurons = find(expPosTr(:,i) | PoPosTr(:,i)); % take2 edits

    % take3 edits to look for potential activity up to 10 frames ahead in accordance with 10 frame limit below
    if i+10 <= NumFrames
        active_neurons = find(sum(expPosTr(:,i:i+10) | PoPosTr(:,i:i+10),2) > 0);
    else 
        active_neurons = find(sum(expPosTr(:,i:end) | PoPosTr(:,i:end),2) > 0);
    end
    
    for j = 1:length(active_neurons)
        neuron_id = active_neurons(j);
        [~,maxidx_full(neuron_id,i)] = max(f(NeuronPixels{neuron_id}));  %#ok<*USENS>
        meanpix_full(neuron_id,i) = mean(f(NeuronPixels{neuron_id}));
    end
    
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
    
end
p.stop;

%% Add potential transients

expPosTrIdx = cell(1,NumNeurons); % Initialize variable
expPosTrsubs = cell(1,NumNeurons); % Initialize variable

disp('Adding potential transients...');
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    %display(['Neuron ',int2str(i)]);

    % Identify potential epochs where there may be a spike for neuron i
    PoEpochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps); 
    
    % Loop through each epoch and check for buddy spiking - if there is
    % none, add a new transient!
    n_trans_add = 0; % Number of added transients for neuron i
    for j = 1:size(PoEpochs,1)
        
        % initialize variables
        buddyspike = 0; % binary for if there is a buddy spike
        buddyconfs = []; % 
        
        % Loop through each buddy neuron and identify if there was a buddy
        % spike or if there is a potential positive transient
        for k = 1:length(buddies{i})
            
            % Identify buddy spikes from expanded positive transients
            % (confirmed spikes)
            if sum(expPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0
                buddyspike = 1; % If so, set binary to 1 to initiate checking below
            end
            
            % Identify if there was potential activity in the original transient
            % variable for buddy neurons (potential buddy conflicts)
            if (sum(PoPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0)
                buddyconfs = [buddyconfs,buddies{i}(k)]; % accrue list of buddies with potential spiking activity in original (unexpanded) transients       
            end
        end
        
        % Skip to next epoch without adding a transient if there is a buddy
        % spike
        if buddyspike
            %display('buddy spike');
            continue;
        end
        
        %%% If there is not a buddy spike, check the peak %%%
        maxidx = []; maxidx_orig = [];

        ps = PoTrPeakIdx{i}(j)-10; % Grab the 10 frames active before the time of neuron i's potential spike in epoch j
        
        % Identify the pixel index for the max pixel intensity in neuron i for each of these frames
        for k = ps:PoTrPeakIdx{i}(j)
            
            % Original code to compare to for debugging
%             f = loadframe('SLPDF.h5', k, info); 
%             [~,maxidx_orig(k)] = max(f(NeuronPixels{i}));
            maxidx(k) = maxidx_full(i,k); 
%             
        end
        
        % If there are potential buddy conflicts, get the mean pixel
        % intensity for each buddy neuron during the peak of the potential
        % spike of neuron i in epoch j
        meanpix = []; meanpix_orig = [];
        if ~isempty(buddyconfs)
            %display('buddy conflict');
            
            % Accrue list of means
            for k = 1:length(buddyconfs)
                
                % Original code to compare to for debugging
%                 meanpix_orig(k) = mean(f(NeuronPixels{buddyconfs(k)})); % NRK commenting to test out speed increases 
                
                meanpix(k) = meanpix_full(buddyconfs(k),PoTrPeakIdx{i}(j)); % mean of buddy k at time of potential peak transient
            end
            
            
            % Now, compare.  If the mean of neuron i pixels at its peak in
            % epoch j is less than the maximum of the mean of all the
            % buddy neurons, then buddy activity probably caused the
            % potential transient so don't add a new one
            if meanpix_full(i,PoTrPeakIdx{i}(j)) < max(meanpix) 
                if todebug && (mean(f(NeuronPixels{i})) >= max(meanpix_orig))
                    disp('Conflict between original method and new method')
                    keyboard
                end
                %display('lost conflict');
                continue;
            end
        end
        

        % Get the subs for the location of the maximum pixel intensity in
        % neuron i during the ten frames preceding the peak in epoch j
        temp = maxidx(end-10:end); % take 2/3
        maxidx_valid = temp(~isnan(temp)); %take 2/3 Grab only frames where neuron trace is non-NaN (i.e. z-score above zero)
        [xp,yp] = ind2sub([Xdim,Ydim],NeuronPixels{i}(maxidx_valid)); % take 2/3 convert to global pixel indices
        
        % identify the index corresponding to the average of the above
        meanmaxidx = sub2ind([Xdim,Ydim],round(nanmean(xp)),round(nanmean(yp))); 
        meanmaxidx = find(meanmaxidx == NeuronPixels{i}); % take2/3 convert back to NeuronPixel indices
%         meanmaxidx = mode(maxidx(end-10:end)); % take 4
        
%         % Before bugfix
%         [xp,yp] = ind2sub([Xdim,Ydim],maxidx_valid);
%         meanmaxidx = sub2ind([Xdim,Ydim],round(mean(xp)),round(mean(yp)));
%         
        if isempty(meanmaxidx)
            peakpeak = -inf;
            peakrank = 0;
        else
            peakpeak = pPeak{i}(meanmaxidx); % Get the peak value for all transients confirmed by image segmentation
            peakrank = mRank{i}(meanmaxidx); % Get the mean rank of the peak pixel across all transients confirmed by image segmentation
        end
        
%         if todebug
%             [xp_orig,yp_orig] = ind2sub([Xdim,Ydim],maxidx_orig(end-10:end));
%             meanmaxidx_orig = sub2ind([Xdim,Ydim],round(nanmean(xp_orig)),round(nanmean(yp_orig)));
%             if meanmaxidx_orig ~= meanmaxidx
%                 disp('Discrepancy in meanmaxidx - debugging');
%                 % Basically this is spitting out different values than the
%                 % original method because I only get values for the 10
%                 % frames before if they included a potential transient
%                 keyboard
%             end
%         end
        
        % Check if neurons without a buddy transient meet the peak pixel
        % location criteria and rank criteria

        if (peakpeak > 0) && (peakrank > rankthresh)
            %display('new transient!');
            expPosTr(i,PoEpochs(j,1):PoEpochs(j,2)) = 1; % Add in new transient
            n_trans_add = n_trans_add + 1; % Update number of added transients
            expPosTrIdx{i}(n_trans_add) = meanmaxidx; % Save meanmaxidx
            expPosTrsubs{i}(n_trans_add,1:2) = [round(mean(xp)),round(mean(yp))];
        else % Put in keyboard statments below if you wish to see why each neuron is getting rejected and uncomment disp functions
            %display('pixels off kilter');
            if peakpeak == 0
                %display('this pixel is never the peak');
            end
            if peakrank < rankthresh
                %display('mean rank of the peak not high enough');
            end
        end

        
    end
    
    % Debugging code
%     if todebug
%         disp(['Done with neuron ' num2str(1)])
%         keyboard
%     end
    
    p.progress;
end
p.stop; 

%%
save expPosTr.mat expPosTr expPosTrIdx;

end