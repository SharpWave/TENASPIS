function [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim, PeakPix, min_trans_length)
% [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim)
%
% Initial shot at stringing together transients from all Segments
% identified in MakeTransients
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

% If min_trans_length is not specified, set it as default (5).
if ~exist('min_trans_length','var')
    min_trans_length = 5;
end

GoodTr = zeros(1,NumSegments);

%% Create segment averages
disp('Initializing Clusters')

PixelList = cell(1,NumSegments); 
Xcent = zeros(1,NumSegments); 
Ycent = zeros(1,NumSegments); 
frames = cell(1,NumSegments); 
PixelAvg = cell(1,NumSegments); 

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumSegments/(100/resol)); % Get increments for updating ProgressBar
parfor i = 1:NumSegments
    %display(['initializing transient # ',int2str(i)]);
    [PixelList{i},Xcent(i),Ycent(i),~,frames{i},PixelAvg{i}] = AvgTransient(SegChain{i},cc,Xdim,Ydim,PeakPix);
    %length(SegChain{i})
    
    GoodTr(i) = ~isempty(PixelList{i}); % If trace has valid active pixels, keep
   
    % Update ProgressBar
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
    
end
p.stop; % Terminate progress bar

%edit out the faulty segments
GoodTrs = find(GoodTr);
PixelList = PixelList(GoodTrs);
Xcent = Xcent(GoodTrs);
Ycent = Ycent(GoodTrs);
%MeanArea = MeanArea(GoodTrs);
frames = frames(GoodTrs);
PixelAvg = PixelAvg(GoodTrs);

c = (1:length(frames))'; 

% Updates cluster statistics for newly merged clusters
[PixelList,PixelAvg,meanareas,meanX,meanY,NumEvents] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,PixelAvg,Xcent,Ycent,frames);

save InitClu.mat c Xdim Ydim PixelList Xcent Ycent frames meanareas meanX meanY NumFrames NumEvents PixelAvg min_trans_length -v7.3;

    

end

