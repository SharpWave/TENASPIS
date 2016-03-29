function [MatchingSeg,minidx] = MatchSeg(currstat,oldstats,SegList,distthresh)
% [MatchingSeg,minidx] = MatchSeg(currstat,oldstats,SegList)
%
% Matches up blobs from frame-to-frame based on current frame stats and old
% frame stats.
%
% INPUTS:
%
%   currstat: Indices for the location of the peak pixel intensity for a
%   given blob obtained from SegmentFrame
%
%   oldstats: same as currstat but for ALL the blobs from the previous
%   frame
%
%   SegList:
%
%   
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

% Initialize variables
minidx = 0; % Index to pixel location with minimum distance from pixel in currstat

if isempty(oldstats)
    % If there are no segments for this blob on the preceding frame, start
    % afresh
    MatchingSeg = 0;
    return;
end

% calculate distance between input blob and all other blobs from previous
% frame
p1 = currstat; % Current blob peak location
d = nan(1,length(oldstats));
for i = 1:length(oldstats)
    p2 = oldstats{i}; % Peak location for blob i from previous frame
    
%     d(i) = pdist([p1;p2],'euclidean'); % get distance
    d(i) = sqrt(sum((p1 - p2).^2,2)); % DAVE - suggested change to improve speed.
  
end

[mindist,minidx] = min(d);

if (mindist < distthresh)
    % we'll consider this a match since it meet the min distance threshold
    MatchingSeg = SegList(minidx);
else
    % no match found
    MatchingSeg = 0;
end

end

