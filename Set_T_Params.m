function [] = Set_T_Params(moviefile);

% Master parameter file for Tenaspis
% Sets a global variable with all parameters, including session variables
global T_PARAMS;

% Get the dimensionality of the movie
info = h5info(moviefile,'/Object');
T_PARAMS.Xdim = info.Dataspace.Size(1);
T_PARAMS.Ydim = info.Dataspace.Size(2);
T_PARAMS.NumFrames = info.Dataspace.Size(3);

% General parameters used by multiple scripts
T_PARAMS.FrameChunkSize = 1250; % Number of frames to load at once for various functions





end

