function Tenaspis2singlesession()
% Quick & dirty Tenaspis2
% Requires DFF.h5 and SLPDF.h5 be present

%% Extract Blobs
load singlesessionmask.mat;
disp('Extracting blobs...'); 
ExtractBlobs('SLPDF.h5',neuronmask);

%% Connect blobs into transients
disp('Making transients...');
MakeTransients; 
!del InitClu.mat

%% Group together individual transients under individual neurons
disp('Making neurons...'); 
MakeNeurons('min_trans_length',10);

%% Pull traces out of each neuron using the High-pass movie
disp('Normalizing traces...'); 
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
disp('Finalizing...');
DetectGoodSlopes;



end
