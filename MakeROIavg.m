function MakeROIavg()
load('ProcOut.mat','Xdim','Ydim','NumNeurons','FT');

ROIavg = cell(1,NumNeurons); 
[ROIavg{:}] = deal(zeros(Xdim,Ydim));

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

cellfun(@(x,y) x./y, ROIavg, num2cell(sum(FT,2)),'unif',0)

save ROIavg.mat ROIavg;

