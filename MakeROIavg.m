function [ output_args ] = MakeROIavg()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load ProcOut.mat;

for i = 1:NumNeurons
    ROIavg{i} = zeros(Xdim,Ydim);
end

p=ProgressBar(NumFrames);

for i = 1:NumFrames
    tempFrame = h5read('SLPDF.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    nlist = find(FT(:,i));
    for j = 1:length(nlist)
        ROIavg{nlist(j)} = ROIavg{nlist(j)} + tempFrame;
    end
    p.progress; % Update progress bar
end

p.stop;

for i = 1:NumNeurons
    ROIavg{i} = ROIavg{i}./sum(FT(i,:));
end

save ROIavg.mat ROIavg;

