function Tenaspis4(md,varargin)
%Tenaspis4(md,varargin)
% IMPORTANT NOTE: To automate Tenaspis you MUST do three things:
%   1) Add the session(s) in question to your mouse directory (e.g.
%   MakeMouseSessionList),
%
%   2) Designate an initial session you wish to use as a reference for all
%   subsequent sessions, and put the initial session info for this into 
%   GetInitRegMaskInfo.
%
%   3) Run Tenaspis4 with the 'manualmask' flag set to true for the initial
%   session you designated in step 2.  You will be prompted early on to draw
%   a mask around all the good cells (i.e. excluding any dead space and/or
%   artifacts). You can then run all subsequent sessions without drawing a
%   mask, e.g. Tenaspis4(md), 
%
%   INPUTS
%       md: session entry.
%
%       (optional, Name-Pair arguments)
%           preprocess: Logical, whether you want to run
%           MakeFilteredMovies. The h5 file you wish to run this on must
%           be located in the folder 'MotCorrMovie-Objects' in the MD 
%           directory. Will automatically run if BPDFF.h5 is not
%           detected in the MD directory. 
%
%           d1: Logical, whether you want to make D1Movie. Default = false.
%
%           manualmask: Logical, whether you want to manually draw the mask
%           for this session. If not, will automatically take mask from
%           initial session. Default = false.
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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

%% Parse inputs.
    cd(md.Location);
    
    p = inputParser;
    p.addRequired('md',@(x) isstruct(x));
    p.addParameter('preprocess',...
        ~exist(fullfile(pwd,'BPDFF.h5'),'file'));
    p.addParameter('d1',false);                     %Make first derivative movie. 
    p.addParameter('manualmask',false);             %Draw mask manually.
    p.addParameter('masterdirectory',...    
        'C:/MasterData',@(x) ischar(x));            %Master directory.               
    p.parse(md,varargin{:});           
    
    %Compile.
    preprocess = p.Results.preprocess; 
    d1 = p.Results.d1; 
    manualmask = p.Results.manualmask; 
    global MasterDirectory;                         %MasterDirectory is now a global variable. 
    MasterDirectory = p.Results.masterdirectory;    %Insert line 'global MasterDirectory' to fetch. 
    
    %Check whether initial mask exists. 
    maskExist = exist(fullfile(MasterDirectory,[md.Animal,'_initialmask.mat']),'file');
    
%% Make filtered movies. 
    if preprocess
        disp('BPDFF.h5 and/or LPDFF.h5 not detected. Making movies...'); 
        try % try to load an h5 first
            cd(fullfile(md.Location,'MotCorrMovie-Objects'));
            h5Movie = fullfile(pwd,ls('*.h5'));
            
            cd(md.Location);
            Set_T_Params(h5Movie);
            MakeFilteredMovies(h5Movie,'d1',d1);
        catch % if not, load a tiff
            cd(md.Location)
            tiffMovie = fullfile(pwd,ls('*.tiff'));
            Set_T_Params(tiffMovie);
            MakeFilteredMovies(tiffMovie,'d1',d1);
        end
        
    else
        disp('Appropriate movies detected. Proceeding...');
        Set_T_Params(fullfile(md.Location, 'BPDFF.h5'))
    end
    
    %Make first derivative movie if specified.
    if d1       
        disp('Making D1Movie.h5');     
        %Temporal smooth. 
        TempSmoothMovie('LowPass.h5','SMovie.h5',20); 
        
        %First derivative movie. 
        multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5');
        if ~isempty(multiplier_use)
            delete D1Movie.h5
            multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5',...
                multiplier_use);
            save multiplier.mat multiplier_use
        end
        delete SMovie.h5
    end
    
%% Make mask and register it.
    %Get directory for initial mask. 
    [initDate,initSession] = GetInitRegMaskInfo(md.Animal);
    initDir = ChangeDirectory(md.Animal,initDate,initSession); 
    
    if maskExist==0 || manualmask
        disp('Mask does not exist or manual mask triggered. Draw mask now.');
        cd(initDir); 
        
        %Draw mask on the initial session's minimum projection. 
        MakeMaskSingleSession('BPDFF.h5');
        
        %Save to MasterDirectory. 
        copyfile('singlesessionmask.mat',fullfile(MasterDirectory,[md.Animal,'_initialmask.mat']));
        copyfile('ICmovie_min_proj.tif',fullfile(MasterDirectory,[md.Animal,'_init_min_proj.tif']));     
    end
    
    %Path for the initial mask. 
    InitMaskPath = fullfile(MasterDirectory,[md.Animal,'_initialmask.mat']);
    
    %Image registration. 
    mask_multi_image_reg(InitMaskPath,initDate,initSession,md);
    
%% Extract blobs.
    %Load the mask.
    cd(md.Location); 
    load(fullfile(pwd,'mask_reg.mat')); 

    %Set new parameters based on BPDFF movie. 
    Set_T_Params('BPDFF.h5');

    %Get blobs. 
    disp('Extracting blobs...');
    ExtractBlobs(mask_reg);  
    
%% Connect blobs into transients
    LinkBlobs();
    RejectBadTransients();
    MakeTransientROIs();

%% Group together individual transients under individual neurons and save data
    MergeTransientROIs;
    InterpretTraces();
    
end