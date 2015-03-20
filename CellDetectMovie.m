function [] = CellDetectMovie(infile,out_avifile,FT,NeuronImage,climits)

close all;

for i = 1:length(NeuronImage)
    temp = bwboundaries(NeuronImage{i});
    y{i} = temp{1}(:,1);
    x{i} = temp{1}(:,2);
end

figure;
set(gcf,'Position',[611 102 1079 862]);pause(2);

aviobj = VideoWriter(out_avifile);
aviobj.FrameRate = 4;
open(aviobj);

Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);

frameskip = 5;

frames = 1:frameskip:size(FT,2);

for i = frames
  temp = h5read(infile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
 
  a = find(FT(:,i) > 0);
  imagesc(temp);caxis(climits);colormap gray;
  
  for j = 1:length(x)
      hold on;
      plot(x{j},y{j},'-b','LineWidth',0.5);
  end
  
  for j = 1:length(a)
      hold on;
      plot(x{a(j)},y{a(j)},'-r','LineWidth',3);
  end
  F = getframe;
  writeVideo(aviobj,F);
end
close(gcf);
close(aviobj);
end