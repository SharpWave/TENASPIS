function [] = MakeSegments(file,cc )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

NumSegments = 0;
SegChain = [];
SegList = zeros(NumFrames,100);

for i = 2:NumFrames
    i
    stats = regionprops(cc{i},'all');
    oldstats = regionprops(cc{i-1},'all');
    for j = 1:cc{i}.NumObjects
        % find match
        [MatchingSeg] = MatchSeg(stats(j),oldstats,SegList(i-1,:));
        if (MatchingSeg == 0)
            % no match found, make a new segment
            NumSegments = NumSegments+1;
            SegChain{NumSegments} = {[i,j]};
            SegList(i,j) = NumSegments;
        else
            % a match was found, add to segment
            SegChain{MatchingSeg} = [SegChain{MatchingSeg},{[i,j]}];
            SegList(i,j) = MatchingSeg;
        end
    end
end

save Segments.mat NumSegments SegChain SegList cc NumFrames Xdim Ydim
end

