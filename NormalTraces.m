function [] = NormalTraces(moviefile)
% This function takes the ROI output of MakeNeurons and extracts
% traces in the straightfoward-most way (by summing up all the pixels in a
% given neuron's ROI. Also normalizes traces at the end and get their
% temporal derivative
%
% INPUTS - all loaded from workspace variables
%
%   from ProcOut.mat (see MakeNeurons): NeuronImage, NumFrames,
%   NeuronPixels
%
% OUTPUTS - saved in NormTraces.mat
%
%   trace: a smoothed, normalized (z-scored) trace for each neuron
%
%   difftrace: temporal derivative of trace
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

close all;

%% Step 1: load up the ROIs
disp('Loading relevant variables from ProcOut')
load('ProcOut.mat','NeuronImage','NumFrames','NeuronPixels');

% Get image dimensions and number of neurons
Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);
NumNeurons = length(NeuronImage);

% Initialize progress bar
p=ProgressBar(NumFrames);
disp('Calculating traces for each neuron')
parfor i = 1:NumFrames
    
    % Read in each frame
    tempFrame = h5read(moviefile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    tempFrame = tempFrame(:);
 
    % Sum up the number of pixels active in each frame for each neuron
    for j = 1:NumNeurons
        trace(j,i) = mean(tempFrame(NeuronPixels{j}));
    end
    p.progress; % Update progress bar
end
p.stop; % Terminate progress bar

%% Smooth and normalize traces
disp('Smoothing traces and normalizing')
for i = 1:NumNeurons
    rawtrace(i,:) = trace(i,:);
    trace(i,:) = zscore(trace(i,:)); % Z-score all the calcium activity for neuron i - effectively thresholds trace later in ExpandTransients
    trace(i,:) = convtrim(trace(i,:),ones(10,1)/10); % Convolve the trace with a ten frame rectangular smoothing window, divide by 10
    trace(i,1:11) = 0; % Set 10 first frames to 0
    trace(i,end-11:end) = 0; % Set 10 last frames to 0
    
    rawtrace(i,:) = convtrim(rawtrace(i,:),ones(10,1)/10); % Convolve the trace with a ten frame rectangular smoothing window, divide by 10
    rawtrace(i,1:11) = 0; % Set 10 first frames to 0
    rawtrace(i,end-11:end) = 0; % Set 10 last frames to 0
    
    difftrace(i,2:NumFrames) = diff(trace(i,:)); % Get temporal derivative of each trace
    difftrace(i,1:11) = 0; % Set 10 first frames to 0
    difftrace(i,end-11:end) = 0; % Set 10 last frames to 0
end


save NormTraces.mat trace difftrace rawtrace;

end 