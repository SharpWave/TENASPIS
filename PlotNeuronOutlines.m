function [x, y, color_use] = PlotNeuronOutlines(varargin)
% [x, y, color_use] = PlotNeuronOutlines(PixelList,Xdim,Ydim,clusterlist,varargin)
%
% Plots outlines of each neuron's transients in the same color.
%
% INPUTS:
% 
%   PixelList: InitPixelList from ProcOut.mat
%
%   Xdim, Ydim: dimensions of the imaging movie frames
%
%   clusterlist: cTon variable created in MakeNeurons and saved under
%   ProcOut.mat.  Size of first dimention must match the length of
%   PixelList
%
%   varargins: 
%       'plot_max_proj',max_proj_tif_path plots the clusters over the
%       maximum projection. Does not need to be followed by any argument
%
%       'cells_to_plot': provides an array of cells to plot.  Default =
%       plot all.
%
%       'plot_handle': If provided and followed by a figure handle to an
%       existing figure or axes, will plot to that. Note that this disables
%       the plotting of a scale bar. Default = create new figure. 
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

load ('TransientROIs.mat','PixelIdxList');
load ('SegmentationROIs.mat','NeuronPixelIdxList','NeuronROIidx','NeuronImage','Trans2ROI');
load MovieDims.mat;
clusterlist = Trans2ROI;
PixelList = PixelIdxList;

%% Process varargins
new_fig = 1; % default - plots to new figure
for j = 1:length(varargin)
    if strcmpi(varargin{j},'plot_max_proj')
        max_proj = imread(varargin{j+1});
    end
    
    if strcmpi(varargin{j},'cells_to_plot')
        CTP = varargin{j+1};
    end
    
    if strcmpi(varargin{j},'plot_handle')
        new_fig = 0;
        h_use = varargin{j+1};
    end
end

% Create new figure and get handle if fig_handle is not specified in
% varargin
if new_fig == 1
    figure1 = figure;
elseif new_fig == 0
    axes(h_use); % Set axes for plotting
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

%% Start plotting transients by neuron

colors = rand(length(clusterlist),3);

x = cell(1,length(clusterlist));
y = cell(1,length(clusterlist));
color_use = zeros(length(clusterlist),3);
% Initialize ProgressBar
resol = 10; % Percent resolution for progress bar
p = ProgressBar(resol);
update_inc = round(length(clusterlist)/resol); % Get increments for updating ProgressBar
for i = 1:length(clusterlist)
    
    if(~ismember(clusterlist(i),NeuronROIidx))
        continue;
    end
    
    % Update progress bar at set increment
    if round(i/update_inc) == (i/update_inc)
        p.progress; 
    end
    % Don't plot cluster if not in clusterlist
    if(~ToPlotCell(clusterlist(i)))
        continue;
    end
    
    % Plotting code
    temp = zeros(Xdim,Ydim);
    temp(PixelList{i}) = 1;
    b = bwboundaries(temp,'noholes'); % Get cluster boundary
    x{i} = b{1}(:,1);
    x{i} = x{i}+(rand(size(x{i}))-0.5)/2;
    y{i} = b{1}(:,2);
    y{i} = y{i}+(rand(size(y{i}))-0.5)/2;
    plot(y{i},x{i},'Color',colors((clusterlist(i)),:));hold on;

end
p.stop;

for i = 1:length(NeuronImage)
    b = bwboundaries(NeuronImage{i},'noholes');
    xn = b{1}(:,1);
    yn = b{1}(:,2);
    plot(yn,xn,'Color',colors(NeuronROIidx(i),:),'LineWidth',4);hold on;
end
hold off;
axis image;

%% Plot scale bar if a new handle is not specified
if new_fig == 1
    set(gcf,'Position',[1          41        1920         964]);
    annotation(figure1,'textbox',...
        [0.397875 0.283929193608964 0.0323333333333334 0.0287368154318838],...
        'String',{'100 µm'},...
        'LineStyle','none',...
        'FitBoxToText','off');
    
    line([140 210.5],[400 400],'LineWidth',5,'Color','k')
end

%% Old code 
% figure
% for i = 1:length(NeuronImage)
%     b = bwboundaries(NeuronImage{i});
%     plot(b{1}(:,2),b{1}(:,1),'Color',colors(i,:));hold on
% end
end

