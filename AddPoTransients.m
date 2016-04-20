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
% 1) there are no transients in any of the buddy neurons identified on the 
% potentially active frames prior to the peak of the potential transient, 
% and 2) the peak of the transient is located in a plausible position 
% (where at least one prior transient peak occurred), and
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
%   buddies - indices to the each neuron's buddies
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

%% Load variables and calculate pre-requisite data
disp('Loading relevant variables')
load pPeak.mat;
load('ExpTransients.mat','PosTr','PoPosTr','PoTrPeakIdx');
load('ProcOut.mat','NumNeurons','NumFrames','NeuronPixels','NeuronImage','Xdim','Ydim');

expPosTr = PosTr;

Cents = zeros(length(NeuronImage),2); 
rankthresh = 0.55;

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
for j = 1:NumNeurons
    buddies{j} = [];
    for i = 1:NumNeurons
        if (i == j)
            continue;
        end
        if (CentDist(i,j) <= 15)
            buddies{j} = [buddies{j},i];
        end
        
    end
end

% Calculate number of buddies and approximate time to run function below,
% if over 60 minutes, then calculate everything ahead
calc_ahead = 0; % Default - do not calculate max pixel location and mean pixel intensity ahead
num_buddies = sum(cellfun(@(a) size(a,2),buddies)); % total number of buddy neurons requiring calculation
approx_time = 25*(NumFrames/40000)*(num_buddies/8500)^2;
if approx_time > 60
    calc_ahead = 1;
else
    calc_ahead = 0;
end

calc_ahead = 1; % Set for debugging

%% Get information on max pixel index for each neuron (only if runtime below will be long)

% Only do this is calc_ahead variable is set
if calc_ahead == 1

% Initialize variables
maxidx_full = nan(NumNeurons,NumFrames);
meanpix_full = nan(NumNeurons,NumFrames);

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar

disp('Calculating max pixel location and mean pixel intensity for all neurons'' transients')
for i = 1:NumFrames
            
    f = loadframe('SLPDF.h5', i, info); % Load frame i
    
    % Identify active neurons for frame i
    active_neurons = find(expPosTr(:,i) | PoPosTr(:,i));
    
    % Find all the active buddies and get their activity too
    active_plus_buddy = unique([active_neurons' cat(2,buddies{active_neurons})]);
    
    % Get max pixel index and mean pixel intensity for each neuron that is
    % active or potentially active
    for j = 1:length(active_plus_buddy)
        neuron_id = active_plus_buddy(j);
        [~,maxidx_full(neuron_id,i)] = max(f(NeuronPixels{neuron_id}));  %#ok<*USENS>
        meanpix_full(neuron_id,i) = mean(f(NeuronPixels{neuron_id}));
    end


    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
    
end
p.stop;

end
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
        % check for buddies
        buddyspike = 0;
        buddyconfs = [];
        
        for k = 1:length(buddies{i})
            if sum(expPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0
                buddyspike = 1;    
            end
            
            if (sum(PoPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0)
                buddyconfs = [buddyconfs,buddies{i}(k)];            
            end
        end
        
        if buddyspike
            %display('buddy spike');
            continue;
        end
        
        maxidx = [];
        
        % Get the indices to all the frames preceding the peak of the
        % identified as part of the potential transient.  Go back at most
        % 10 frames.
        ps = max([PoTrPeakIdx{i}(j)-10, PoEpochs(j,1)]); 
        
        % Identify the pixel index for the max pixel intensity in neuron i for each of these frames
        n_potrans = 1;
        for k = ps:PoTrPeakIdx{i}(j)
            
            if calc_ahead == 0
                f = loadframe('SLPDF.h5', k, info);
                [~,maxidx(n_potrans)] = max(f(NeuronPixels{i}));
            elseif calc_ahead == 1
                maxidx(n_potrans) = maxidx_full(i,k);
            end
            
            n_potrans = n_potrans + 1;
            
        end
        
        meanpix = [];
        if ~isempty(buddyconfs)
            %display('buddy conflict');
            for k = 1:length(buddyconfs)
                if calc_ahead == 0
                    meanpix(k) = mean(f(NeuronPixels{buddyconfs(k)}));
                elseif calc_ahead == 1
                    meanpix(k) = meanpix_full(buddyconfs(k),PoTrPeakIdx{i}(j)); % mean of buddy k pixels at time of potential transient peak for epoch j
                end
            end
            
            % Now, compare.  If the mean of neuron i pixels at its peak in
            % epoch j is less than the maximum of the mean of all the
            % buddy neurons, then buddy activity probably caused the
            % potential transient so don't add a new one and move onto next
            % epoch
            if calc_ahead == 0
                peakmean = mean(f(NeuronPixels{i}));
            elseif calc_ahead == 1
                peakmean = meanpix_full(i,PoTrPeakIdx{i}(j));
            end
            if  peakmean < max(meanpix) % mean(f(NeuronPixels{i})) < max(meanpix)
                %display('lost conflict');
                continue;
            end
        end
        

        % Get the subs for the location of the maximum pixel intensity in
        % neuron i during the valid frames preceding the peak in epoch j
        maxidx_valid = maxidx(~isnan(maxidx)); %Grab only frames where neuron trace is non-NaN.
        [xp,yp] = ind2sub([Xdim,Ydim],NeuronPixels{i}(maxidx_valid)); % convert NeuronPixel indices to global pixel indices
        
        % identify the index corresponding to the average of the above
        meanmaxidx = sub2ind([Xdim,Ydim],round(nanmean(xp)),round(nanmean(yp))); 
        meanmaxidx = find(meanmaxidx == NeuronPixels{i}); % convert global indices back to NeuronPixel indices
        
        if isempty(meanmaxidx) % Designate values that will not result in an added transient for an empty meanmaxidx
            peakpeak = -inf;
            peakrank = 0;
        else
            peakpeak = pPeak{i}(meanmaxidx); % Get the peak value for all transients confirmed by image segmentation
            peakrank = mRank{i}(meanmaxidx); % Get the mean rank of the peak pixel across all transients confirmed by image segmentation
        end
        
        % Check if neurons without a buddy transient meet the peak pixel
        % location criteria and rank criteria listed above
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
    
    p.progress;
end
p.stop; 

save expPosTr.mat expPosTr expPosTrIdx buddies;

end


