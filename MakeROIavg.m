function MakeROIavg()
load('ProcOut.mat','Xdim','Ydim','NumNeurons','FT');

ROIavg = cell(1,NumNeurons); 
[ROIavg{:}] = deal(zeros(Xdim,Ydim));
NumFrames = size(FT,2);
p=ProgressBar(NumFrames);

for i = 1:NumFrames
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    nlist = find(FT(:,i));
    for j = nlist'
        ROIavg{j} = ROIavg{j} + tempFrame;
    end
    p.progress; % Update progress bar
end

p.stop;

%Divide summed ROI frames by number of spikes.
nSpikes = sum(FT,2);    %Number of transients per neuron. 
for i = 1:NumNeurons
    ROIavg{i} = ROIavg{i}./sum(FT(i,:));
end


save ROIavg.mat ROIavg;

