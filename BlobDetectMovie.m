function [] = BlobDetectMovie(infile,out_avifile,cc,climits)

close all;



figure;
set(gcf,'Position',[611 102 1079 862]);pause(2);

aviobj = VideoWriter(out_avifile);
aviobj.FrameRate = 40;
open(aviobj);

for i = 1:length(cc)
  [frame,Xdim,Ydim,NumFrames] = loadframe(infile,i); 
  imagesc(frame);caxis(climits);colormap gray;
  x = [];
  y = [];
  
  for j = 1:length(cc{i}.PixelIdxList)
      temp = zeros(Xdim,Ydim);
      temp(cc{i}.PixelIdxList{j}) = 1;
      b = bwboundaries(temp);
      y{j} = b{1}(:,1);
      x{j} = b{1}(:,2);
  end
  
  for j = 1:length(x)
      hold on;
      plot(x{j},y{j},'-r','LineWidth',3);
  end

  F = getframe;
  writeVideo(aviobj,F);hold off;
end
close(gcf);
close(aviobj);
end