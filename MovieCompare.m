function [] = MovieCompare(infile1,infile2,out_avifile,FT,NeuronImage,climits)

close all;

for i = 1:length(NeuronImage)
    temp = bwboundaries(NeuronImage{i});
    y{i} = temp{1}(:,1);
    x{i} = temp{1}(:,2);
end

load CC.mat;

figure;
set(gcf,'Position',[534 72 1171 921]);

aviobj = VideoWriter(out_avifile);
aviobj.FrameRate = 20;
open(aviobj);

Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);

frameskip = 1;

frames = 1:frameskip:size(FT,2);

rangetests = 20;

for i = 1:rangetests
    randframe = ceil(rand(1,1)*(size(FT,2)-50)+50);
    temp = h5read(infile2,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    mf(i) = mean(double(temp(:)));
    sf(i) = std(double(temp(:)));
end

mmf = mean(mf);
msf = mean(sf);



for i = frames
  temp1 = h5read(infile1,'/Object',[1 1 min(i+10,size(FT,2)) 1],[Xdim Ydim 1 1]);
  temp2 = h5read(infile2,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
  
  a = find(FT(:,i) > 0);
  imagesc([temp1,(double(temp2)-mmf)/msf*climits(2)/2]);caxis(climits);colormap gray;axis equal;axis off;
  
%   for j = 1:length(x)
%       hold on;
%       plot(x{j},y{j},'-b','LineWidth',0.5);
%   end
%   
%   for j = 1:length(a)
%       hold on;
%       plot(x{a(j)},y{a(j)},'-r','LineWidth',3);
%   end
%   
%   xg = [];
%   yg = [];
%   
%   for j = 1:length(cc{i}.PixelIdxList)
%       temp = zeros(Xdim,Ydim);
%       temp(cc{i}.PixelIdxList{j}) = 1;
%       b = bwboundaries(temp);
%       yg{j} = b{1}(:,1);
%       xg{j} = b{1}(:,2);
%   end
%   
%   for j = 1:length(xg)
%       hold on;
%       plot(xg{j},yg{j},'-g','LineWidth',1);
%   end
  F = getframe(gcf);
  writeVideo(aviobj,F);
  clear F;
  clf;
end
close(gcf);
close(aviobj);
end