function [ output_args ] = Calc_pPeak()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
load('ProcOut.mat','NeuronPixels','NumNeurons','FT','NumFrames');

for i = 1:NumNeurons
    pPeak{i} = zeros(size(NeuronPixels{i}));
    mRank{i} = zeros(size(NeuronPixels{i}));
end

for i = 1:NumFrames
    i
    ActiveN = find(FT(:,i));
    [frame] = loadframe('DFF.h5',i);
    for j = 1:length(ActiveN)
        idx = ActiveN(j);
        [val,maxid] = max(frame(NeuronPixels{idx}));
        pPeak{idx}(maxid) = pPeak{idx}(maxid) + 1;
        
        [val,srtidx] = sort(frame(NeuronPixels{idx}));
        for k = 1:length(srtidx)
            mRank{idx}(srtidx(k)) = mRank{idx}(srtidx(k))+k;
        end
    end
end

for i = 1:NumNeurons
    pPeak{i} = pPeak{i}./sum(FT(i,:));
    mRank{i} = mRank{i}./sum(FT(i,:))./length(NeuronPixels{i});
end

for i = 1:NumFrames
    display(['rankscoring ',int2str(i)]);
    [frame] = loadframe('DFF.h5',i);
    for j = 1:NumNeurons
      [val,srtidx] = sort(frame(NeuronPixels{j}));
      tempRank = [];
       for k = 1:length(srtidx)
            tempRank(srtidx(k)) = k;
       end
       tempRank = tempRank./length(NeuronPixels{j});
       %size(mRank{j}),size(tempRank),
       RankDiff(j,i) = abs(mean(mRank{j}-tempRank'));
    end
end

save pPeak.mat pPeak mRank RankDiff;

end

