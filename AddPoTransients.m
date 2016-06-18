function AddPoTransients()
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
CorrThresh = 0.5;

%% Load variables and calculate pre-requisite data
disp('Loading relevant variables')

load('ExpTransients.mat','PosTr','PoPosTr','PoTrPeakIdx');
load('ProcOut.mat','NumNeurons','NumFrames','NeuronPixels','NeuronImage','Xdim','Ydim');
load CorrTrace.mat;

expPosTr = PosTr;

%% Add potential transients

disp('Adding potential transients...');
p = ProgressBar(NumNeurons); 
for i = 1:NumNeurons
    % Identify potential epochs where there may be a spike for neuron i
    PoEpochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps); 
    
    % Loop through each epoch and check if the correlation between the
    % pixels in that epoch and the averaged ROI ever exceeds the threshold
    

    for j = 1:size(PoEpochs,1)
        MaxCorr = max(fCorrTrace(i,PoEpochs(j,1):PoEpochs(j,2)));
        

        
        if (MaxCorr > CorrThresh)
            %display('new transient!');
            expPosTr(i,PoEpochs(j,1):PoEpochs(j,2)) = 1; % Add in new transient
        end
    end
    p.progress;
end
p.stop; 

save expPosTr.mat expPosTr;

end


