function [frame,Xdim,Ydim,NumFrames] = loadframe(file,framenum,h5_size_info)
% [frame,Xdim,Ydim,NumFrames] = loadframe(file,framenum,...)
%
% Loads a frame from an h5 file
%
% INPUTS:
%   file: fullpath to h5 file
%
%   framenum: frame number of file to load
%
%   h5_size_info (optional): data structure obtained by running info =
%   h5info(file,'/Object') on the movie beforehand.  Will save lots of time
%   if you are loading many frames, not necessary for loading small numbers
%   of frames.
%
% OUTPUTS:
%   frame: an array of the frame you loaded
%
%   Xdim, Ydim, NumFrames: movie size info obtained using h5info.
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

% Pull info about video file
if nargin < 3
    info = h5info(file,'/Object');
else
    info = h5_size_info;
end
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

frame = h5read(file,'/Object',[1 1 framenum 1],[Xdim Ydim 1 1]);

end