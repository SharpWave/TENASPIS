function Tenaspis2singlesession()
% Quick & dirty Tenaspis2
% Requires DFF.h5 and SLPDF.h5 be present

%% Extract Blobs
load singlesessionmask.mat;
disp('Extracting blobs...'); 
%ExtractBlobs('DFF.h5',neuronmask);

%% Connect blobs into transients
disp('Making transients...');
MakeTransients(); % Dave - the inputs to this are currently unused
!del InitClu.mat

%% Group together individual transients under individual neurons
disp('Making neurons...'); 
MakeNeurons('min_trans_length',10);

%% Pull traces out of each neuron using the High-pass movie
disp('Normalizing traces...'); 
NormalTraces('SLPDF.h5');

%% Expand transients
disp('Expanding transients...'); 
ExpandTransients(0);

%% Calculate peak of all transients
disp('Calculating pPeak...'); 
Calc_pPeak;

AddPoTransients;

%% Determine rising events/on-times for all transients
disp('Finalizing...');
DetectGoodSlopes;



end

