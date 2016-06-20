function [TrigAvg] = MakeTrigAvg(FT)

NumNeurons = size(FT,1);
NumFrames = size(FT,2);
load('ProcOut.mat','Xdim','Ydim');

for i = 1:NumNeurons
    TrigAvg{i} = zeros(Xdim,Ydim);
end

p=ProgressBar(NumFrames);

for i = 1:NumFrames
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    nlist = find(FT(:,i));
    for j = 1:length(nlist)
        TrigAvg{nlist(j)} = TrigAvg{nlist(j)} + tempFrame;
    end
    p.progress; % Update progress bar
end

p.stop;

for i = 1:NumNeurons
    TrigAvg{i} = TrigAvg{i}./sum(FT(i,:));
end





