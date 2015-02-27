function [MatchingSeg] = MatchSeg(currstat,oldstats,SegList)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (length(oldstats) == 0)
    % no segs on the preceding frame
    MatchingSeg = 0;
    return;
end

% calculate distance
p1 = currstat.Centroid;

for i = 1:length(oldstats)
    p2 = oldstats(i).Centroid;
    d(i) = pdist([p1;p2],'euclidean');
end

[mindist,minidx] = min(d);

if (mindist < currstat.MinorAxisLength)
    % we'll consider this a match
    MatchingSeg = SegList(minidx);
else
    % no match found
    MatchingSeg = 0;
end

end

