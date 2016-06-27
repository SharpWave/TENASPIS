function outdata = MakeTrigAvg(indata)
%outdata = MakeTrigAvg(indata)
%
%   Creates spike-triggered average of the imaging frame for each version
%   of FT present in indata.
%
%   INPUT
%       indata: Cell array of any size, containing FTs. 
%
%   OUTPUT
%       outdata: Cell array of the same size as indata, each containing a
%       cell array, which in turn contains matrices representing the
%       spike-triggered average of imaging frames. 
%

%% Set up. 
NumFrames = size(indata{1},2);
load('ProcOut.mat','Xdim','Ydim');

%Some threshold.
UseTime = 5;

outdata = cell(1,length(indata));
for k = 1:length(indata)
    %Neurons may have merged as we go down k.
    NumNeurons = size(indata{k},1);
    
    %Build a new cell array containing spike-triggered average matrices. 
    TrigAvg = cell(1,NumNeurons);
    [TrigAvg{:}] = deal(zeros(Xdim,Ydim));
    
    %Dump into outdata. 
    outdata{k} = TrigAvg;
    
    %Find large spikes. 
    for j = 1:NumNeurons
        ep = NP_FindSupraThresholdEpochs(indata{k}(j,:),eps);
        for i = 1:size(ep,1)
            %If epoch is larger than UseTime...
            if ((ep(i,2)-ep(i,1)+1) > UseTime)       
                %Cross out the last 5 spikes. Not sure why this is
                %happening...
                indata{k}(j,ep(i,1):(ep(i,2)-UseTime+1)) = 0;
            end
        end
    end
end

%Determine which frames to skip.
activeNeurons = zeros(1,NumFrames);
for i = 1:NumFrames
    for k = 1:length(indata)
        %Number of active neurons on this frame. 
        activeNeurons(i) = activeNeurons(i) + sum(indata{k}(:,i));
    end 
end

%Frames with no active neurons. 
FrameSkip = activeNeurons==0;

%Vector of frames with at least 1 active neuron. 
goodFrames = 1:NumFrames;
goodFrames = goodFrames(~FrameSkip);

%% Spike-triggered average.
%For each frame...
p=ProgressBar(NumFrames);
for i = goodFrames
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    for k = 1:length(indata)
        %Grab FT. 
        FT = indata{k};

        %Active neurons. 
        nlist = find(FT(:,i));
        for j = nlist'
            %Sum frame for active neuron. 
            outdata{k}{j} = outdata{k}{j} + tempFrame;
        end        
    end
    p.progress;
end
p.stop;

%Normalize by number of spikes. 
for k = 1:length(indata)
    nSpikes = sum(indata{k},2)';
    outdata{k} = cellfun(@(x,y) x./y, outdata{k},num2cell(nSpikes),'unif',0);
end

end



