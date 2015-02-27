function [] = SpatMovie()
close all;

SR = 20;
Pix2Cm = 0.0675;


[x,y,speed] = GetSpeed(SR,Pix2Cm);

for i = 1:1% load the ICA .mat file, put it in a data structure
    filename = ['Obj_',int2str(i),'_1 - IC filter ',int2str(i),'.mat'];
    load(filename); % loads two things, Index and Object
    IC{i} = Object(1).Data;
end

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

NumSpatBins = 8; % bins per edge
Xedges = (0:NumSpatBins)*(max(x)-min(x))/NumSpatBins+min(x);
Yedges = (0:NumSpatBins)*(max(y)-min(y))/NumSpatBins+min(y);

figure(1);hold on;plot(x,y);
% draw all of the edges
for i = 1:length(Xedges)
    z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z,'Color','r');
    z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z,'Color','r');
end


[counts,Xbin] = histc(x,Xedges);
[counts,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumSpatBins+1))) = NumSpatBins;
Ybin(find(Ybin == (NumSpatBins+1))) = NumSpatBins;

for i = 1:NumSpatBins
    for j = 1:NumSpatBins
        MaxMov{i,j} = zeros(size(IC{1}));
    end
end


for j = 1:length(x)-100;
  j,tempIn = h5read('ICmovie.h5','/Object',[1 1 j 1],[Xdim Ydim 1 1]);  
  tempFrame = double(tempIn);
  if (speed(j) > 5)
    MaxMov{Xbin(j),Ybin(j)} = max(MaxMov{Xbin(j),Ybin(j)},tempFrame);
  end
end
figure(2);
for i = 1:NumSpatBins^2
    subplot(NumSpatBins,NumSpatBins,i);imagesc(MaxMov{i});colormap gray;set(gca,'XTick',[],'YTick',[]);
end

keyboard;