function Calc_pPeak()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
load('ProcOut.mat','NeuronPixels','NumNeurons','NumFrames');
load ExpTransients.mat;

FT = PosTr;

pPeak = cell(1,NumNeurons); 
mRank = cell(1,NumNeurons);
for i = 1:NumNeurons
    pPeak{i} = zeros(size(NeuronPixels{i}));
    mRank{i} = zeros(size(NeuronPixels{i}));
end

p = ProgressBar(NumFrames);
display('Calculating ranks and peaks...');

info = h5info('SLPDF.h5','/Object');
for i = 1:NumFrames
    ActiveN = find(FT(:,i));

    frame = loadframe('SLPDF.h5',i,info);

    for j = 1:length(ActiveN)
        idx = ActiveN(j);
        [~,maxid] = max(frame(NeuronPixels{idx}));
        pPeak{idx}(maxid) = pPeak{idx}(maxid) + 1;
        
        [~,srtidx] = sort(frame(NeuronPixels{idx}));
        for k = 1:length(srtidx)
            mRank{idx}(srtidx(k)) = mRank{idx}(srtidx(k))+k;
        end
    end

    p.progress;
end
p.stop;

for i = 1:NumNeurons
    pPeak{i} = pPeak{i}./sum(FT(i,:));
    mRank{i} = mRank{i}./sum(FT(i,:))./length(NeuronPixels{i});
end

% for i = 1:NumFrames
%     [frame] = loadframe('SLPDF.h5',i);
%     for j = 1:NumNeurons
%       [val,srtidx] = sort(frame(NeuronPixels{j}));
%       tempRank = [];
%        for k = 1:length(srtidx)
%             tempRank(srtidx(k)) = k;
%        end
%        tempRank = tempRank./length(NeuronPixels{j});
%        %size(mRank{j}),size(tempRank),
%        RankDiff(j,i) = abs(mean(mRank{j}-tempRank'));
%     end
% end

save pPeak.mat pPeak mRank;% RankDiff;

end

