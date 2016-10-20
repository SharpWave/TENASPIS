function [frames] = LoadFrames(file,framenums)
% [frame,Xdim,Ydim,NumFrames] = loadframe(file,framenum,...)
%
% Loads a frame from an h5 file
%
% INPUTS:
%   file: fullpath to h5 file
%
%   framenum: frame number of file to load
%
% OUTPUTS:
%   frame: an array of the frame you loaded
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

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

fmap = zeros(1,max(framenums));
fmap(framenums) = 1;
fep = NP_FindSupraThresholdEpochs(fmap,eps,0);
loadchunks = [];

% find sets of consecutive frames in framenums
for i = 1:size(fep,1)
    chunksize = fep(i,2)-fep(i,1)+1;
    loadchunks(i,1:2) = [fep(i,1),chunksize];
end

curr = 1;
% load the frames
for i = 1:size(fep,1)
  frames(:,:,curr:(curr+loadchunks(i,2)-1)) = h5read(file,'/Object',[1 1 loadchunks(i,1) 1],[Xdim Ydim loadchunks(i,2) 1]);
  curr = curr+loadchunks(i,2);
end