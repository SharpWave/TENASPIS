function [outputArg1,outputArg2] = FiltCompare(frame)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


LowThreshList = [1 1.5 2 3 4];

HighThreshList = [5 10 15 20 25];

FWinSize = 51;

[f1,f2] = freqspace(FWinSize,'meshgrid');
r = sqrt(f1.^2+f2.^2);
allax  = [];

figure;
for i = 1:length(LowThreshList)
    for j = 1:length(HighThreshList)
        Hd = ones(FWinSize);
        Hd((r<LowThreshList(i)/(FWinSize-1))|(r>HighThreshList(j)/(FWinSize-1))) = 0;
        h = fsamp2(Hd);
        y{i,j} = imfilter(frame,h,'symmetric');
        ax = subplot(5,5,(i-1)*5+j);
        imagesc(y{i,j});caxis([0 300]);colormap hot;axis image;
        title(['low: ',num2str(LowThreshList(i)),' High: ',num2str(HighThreshList(j))]);
        allax = [allax, ax];

    end    
end

linkaxes(allax,'xy');



