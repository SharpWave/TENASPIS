function [] = MovieTripleCompare(infile1,infile2,infile3,out_avifile,FT,NeuronImage,climits)

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
    temp = h5read(infile1,'/Object',[1 1 randframe 1],[Xdim Ydim 1 1]);
    mf(i) = mean(double(temp(:)));
    sf(i) = std(double(temp(:)));
    
    up1(i) = PercentileCutoff(temp,99.9);
    down1(i) = PercentileCutoff(temp,0.1);
end

mmf = mean(mf);
msf = mean(sf);

for i = 1:rangetests
    randframe = ceil(rand(1,1)*(size(FT,2)-50)+50);
    temp = h5read(infile2,'/Object',[1 1 randframe 1],[Xdim Ydim 1 1]);
    mf2(i) = mean(double(temp(:)));
    sf2(i) = std(double(temp(:)));
    
    up2(i) = PercentileCutoff(temp,99.9);
    down2(i) = PercentileCutoff(temp,0.1);
end

mmf2 = mean(mf2);
msf2 = mean(sf2);

for i = 1:rangetests
    randframe = ceil(rand(1,1)*(size(FT,2)-50)+50);
    temp = h5read(infile3,'/Object',[1 1 randframe 1],[Xdim Ydim 1 1]);
    mf3(i) = mean(double(temp(:)));
    sf3(i) = std(double(temp(:)));
    
    
    up3(i) = PercentileCutoff(temp,99.9);
    down3(i) = PercentileCutoff(temp,0.1);
end

mmf3 = mean(mf3);
msf3 = mean(sf3);

for i = frames
  temp1 = double(h5read(infile1,'/Object',[1 1 min(i+10,size(FT,2)) 1],[Xdim Ydim 1 1]));
  %temp1 = (temp1-mmf)./msf;
  temp1 = (temp1-mean(down1))./(mean(up1)-mean(down1));
  
  temp2 = double(h5read(infile2,'/Object',[1 1 i 1],[Xdim Ydim 1 1]));
  %temp2 = (temp2-mmf2)./msf2;
  temp2 = (temp2-mean(down2))./(mean(up2)-mean(down2));
  
  temp3 = double(h5read(infile3,'/Object',[1 1 i 1],[Xdim Ydim 1 1]));
  %temp3 = (temp3-mmf3)./msf3;
  temp3 = (temp3-mean(down3))./(mean(up3)-mean(down3));
  
  a = find(FT(:,i) > 0);
  imagesc([temp1,temp2,temp3]);caxis(climits);colormap gray;axis equal;axis off;
  
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