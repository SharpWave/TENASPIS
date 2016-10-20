function [] = Set_T_Params(moviefile);
% function [] = Set_T_Params(moviefile);
%
% Sets Tenaspis parameters.  Must be called at beginning of run
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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

clear T_PARAMS;
global T_PARAMS;

% Get the dimensionality of the movie
info = h5info(moviefile,'/Object');
T_PARAMS.Xdim = info.Dataspace.Size(1);
T_PARAMS.Ydim = info.Dataspace.Size(2);
T_PARAMS.NumFrames = info.Dataspace.Size(3);

% General parameters used by multiple scripts
T_PARAMS.FrameChunkSize = 1250; % Number of frames to load at once for various functions

% ExtractBlobs / SegmentFrame params
T_PARAMS.threshold = 0.01; % Pixel intensity baseline threshold for detecting blobs






end

