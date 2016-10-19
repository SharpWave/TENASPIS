function MergeROIs(FT,NeuronPixels,TrigAvgs)
% MergeROIs(FT,NeuronPixels,MeanT)
%
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

%% Set up.
load('ProcOut.mat','Xdim','Ydim');

%Get basic stats and set thresholds. 
[NumNeurons,NumFrames] = size(FT);
OverlapThresh = 0.2;
CorrThresh = 0.2;
CorrpThresh = 0.05;

%t = (1:NumFrames)/20;

%Preallocate. 
ToMerge = zeros(NumNeurons);        %Logical matrix for merging. 
MergeDest = 1:NumNeurons;           %Destination of merge. 
Overlap = zeros(NumNeurons);        %Pixel overlap.
MeanTrigCorr = zeros(NumNeurons);
MeanTrigp = zeros(NumNeurons);
newFT = FT;

%% Determine Merges
display('determining merges');

%Progress bar. 
resol = 5;                                  % Percent resolution for progress bar, in this case 5%
update_inc = round(NumNeurons/(100/resol)); % Get increments for updating ProgressBar
p = ProgressBar(100/resol);

for i = 1:NumNeurons
    for j = 1:NumNeurons
        %Number of overlapping pixels. 
        Overlap(i,j) = length(intersect(NeuronPixels{j},NeuronPixels{i}))./length(union(NeuronPixels{j},NeuronPixels{i}));
        
        if (Overlap(i,j) <= OverlapThresh)  %If not overlapping, skip the below.
            continue;
        end
        
        %Correlate the transient-trigger averages of the pixels in the
        %frame.
        overlapPix = union(NeuronPixels{i},NeuronPixels{j});   %Common pixels.
        [MeanTrigCorr(i,j),MeanTrigp(i,j)] = corr(TrigAvgs{i}(overlapPix),TrigAvgs{j}(overlapPix),'type','Spearman');
        
        %If the correlation meets criteria, earmark it for merging.
        if ((MeanTrigCorr(i,j) > CorrThresh) && (MeanTrigp(i,j) < CorrpThresh) && (i ~= j))
            ToMerge(i,j) = 1;    
        end        
    end
   
    if round(i/update_inc) == (i/update_inc)
        p.progress;
    end
end
p.stop;

NP = NeuronPixels;

%% Do the merging.
display('performing merges');
for i = 1:NumNeurons
    for j = (i+1):NumNeurons
        if (ToMerge(i,j))
            % try to merge j into i
            newDest = MergeDest(i);
            
            %Not sure why this line is ever needed..
            while(newDest ~= MergeDest(newDest))
                newDest = MergeDest(newDest);
            end
            
            %Do the merge. 
            %display(['merging ',int2str(newDest),' ',int2str(j)]);
            NP{newDest} = union(NP{j},NP{newDest});             %Neuron mask.
            newFT(newDest,:) = newFT(newDest,:) | newFT(j,:);   %Trace.
            MergeDest(j) = newDest;
        end
    end
end

%Reset these. 
clear NeuronPixels;
clear FT;

%Assign new values to NeuronPixels, NeuronImage, and FT. .
curr = 1;
for i = 1:NumNeurons
    if (MergeDest(i) == i)
        NeuronPixels{curr} = NP{i};
        NeuronImage{curr} = zeros(Xdim,Ydim);
        NeuronImage{curr}(NP{i}) = 1;
        FT(curr,:) = newFT(i,:);
        curr = curr+1;
    end
end

save('FinalOutput.mat', 'NeuronPixels', 'NeuronImage', 'FT', '-v7.3');

end