function Tenaspis4singlesession()
% Quick & dirty Tenaspis4 - must be in directory with imaging movie.
% Requires singlesessionmask.mat be present for automated runs
% use MakeMaskSingleSession if needed

% REQUIREMENT: first call MakeFilteredMovies on your cropped motion-corrected
% movie

if ~exist('BPDFF.h5','file')
    [filename, pathname] = uigetfile({'*.h5;*.tif;*.tiff'}, ...
        'Pick an imaging file:');
    MakeFilteredMovies(fullfile(filename,pathname));
end

% set global parameter variable
Set_T_Params('BPDFF.h5');

%% Extract Blobs
load singlesessionmask.mat; % if this isn't already present, make it
ExtractBlobs(neuronmask);

%% Connect blobs into transients
LinkBlobs();
RejectBadTransients();
MakeTransientROIs();

%% Group together individual transients under individual neurons and save data
MergeTransientROIs;
InterpretTraces();

