function Tenaspis4singlesession()
% Quick & dirty Tenaspis2
% Requires singlesessionmask.mat be present for automated runs
% use MakeMaskSingleSession if needed

% set global parameter variable
Set_T_Params;

% Make the movie files
MakeFilteredMovies();

%% Extract Blobs
load singlesessionmask.mat;
ExtractBlobs('SHPDFF.h5',neuronmask);

%% Connect blobs into transients
LinkBlobs();
RejectBadTransients();
MakeTransientROIs();

%% Group together individual transients under individual neurons
MergeTransientROIs;

%% Pull traces out of each neuron using the High-pass movie
NormalTraces('SLPDF.h5');
MakeROIavg;

load ProcOut.mat;
load ROIavg.mat;
MakeROIcorrtraces(NeuronPixels,Xdim,Ydim,NumFrames,ROIavg);
%% Expand transients
disp('Expanding transients...'); 
ExpandTransients(0);

%% Calculate peak of all transients
AddPoTransients;

%% Determine rising events/on-times for all transients
DetectGoodSlopes;

load ('T2output.mat','FT','NeuronPixels');
for i = 1:2
   indat{1} = FT;
   outdat = MakeTrigAvg(indat);
   MergeROIs(FT,NeuronPixels,outdat{1});
   load ('FinalOutput.mat','FT','NeuronPixels');
end
indat{1} = FT;
outdat = MakeTrigAvg(indat);
MeanT = outdat{1};
save('MeanT.mat', 'MeanT', '-v7.3');
FinalTraces('SLPDF.h5');
