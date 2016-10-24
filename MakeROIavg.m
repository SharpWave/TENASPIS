function MakeROIavg(moviefile)
%MakeROIavg(moviefile)
%
%   Finds the average spike-triggered frame still for each neuron based
%   on FT from ProcOut.

%% MakeROIavg
load('ProcOut.mat','NumNeurons','FT');

info = h5info(moviefile,'/Object');
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

ROIavg = cell(1,NumNeurons); 
[ROIavg{:}] = deal(zeros(Xdim,Ydim));
NumFrames = size(FT,2);

resol = 1; % Percent resolution for progress bar, in this case 10%
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
p = ProgressBar(100/resol);
%For each frame..
for i = 1:NumFrames
    %Grab the frame from SLPDF.h5. 
    tempFrame = loadframe(moviefile,i,info);
    
    %Get active neurons. 
    nlist = find(FT(:,i));
    
    %Sum frames where that neuron was active to later divide. 
    for j = nlist'
        ROIavg{j} = ROIavg{j} + tempFrame;
    end
    
    % Update progress bar
    if round(i/update_inc) == (i/update_inc)
        p.progress;
    end
end
p.stop;

%Divide summed ROI frames by number of spikes.
nSpikes = sum(FT,2)';    %Number of transients per neuron. 
cellfun(@(x,y) x./y, ROIavg, num2cell(nSpikes),'unif',0);

save('ROIavg.mat','ROIavg','-v7.3');

