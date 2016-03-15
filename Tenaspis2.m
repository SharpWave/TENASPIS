function [ output_args ] = Tenaspis2()
% Quick & dirty Tenaspis2
% Requires DFF.h5, manualmask.mat, and SLPDF.h5 be present

load manualmask;

ExtractBlobs('DFF.h5',0,0,neuronmask,0.5);
MakeTransients('DFF.h5',0);
!del InitClu.mat
MakeNeurons('min_trans_length',12);
% get traces
NormalTraces('SLPDF.h5');
ExpandTransients(0);
Calc_pPeak;
AddPoTransients;
DetectGoodSlopes;
CalculatePlacefields('201b','alt_inputs','T2output.mat','man_savename','PlaceMaps.mat','half_window',0,'minspeed',3);
PFstats;

end

