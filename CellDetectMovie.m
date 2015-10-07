function [] = CellDetectMovie(infile,out_avifile,FT,NeuronImage,climits)

close all;

for i = 1:length(NeuronImage)
    temp = bwboundaries(NeuronImage{i});
    y{i} = temp{1}(:,1);
    x{i} = temp{1}(:,2);
end

load CC.mat;

figure1 = figure;
set(gcf,'Position',[1          41        1920         964]);

aviobj = VideoWriter(out_avifile,'MPEG-4');
aviobj.FrameRate = 20;
open(aviobj);

Xdim = size(NeuronImage{1},1);
Ydim = size(NeuronImage{1},2);

frameskip = 1;

frames = 1:frameskip:size(FT,2);

for i = frames
  temp = h5read(infile,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
 
  a = find(FT(:,i) > 0);
  imagesc(temp);caxis(climits);colormap gray;
  
%   for j = 1:length(x)
%       hold on;
%       plot(x{j},y{j},'-b','LineWidth',0.5);
%   end
  
  for j = 1:length(a)
      hold on;
      plot(x{a(j)},y{a(j)},'-r','LineWidth',3);
  end
  
  xg = [];
  yg = [];
  
  for j = 1:length(cc{i}.PixelIdxList)
      temp = zeros(Xdim,Ydim);
      temp(cc{i}.PixelIdxList{j}) = 1;
      b = bwboundaries(temp);
      yg{j} = b{1}(:,1);
      xg{j} = b{1}(:,2);
  end
  
  for j = 1:length(xg)
      hold on;
      plot(xg{j},yg{j},'-g','LineWidth',1);
  end
  axis equal;
  axis off;
  
  line([140 210.5],[400 400],'LineWidth',5,'Color','k')
% Create textbox
tempobj = annotation(figure1,'textbox',...
    [0.6994375 0.171161826251701 0.0515624986185382 0.0280082982296271],...
    'String',{['t = ',num2str(round(i/20)),' seconds']},...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.397875 0.283929193608964 0.0323333333333334 0.0287368154318838],...
    'String',{'100 µm'},...
    'LineStyle','none',...
    'FitBoxToText','off');

  F = getframe(gcf);
  writeVideo(aviobj,F);
  clear F;
  
  clf;
end
close(gcf);
close(aviobj);
end