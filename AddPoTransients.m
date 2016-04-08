function AddPoTransients(todebug)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Parameters
buddy_dist_thresh = 15; % Any neurons with a centroid less than this many pixels away are considered a buddy
rankthresh = 0.55; % DAVE - what is this / how did you come up with this?

%% Parse debug variable

if nargin < 1
    todebug = 0;
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

% keyboard

%% Nat attempt to load all information on max pixel index for each neuron
% ahead of time to speed up below

maxidx_full = nan(NumNeurons,NumFrames);
meanpix_full = nan(NumNeurons,NumFrames);
% Initialize ProgressBar
resol = 5; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
for i = 1:NumFrames
            
    f = loadframe('SLPDF.h5', i, info); % Load frame i
    
    % Get max pixel index and mean pixel intensity for each neuron that is
    % active or potentially active
    % take2
    active_neurons = find(expPosTr(:,i) | PoPosTr(:,i)); 
    % NRK - could shift to find(sum(expPosTr(:,i:i+10) | PoPosTr(:,i:i+10),2) > 0) 
    % to look for potential activity up to 10 frames ahead in accordance with 10 frame limit below
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

%%

disp('Adding potential transients...');
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    %display(['Neuron ',int2str(i)]);

    % Identify potential epochs where there may be a spike for neuron i
    PoEpochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps); 
    
    % Loop through each epoch and check for buddy spiking - if there is
    % none, add a new transient!
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
            f = loadframe('SLPDF.h5', k, info); 
            [~,maxidx_orig(k)] = max(f(NeuronPixels{i}));
            maxidx(k) = maxidx_full(i,k); 
            
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
                meanpix_orig(k) = mean(f(NeuronPixels{buddyconfs(k)})); % NRK commenting to test out speed increases 
                meanpix(k) = meanpix_full(buddyconfs(k),PoTrPeakIdx{i}(j)); % mean of buddy k at time of potential peak transient
            end
            
            % Now, compare.  If the mean of neuron i pixels at its peak in
            % epoch j is less than the maximum of the mean of all the
            % buddy neurons, then buddy activity probably caused the
            % potential transient so don't add a new one
            if (mean(f(NeuronPixels{i})) < max(meanpix))
                %display('lost conflict');
                continue;
            end
        end
        
        % Get the subs for the location of the maximum pixel intensity in
        % neuron i during the ten frames preceding the peak in epoch j
        temp = maxidx(end-10:end); % Grab max peak index from the 10 frames preceding peak in epoch j
        maxidx_valid = temp(~isnan(temp)); % Pull out only non-NaN indices
        [xp,yp] = ind2sub([Xdim,Ydim],NeuronPixels{i}(maxidx_valid));
%         [xp,yp] = ind2sub([Xdim,Ydim],maxidx(end-10:end)); % DAVE - I think that this should be NeuronPixels{i}(maxidx(end-10:end)).  maxidx reference NeuronPixels, whose max index is the number of pixels in that neuron.  yp is always = 0 for this code
        
        % identify the index corresponding to the average of the above
        meanmaxidx = sub2ind([Xdim,Ydim],round(nanmean(xp)),round(nanmean(yp))); % sub2ind([Xdim,Ydim],round(median(xp)),median(mean(yp))); DAVE - do you mean to have a median of the mean of yp? 
        % DAVE I think this should follow: meanmaxidx = find(NeuronPixels{i} ==
        % meanmaxidx); % This gets us back to NeuronPixel{i} indices, which
        % are what pPeak and mRank are based on
        meanmaxidx = find(NeuronPixels{i} == meanmaxidx);
        peakpeak = pPeak{i}(meanmaxidx); % Get the peak value?
        peakrank = mRank{i}(meanmaxidx); % Get the rank of the peak pixel?
        
        if todebug
            [xp_orig,yp_orig] = ind2sub([Xdim,Ydim],maxidx_orig(end-10:end));
            meanmaxidx_orig = sub2ind([Xdim,Ydim],round(nanmean(xp_orig)),round(nanmean(yp_orig)));
            if meanmaxidx_orig ~= meanmaxidx
                disp('Discrepancy in meanmaxidx - debugging');
                % Basically this is spitting out different values than the
                % original method because I only get values for the 10
                % frames before if they included a potential transient
                keyboard
            end
        end
        
        try
        % NAT - continue here after you figure out what Calc_pPeak does...
        if (peakpeak > 0) && (peakrank > rankthresh)
            %display('new transient!');
            expPosTr(i,PoEpochs(j,1):PoEpochs(j,2)) = 1;
        else
            %display('pixels off kilter');
            if peakpeak == 0
                %display('this pixel is never the peak');
            end
            if peakrank < rankthresh
                %display('mean rank of the peak not high enough');
            end
        end
        
        catch
            disp('Error catching toward end of AddPoTransients')
            keyboard
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
save expPosTr.mat expPosTr;

end