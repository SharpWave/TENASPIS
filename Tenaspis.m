function [] = Tenaspis(infile,varargin)
% [] = Tenaspis(infile,varargin)
% Technique for Extracting Neuronal Activity from Single Photon Image
% Sequences, by David Sullivan
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% inputs (required)
%
% infile: name of the movie, e.g., 'mouse1.h5'
%
% 
% inputs (optional):
% 
% 'no_movie_process': skips the movie smoothing and first derivative steps
% - good for re-running this with a new version. defaults to 0
%
% 'manual_mask': has the user draw a mask rather than deriving it from the InitRegMask.  Defaults to 0.
%
% semi-optional inputs: if manual_mask is 0 (default), you must include
% 'animal_id': the animal, e.g., 'GCaMP6f_05'
% 'sess_date': the date the session took place, e.g., '09_29_2014'
% 'sess_num': which session for a given date to analyze
%
% ----------------
%
% EXAMPLE: Tenaspis('Obj1 - ICsm.h5','animal_id','GCaMP6f_31','sess_date','10_17_2014','sess_num',1,'no_movie_process',1)
% this will use a registered mask but skip the movie processing
%
% EXAMPLE: Tenaspis('Obj1 - ICsm.h5')
% this hits an error
%
% EXAMPLE: Tenaspis('Obj1 - ICsm.h5','manual_mask',1)
% this runs Tenaspis the 'old' way with a manually drawn mask

ManMask = 0;

if (~isempty(varargin))
    [animal_id,sess_date,sess_num,no_movie_process,ManMask] = ParseTenaspisInput(varargin);
end

% animal_id,sess_date,sess_num

% static parameters:
SmoothWindowWidth = 20; % width of window for temporally smoothing the movie with a gaussian (currently using the acquisition sampling rate)
threshfactor = 4; % baseline threshold for detecting cells

if (~ManMask)
    MasterDirectory = 'C:\MasterData';
    
    %% Step 0: Register the mask
    [init_date,init_sess] = GetInitRegMaskInfo(animal_id);
    init_dir = ChangeDirectory(animal_id,init_date,init_sess);
    init_tif = [init_dir,'\ICmovie_min_proj.tif'];
    
    load([MasterDirectory,'\',animal_id,'_initialmask.mat']); % gets mask
    t_dir = ChangeDirectory(animal_id,sess_date,sess_num);
    target_tif = [t_dir,'\ICmovie_min_proj.tif'];
    
    mask_multi_image_reg(init_tif,1,mask,'reg_files',{target_tif});
else
    t_dir = pwd;
end

if(~no_movie_process) % don't run these if already run
    %% Step 1: Smooth the movie
    TempSmoothMovie(infile,'SMovie.h5',SmoothWindowWidth);
    
    %% Step 2: Take the first derivative
    DFDT_Movie('SMovie.h5','D1Movie.h5');
end

%% Step 3: Determine the threshold
[meanframe,stdframe] = moviestats('D1Movie.h5');
thresh = threshfactor*mean(stdframe);
save Blobthresh.mat thresh;

%% Step 4: load the mask
if (~ManMask)
  load ('mask_reg.mat');
  neuronmask = mask_reg;
else
  EstimateBlobs('D1Movie.h5',0,thresh);
  MakeBlobMask;
  load('manualmask.mat');
end

% Step 5: Extract Blobs
ExtractBlobs('D1Movie.h5',0,thresh,neuronmask);

%% Step 6: String Blobs into calcium transients
MakeTransients('D1Movie.h5');

%temporary: needed because of previous changes:
!del InitClu.mat

%% Step 7: Decide which transients (segments) belong to the same neuron
MakeNeurons();



