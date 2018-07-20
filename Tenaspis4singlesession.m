function Tenaspis4singlesession(moviefile, param_file_use)
% Quick & dirty Tenaspis4
% Requires singlesessionmask.mat be present for automated runs
% use MakeMaskSingleSession if needed

% REQUIREMENT: first call MakeFilteredMovies on your cropped motion-corrected
% movie

if nargin < 2
    param_file_use = '';
end

dir_use = fileparts(moviefile);
make_mask = exist(fullfile(dir_use,'singlesessionmask.mat'),'file') == 0;
make_movies = exist(fullfile(dir_use,'BPDFF.h5'),'file') == 0;

Set_T_Params(moviefile);
if make_movies
    MakeFilteredMovies(moviefile);
end

if make_mask
    MakeMaskSingleSession('BPDFF.h5');
end

% set global parameter variable
Set_Custom_T_Params('BPDFF.h5', param_file_use);

%% Extract Blobs
load singlesessionmask.mat; % if this isn't already present, make it
ExtractBlobs(neuronmask);

%% Connect blobs into transients
LinkBlobs();
RejectBadTransients();
MakeTransientROIs();

%% Group together individual transients under individual neurons and save data
MergeTransientROIs;
InterpretTraces(false, param_file_use);

