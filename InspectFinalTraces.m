function [ output_args ] = InspectFinalTraces(ICnum,timepoint,IC,x,y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Xdim = size(IC{1},1);
Ydim = size(IC{1},2);

temp2 = h5read('FLmovie.h5','/Object',[1 1 timepoint 1],[Xdim Ydim 1 1]);
figure;
subplot(1,2,1);imagesc(temp2);colormap gray;caxis([0 0.3]);hold on;plot(x{ICnum},y{ICnum},'-r','LineWidth',2);
[frame,cc] = SegmentFrame(temp2);
subplot(1,2,2);imagesc(frame);hold on;plot(x{ICnum},y{ICnum},'-r','LineWidth',2);

end

