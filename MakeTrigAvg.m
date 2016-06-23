function [outdata] = MakeTrigAvg(indata)


NumFrames = size(indata{1},2);
load('ProcOut.mat','Xdim','Ydim');

UseTime = 5;

outdata = cell(1,length(indata));
for k = 1:length(indata)
    NumNeurons = size(indata{k},1);
    clear TrigAvg;
    
    TrigAvg = cell(1,NumNeurons);
    [TrigAvg{:}] = deal(zeros(Xdim,Ydim));
    outdata{k} = TrigAvg;
    
    
    for j = 1:NumNeurons
        ep = NP_FindSupraThresholdEpochs(indata{k}(j,:),eps);
        for i = 1:size(ep,1)
            if ((ep(i,2)-ep(i,1)+1) > UseTime)
                indata{k}(j,ep(i,1):(ep(i,2)-UseTime+1)) = 0;
            end
        end
    end
end

FrameSkip = zeros(1,NumFrames);
for i = 1:NumFrames
    NumN = 0;
    for k = 1:length(indata)
        NumN = NumN + sum(indata{k}(:,i));
    end
    if (NumN == 0)
        FrameSkip(i) = 1;
    end
end

p=ProgressBar(NumFrames);

for i = 1:NumFrames
     if (~FrameSkip(i))
        tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
        for k = 1:length(indata)
            FT = indata{k};
            nlist = find(FT(:,i));
            for j = 1:length(nlist)
                outdata{k}{nlist(j)} = outdata{k}{nlist(j)} + tempFrame;
            end
            % Update progress bar
        end
    end
    p.progress;
end
p.stop;

for k = 1:length(indata)
    for i = 1:size(indata{k},1)
        outdata{k}{i} = outdata{k}{i}./sum(indata{k}(i,:));
    end
end





