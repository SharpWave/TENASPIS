function [outdata] = MakeTrigAvg(indata)


NumFrames = size(indata{1},2);
load('ProcOut.mat','Xdim','Ydim');

outdata = cell(1,length(indata));
for k = 1:length(indata)
    NumNeurons = size(indata{k},1);
    clear TrigAvg;
    
    TrigAvg = cell(1,NumNeurons);
    [TrigAvg{:}] = deal(zeros(Xdim,Ydim));
    outdata{k} = TrigAvg;
end

p=ProgressBar(NumFrames);

for i = 1:NumFrames
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    for k = 1:length(indata)
        FT = indata{k};
        nlist = find(FT(:,i));
        for j = 1:length(nlist)
            outdata{k}{nlist(j)} = outdata{k}{nlist(j)} + tempFrame;
        end
        p.progress; % Update progress bar
    end
    
    
    
end
p.stop;
for k = 1:length(indata)
    for i = 1:size(indata{k},1)
        outdata{k}{i} = outdata{k}{i}./sum(indata{k}(i,:));
    end
end
    
    
    
    
    
