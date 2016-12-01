function Tenaspis4testing()
% Quick & dirty Tenaspis2
% Requires singlesessionmask.mat be present for automated runs
% use MakeMaskSingleSession if needed

% REQUIREMENT: first call MakeFilteredMovies on your cropped motion-corrected
% movie

% set global parameter variable
Set_T_Params('BPDFF.h5');

%% Extract Blobs
%load singlesessionmask.mat; % if this isn't already present, make it

[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
neuronmask = ones(Xdim,Ydim);
ExtractBlobs(neuronmask);

%% Connect blobs into transients
LinkBlobs();
RejectBadTransients();
MakeTransientROIs();

%% Group together individual transients under individual neurons and save data
MergeTransientROIs;
InterpretTraces();

