function [meanframe,stdframe] = moviestats(file)
%[meanframe,stdframe] = moviestats(file)
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
[frame,Xdim,Ydim,NumFrames] = loadframe(file,1);
for i = 1:NumFrames
    frame = double(loadframe(file,i));
    meanframe(i) = mean(frame(:));
    stdframe(i) = std(frame(:));
end



end

