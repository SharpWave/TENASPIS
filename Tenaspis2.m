function Tenaspis2()
% Quick & dirty Tenaspis2
% Requires DFF.h5, manualmask.mat, and SLPDF.h5 be present

load mask_reg;

disp('Extracting blobs...'); 
ExtractBlobs('DFF.h5',0,neuronmask,0.5);

disp('Making transients...');
MakeTransients('DFF.h5',0);
!del InitClu.mat

disp('Making neurons...'); 
MakeNeurons('min_trans_length',12);

% get traces
disp('Normalizing traces...'); 
NormalTraces('SLPDF.h5');

disp('Expanding transients...'); 
ExpandTransients(0);

disp('Calculating pPeak...'); 
Calc_pPeak;

AddPoTransients;

disp('Finalizing...');
DetectGoodSlopes;

CalculatePlacefields('201b','alt_inputs','T2output.mat','man_savename','PlaceMaps.mat','half_window',0,'minspeed',3);
PFstats;

end

