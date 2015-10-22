function [] = PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist)
%PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist)
figure1 = figure;

if (~exist('clusterlist'))
    clusterlist = 1:length(PixelList)
end

if(~isrow(clusterlist))
    clusterlist = clusterlist';
end

colors = rand(length(clusterlist),3);

for i = 1:length(clusterlist)
    
    temp = zeros(Xdim,Ydim);
    temp(PixelList{i}) = 1;
    b = bwboundaries(temp);
    x{i} = b{1}(:,1);
    x{i} = x{i}+(rand(size(x{i}))-0.5)/2;
    y{i} = b{1}(:,2);
    y{i} = y{i}+(rand(size(y{i}))-0.5)/2;
    plot(y{i},x{i},'Color',colors(clusterlist(i),:));hold on;
end
hold off;
axis equal;
set(gcf,'Position',[1          41        1920         964]);
annotation(figure1,'textbox',...
    [0.397875 0.283929193608964 0.0323333333333334 0.0287368154318838],...
    'String',{'100 µm'},...
    'LineStyle','none',...
    'FitBoxToText','off');

line([140 210.5],[400 400],'LineWidth',5,'Color','k')
end

