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
%   SegList: A row vector containing the matching segment number for all
%   transients from the previous frame, of the form SegList(cc_object_num)
%   = Segment_num, where cc_object_num is the object number for that frame
%   in cc variable from ExtractBlobs, and Segment_num corresponds to
%   MatchingSeg output from running MatchSeg on previous frame
%
%   distthresh: maximum distance the peak pixel intensity location can move
%   to be considered a valid match.  Suggest using the minor axis length of
%   the neuron
%
% OUTPUTS:
%
%   MatchingSeg: the matching segment from the previous frame, identified 
%   from SegList  
%
%   minidx: the pixel index for the matching blob from the previous frame
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
% d = nan(1,length(oldstats));
% for i = 1:length(oldstats)
%     p2 = oldstats{i}; % Peak location for blob i from previous frame
%     
% %     d(i) = pdist([p1;p2],'euclidean'); % get distance
%     d(i) = sqrt(sum((p1 - p2).^2,2)); % DAVE - suggested change to improve speed.
%   
% end

%WM edit - faster by ~0.001s per iteration of this function, but also more elegant.
p2 = cell2mat(oldstats'); 
d = sqrt(sum((repmat(p1,size(p2,1),1)-p2).^2,2))';

% Locate the closest blob in oldstats and get the distance from its peak
% pixel (mindist) as well as the pixel index (minidx)
[mindist,minidx] = min(d); 

if mindist < distthresh
    % we'll consider this a match since it meet the min distance threshold
    MatchingSeg = SegList(minidx); % Pull the matching segment from the previous frame
else
    % no match found
    MatchingSeg = 0;
end

end

