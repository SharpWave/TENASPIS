function [] = PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist,varargin)
%PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist)
% varargin: 'plot_max_proj',max_proj_tif_path plots the clusters over the
% maximum projection

for j = 1:length(varargin)
    if strcmpi(varargin{j},'plot_max_proj')
        max_proj = imread(varargin{j+1});
    end
end
figure;

% Plot maximum projection if indicated
if exist('max_proj','var')
    imagesc_gray(max_proj);
    hold on
end

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
end

