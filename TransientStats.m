function [DistTrav] = TransientStats(SegChain)
% [DistTrav] = TransientStats(SegChain)
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
load('Blobs.mat','cc','PeakPix');

%% Calculate distance traveled for each transient
DistTrav = nan(1,length(SegChain));
Xc = cell(1,length(SegChain));
Yc = cell(1,length(SegChain)); 
disp('Calculating statistics for all transients')
% p = ProgressBar(length(SegChain));
for i = 1:length(SegChain)
    % for each transient
    
    if length(SegChain{i}) > 1
        Xc = []; Yc = [];
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
            
        end
        
        DistTrav(i) = sqrt((Xc(end)-Xc(1))^2+(Yc(end)-Yc(1))^2);
    
    elseif length(SegChain{i}) == 1 % Avoid doing any of the above if there is only one frame in the segment
        DistTrav(i) = 0;
    end

end

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

