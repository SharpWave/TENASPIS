function [T,G] = DetectFSpikes(cell_sig,sr,thresh)
% cell_sig, a NxT matrix of fluorescence values
smwin = hann(sr)/sum(hann(sr));
NumCells = size(cell_sig,1);
smooth_sig = zeros(size(cell_sig));

T = [];
G = [];

for i = 1:NumCells
    tempd = diff(cell_sig(i,:));
    smooth_sig(i,1:end-1) = zscore(convtrim(tempd,smwin));
    %plot(smooth_sig(i,1:end-1));pause;
    temp_epochs = NP_FindSupraThresholdEpochs(smooth_sig(i,:),thresh);
    T = [T;temp_epochs(:,1)];
    G = [G;ones(size(temp_epochs(:,1)))*i];
end

