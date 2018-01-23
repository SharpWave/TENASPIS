 function runtime = Tenaspis5singlesession(infile)
% Quick & dirty Tenaspis4
% Requires singlesessionmask.mat be present for automated runs
% use MakeMaskSingleSession if needed

% REQUIREMENT: first call MakeFilteredMovies on your cropped motion-corrected
% movie
tic
% set global parameter variable
Set_T_Params('BPDFF.h5');

% load the movie into RAM
MakeFilteredMovies(infile);

LoadMovie('BPDFF.h5')
%% Extract Blobs
load singlesessionmask.mat; % if this isn't already present, make it
ExtractBlobs(neuronmask);

%% Connect blobs into transients
LinkBlobs();
RejectBadTransients();
MakeTransientROIs();
EditTransientROIs();

%% Group together individual transients under individual neurons and save data
MergeTransientROIs;
load SegmentationROIs.mat;
TraceAnalysis(PixelIdxList,GoodPeakAvg,LPtrace,45,GoodPeaks);
ReduceROIs;
load('Reduced.mat');
TraceAnalysis(PixelIdxList,GoodPeakAvg,LPtrace,45,GoodPeaks);
ReduceROIs;
load('Reduced.mat');
TraceAnalysis(PixelIdxList,GoodPeakAvg,LPtrace,45,GoodPeaks);
ReduceROIs;
DetectCalciumSlopes;
toc

