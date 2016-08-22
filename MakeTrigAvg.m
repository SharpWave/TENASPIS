function TrigAvgs = MakeTrigAvg(FTs)
%outdata = MakeTrigAvg(indata)
%
%   Creates spike-triggered average of the imaging frame for each version
%   of FT present in indata.
%
%   INPUT
%       FTs: Cell array of any size, containing FT. 
%
%   OUTPUT
%       TrigAvgs: Cell array of the same size as indata, each containing a
%       cell array, which in turn contains matrices representing the
%       spike-triggered average of imaging frames. 
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

%% Set up. 
NumFrames = size(FTs{1},2);
load('ProcOut.mat','Xdim','Ydim');

%Some threshold.
UseTime = 5;

TrigAvgs = cell(1,length(FTs));
for k = 1:length(FTs)
    %Neurons may have merged as we go down k.
    NumNeurons = size(FTs{k},1);
    
    %Build a new cell array containing spike-triggered average matrices. 
    TrigAvg = cell(1,NumNeurons);
    [TrigAvg{:}] = deal(zeros(Xdim,Ydim));
    
    %Dump into outdata. 
    TrigAvgs{k} = TrigAvg;
    
    %Find large spikes. 
    for j = 1:NumNeurons
        ep = NP_FindSupraThresholdEpochs(FTs{k}(j,:),eps);
        for i = 1:size(ep,1)
            %If epoch is larger than UseTime...
            if ((ep(i,2)-ep(i,1)+1) > UseTime)       
                %Cross out the last 5 spikes. Not sure why this is
                %happening...
                FTs{k}(j,ep(i,1):(ep(i,2)-UseTime+1)) = 0;
            end
        end
    end
end

%Determine which frames to skip.
activeNeurons = zeros(1,NumFrames);
for i = 1:NumFrames
    for k = 1:length(FTs)
        %Number of active neurons on this frame. 
        activeNeurons(i) = activeNeurons(i) + sum(FTs{k}(:,i));
    end 
end

%Frames with no active neurons. 
FrameSkip = activeNeurons==0;

%Vector of frames with at least 1 active neuron. 
goodFrames = 1:NumFrames;
goodFrames = goodFrames(~FrameSkip);

%% Spike-triggered average.
moviefile = 'SLPDF.h5';
info = h5info(moviefile,'/Object');

%For each frame...
resol = 5;                                  % Percent resolution for progress bar, in this case 5%
update_inc = round(NumFrames/(100/resol));  % Get increments for updating ProgressBar
p = ProgressBar(100/resol);
for i = goodFrames
    tempFrame = loadframe(moviefile,i,info);
    for k = 1:length(FTs)
        %Grab FT. 
        FT = FTs{k};

        %Active neurons. 
        nlist = find(FT(:,i));
        for j = nlist'
            %Sum frame for active neuron. 
            TrigAvgs{k}{j} = TrigAvgs{k}{j} + tempFrame;
        end        
    end
    
    if round(i/update_inc) == (i/update_inc)
        p.progress;
    end
end
p.stop;

%Normalize by number of spikes. 
for k = 1:length(FTs)
    nSpikes = sum(FTs{k},2)';
    TrigAvgs{k} = cellfun(@(x,y) x./y, TrigAvgs{k},num2cell(nSpikes),'unif',0);
end

end