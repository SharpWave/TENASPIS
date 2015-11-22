function [] = Tenaspis(infile,varargin)
% [] = Tenaspis(infile,varargin)
% Tenaspis: Technique for Extracting Neuronal Activity from Single Photon Image Sequences 
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
% 
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% inputs (required):
%
% infile: name of the movie, e.g., 'mouse1.h5'
% 
% inputs (optional):
% 
% 'no_movie_process': 1 skips the movie smoothing and first derivative steps
% - good for re-running this with a new version. 0 = apply smoothing and 
% first derivative steps.  defaults to 0
%
% 'manual_mask': has the user draw a mask rather than deriving it from the InitRegMask.  Defaults to 0.
%
% semi-optional inputs: if manual_mask is 0 (default), you must include
% 'animal_id': the animal, e.g., 'GCaMP6f_05'
% 'sess_date': the date the session took place, e.g., '09_29_2014'
% 'sess_num': which session for a given date to analyze
%
%   'min_trans_length': see MakeTransients, minimum length a transient must
%   last to be considered, optional and if left blank will default to 5
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

%% Get varargins
for j = 1:length(varargin)
   if strcmpi(varargin{j},'min_trans_length')
       min_trans_length = varargin{j+1};
   end
end

%%
ManMask = 0;
no_movie_process = 0;

if (~isempty(varargin))
    [animal_id,sess_date,sess_num,no_movie_process,ManMask,no_blobs] = ParseTenaspisInput(varargin);
end

% static parameters:
SmoothWindowWidth = 20; % width of window for temporally smoothing the movie with a gaussian (currently using the acquisition sampling rate)
threshfactor = 4; % baseline threshold (pixel std multiplier) for detecting cells

if (~ManMask)
    MasterDirectory = 'C:\MasterData';
    
    %% Step 0: Register the mask
    [init_date,init_sess] = GetInitRegMaskInfo(animal_id);
    init_dir = ChangeDirectory(animal_id,init_date,init_sess);
    init_tif = fullfile(init_dir,'ICmovie_min_proj.tif');
    
    load([MasterDirectory,'\',animal_id,'_initialmask.mat']); % gets mask
%     t_dir = ChangeDirectory(animal_id,sess_date,sess_num);
%     target_tif = fullfile(t_dir,'\ICmovie_min_proj.tif');
    reg_struct.Animal = animal_id;
    reg_struct.Date = sess_date;
    reg_struct.Session = sess_num;
    
    mask_multi_image_reg(init_tif,init_date,init_sess,reg_struct);
else
    t_dir = pwd;
end

if(~no_movie_process) % don't run these if already run
    %% Step 1: Smooth the movie
    TempSmoothMovie(infile,'SMovie.h5',SmoothWindowWidth);
    
    %% Step 2: Take the first derivative
    multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5');
    if ~isempty(multiplier_use)
        delete D1Movie.h5
        multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5',multiplier_use);
        save multiplier.mat multiplier_use
    end
    delete SMovie.h5
end

if (~no_blobs)
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
end
%% Step 6: String Blobs into calcium transients
if exist('min_trans_length','var')
    MakeTransients('D1Movie.h5','','min_trans_length',min_trans_length);
else
    MakeTransients('D1Movie.h5')
end

%temporary: needed because of previous changes:
!del InitClu.mat

%% Step 7: Decide which transients (segments) belong to the same neuron
if exist('min_trans_length','var')
    MakeNeurons('min_trans_length',min_trans_length);
else
    MakeNeurons()
end

end

