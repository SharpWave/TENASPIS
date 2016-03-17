function Tenaspis2(animal_id,sess_date,sess_num)
% Quick & dirty Tenaspis2
% Requires DFF.h5, manualmask.mat, and SLPDF.h5 be present

MasterDirectory = 'C:\MasterData';

[init_date,init_sess] = GetInitRegMaskInfo(animal_id);
init_dir = ChangeDirectory(animal_id,init_date,init_sess);
init_tif = fullfile(init_dir,'ICmovie_min_proj.tif');

load(fullfile(MasterDirectory,[animal_id,'_initialmask.mat']));

reg_struct.Animal = animal_id;
reg_struct.Date = sess_date;
reg_struct.Session = sess_num;

mask_multi_image_reg(init_tif,init_date,init_sess,reg_struct);

load mask_reg
mask_reg = logical(mask_reg); 

disp('Extracting blobs...'); 
ExtractBlobs('DFF.h5',mask_reg);

disp('Making transients...');
MakeTransients('DFF.h5',0);
!del InitClu.mat

disp('Making neurons...'); 
MakeNeurons('min_trans_length',10);

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

CalculatePlacefields('201b','alt_inputs','T2output.mat','man_savename','PlaceMapsv2.mat','half_window',0,'minspeed',3);
PFstats;

end

