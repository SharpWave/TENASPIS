function Calc_pPeak()
% Calc_pPeak
%
% Calculates statistics on the pixel intensity values for all transients
% for each neuron.  See OUTPUTS for specifics.
%
% INPUTS - all loaded from workspace variables
%
%   from ProcOut.mat (see MakeNeurons): NeuronPixels, NumNeurons,
%   NumNeurons.
%
%   from ExpTransients.mat (see ExpantTransients): all variables
%
% 
% OUTPUTS - saved in pPeak.mat
%
%   pPeak: for each neuron, the probability that each pixel in its
%   mask was the location of the peak intensity across all transients. Note
%   that pixel indices for neuron N correspond to those in NeuronPixels{N}
%   from ProcOut.mat, NOT those in NeuronImage{N}.
%
%   mRank: for each neuron, the mean rank of each pixel's intensity 
%   value across all transients.  See comment on pixel indices above.
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
load('ProcOut.mat','NeuronPixels','NumNeurons','NumFrames');
load ExpTransients.mat;

FT = PosTr;
info = h5info('SLPDF.h5','/Object'); % Get h5info for loadframe below

%% Initialize variables
pPeak = cell(1,NumNeurons); 
mRank = cell(1,NumNeurons);
for i = 1:NumNeurons
    pPeak{i} = zeros(size(NeuronPixels{i}));
    mRank{i} = zeros(size(NeuronPixels{i}));
end

%% Calculate statistics

% Initialize progress bar
p = ProgressBar(NumFrames);

display('Calculating ranks and peaks...');
for i = 1:NumFrames
    ActiveN = find(FT(:,i)); % Identify active neurons in frame i

    frame = loadframe('SLPDF.h5',i,info); % Load the frame
    
    % For each neuron, calculate statistics
    for j = 1:length(ActiveN)
        idx = ActiveN(j); % Get index for active neuron j
        [~,maxid] = max(frame(NeuronPixels{idx})); % Locate max pixel intensity index
        pPeak{idx}(maxid) = pPeak{idx}(maxid) + 1; % Sum up each frame this was the peak pixel
        
        [~,srtidx] = sort(frame(NeuronPixels{idx})); % Sort the pixel intensity values for neuron j
        for k = 1:length(srtidx)
            mRank{idx}(srtidx(k)) = mRank{idx}(srtidx(k))+k; % Sum up the ranks for each pixel
        end
    end

    p.progress; % update progress bar
end
p.stop; % Terminate progress bar

% Normalize pPeak by total number of frames active and mRank by total
% number of frames active and number of pixels in the mask
for i = 1:NumNeurons
    pPeak{i} = pPeak{i}./sum(FT(i,:));
    mRank{i} = mRank{i}./sum(FT(i,:))./length(NeuronPixels{i});
end

%% Old Code

% for i = 1:NumFrames
%     [frame] = loadframe('SLPDF.h5',i);
%     for j = 1:NumNeurons
%       [val,srtidx] = sort(frame(NeuronPixels{j}));
%       tempRank = [];
%        for k = 1:length(srtidx)
%             tempRank(srtidx(k)) = k;
%        end
%        tempRank = tempRank./length(NeuronPixels{j});
%        %size(mRank{j}),size(tempRank),
%        RankDiff(j,i) = abs(mean(mRank{j}-tempRank'));
%     end
% end

%% Save variables
save pPeak.mat pPeak mRank;% RankDiff;

end

