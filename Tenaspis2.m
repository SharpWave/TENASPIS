function [ output_args ] = Tenaspis2()
% Quick & dirty Tenaspis2
% Requires DFF.h5, manualmask.mat, and SLPDF.h5 be present

load manualmask;

ExtractBlobs('DFF.h5',0,0,neuronmask,0.3);
MakeTransients('DFF.h5',0,'min_trans_length',3);
!del InitClu.mat
MakeNeurons();
% get traces
NormalTraces('SLPDF.h5')
ExpandTransients(0);
Calc_pPeak;
AddPoTransients;
DetectGoodSlopes;


end

