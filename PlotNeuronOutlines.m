function [] = PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist,varargin)
%PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist,varargin)
% varargin: 'plot_max_proj',max_proj_tif_path plots the clusters over the
% maximum projection
%
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
% 
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure1 = figure;

for j = 1:length(varargin)
    if strcmpi(varargin{j},'plot_max_proj')
        max_proj = imread(varargin{j+1});
    end
    
    if strcmpi(varargin{j},'cells_to_plot')
        CTP = varargin{j+1};
    end
end

ToPlotCell = zeros(size(clusterlist));
if (exist('CTP','var'))
    ToPlotCell(CTP) = 1;
else
   ToPlotCell = ones(size(clusterlist)); 
end

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
    if(~ToPlotCell(clusterlist(i)))
        continue;
    end
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

