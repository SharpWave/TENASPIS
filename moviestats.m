function [meanframe,stdframe] = moviestats(file)
%[meanframe,stdframe] = moviestats(file)
[frame,Xdim,Ydim,NumFrames] = loadframe(file,1);
for i = 1:NumFrames
    frame = double(loadframe(file,i));
    meanframe(i) = mean(frame(:));
    stdframe(i) = std(frame(:));
end



end

