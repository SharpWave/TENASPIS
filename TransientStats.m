function [DistTrav,MeanThresh] = TransientStats(SegChain)
% [DistTrav,MeanThresh] = TransientStats(SegChain)
%
% Gets statistics on each Transient identified in SegChain
%
% INPUTS:
% 
%   SegChain: see help for MakeTransients
%
% OUTPUTS:
%   
%   DistTrav: Absolute (not cumulative) distance traveled by the transient
%   from start to finish
%
%   MeanThresh: mean threshold of the transient
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

% Load needed cc variable
load('Blobs.mat','cc','PeakPix','ThreshList');

%% Calculate distance traveled for each transient
DistTrav = nan(1,length(SegChain));
MeanThresh = nan(1,length(SegChain));

disp('Calculating statistics for all transients')

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(length(SegChain)/(100/resol)); % Get increments for updating ProgressBar

for i = 1:length(SegChain)
    
    % Update progressbar
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
    
    if length(SegChain{i}) > 1
        Xc = []; Yc = []; thresh = [];
        for j = [1,length(SegChain{i})]
            % for each frame in the transient
            frame = SegChain{i}{j}(1);
            seg = SegChain{i}{j}(2);
            
            % Grab cc variable for appropriate frame and make it small.
            cc_use = cc{frame};
            cc_use.PixelIdxList = cc{frame}.PixelIdxList(seg);
            cc_use.NumObjects = 1;
            
            % Get centroid location and parse out into x and y
            r = regionprops(cc_use,'Centroid');
            Xc(j) = r.Centroid(1);
            Yc(j) = r.Centroid(2);
            
            % Get threshold
        end
        
        for j = 1:length(SegChain{i})
            frame = SegChain{i}{j}(1);
            seg = SegChain{i}{j}(2);    
            thresh(j) = ThreshList{frame}(seg);
        end
        
        DistTrav(i) = sqrt((Xc(end)-Xc(1))^2+(Yc(end)-Yc(1))^2);
        MeanThresh(i) = mean(thresh);
        
    elseif length(SegChain{i}) == 1 % Avoid doing any of the above if there is only one frame in the segment
        DistTrav(i) = 0;
        frame = SegChain{i}{1}(1);
        seg = SegChain{i}{1}(2);
        MeanThresh(i) = ThreshList{frame}(1);
    end

end
p.stop;

%% Debugging code

% keyboard;
% % BrowseThrough
% for i = 1:NumSegments
%     subplot(1,2,1);plot(Ac{i});xlabel('frame');ylabel('area of blob')'
%     subplot(1,2,2);plot(Xc{i},Yc{i});xlabel('x centroid');ylabel('y centroid');
%     set(gca,'Xlim',[0 Xdim],'Ylim',[0 Ydim])
%     pause;
% end
% keyboard;

end

