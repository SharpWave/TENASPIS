function Tenaspis3(md,varargin)
%Tenaspis3(md,varargin)
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
%   INPUTS
%       md: Master Directory entry. 
%
%       varargin: 
%           preprocess: logical, whether you want to run MakeT2Movies.
%           Default=whether SLPDF exists in your directory.
%
%           d1: logical, whether you want to make first derivative movie
%           during MakeT2Movies. Default=false.
%
%           manualmask: logical, whether you want to draw mask manually.
%           Default=false. 
%
%           masterdirectory: string, path to master directory.
%           Default='C:/MasterData'.
%       
%           Neuron extraction parameters: see SegmentFrame for options!
%

%% Parse inputs. 
    cd(md.Location);
    
    p = inputParser;
    p.KeepUnmatched = true;
    p.addRequired('md',@(x) isstruct(x));
    p.addParameter('preprocess',~exist(fullfile(pwd,'SLPDF.h5'),'file'));      
                                            %Make SLPDF and DFF movies. 
    p.addParameter('d1',false);             %Make first derivative movie. 
    p.addParameter('manualmask',false);     %Draw mask manually.
    p.addParameter('masterdirectory','C:/MasterData',@(x) ischar(x)); 
                                            %Master directory.
    p.parse(md,varargin{:});
    
    %Compile. 
    preprocess = p.Results.preprocess; 
    d1 = p.Results.d1; 
    manualmask = p.Results.manualmask; 
    MasterDirectory = p.Results.masterdirectory; 
    
    %Check whether initial mask exists. 
    maskExist = exist(fullfile(MasterDirectory,[md.Animal,'_initialmask.mat']),'file');
    
%% Make SLPDF and DFF movies. 
    if preprocess
        disp('No SLPDF or DFF detected. Making movies...'); 
        MakeT2Movies('path',md.Location,'d1',d1);
    else
        disp('SLPDF and DFF movies found. Proceeding...');
    end

%% Register the masks.
    %Get directory for initial mask. 
    [initDate,initSession] = GetInitRegMaskInfo(md.Animal);
    initDir = ChangeDirectory(md.Animal,initDate,initSession); 
    
    %If initial mask doesn't exist or if manualmask is triggered...
    if maskExist==0 || manualmask
        disp('Mask does not exist or manual mask triggered. Draw mask now.');
        cd(initDir); 
        
        %Draw mask on the initial session's minimum projection. 
        MakeMaskSingleSession;
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
    load(fullfile(pwd,'mask_reg.mat')); mask_reg = logical(mask_reg); 

    disp('Extracting blobs...');
    ExtractBlobs('SLPDF.h5',mask_reg,varargin{:}); 
    
%% Connect blobs into transients. 
    disp('Making transients...');
    MakeTransients; 
    !del InitClu.mat

%% Group together individual transients under individual neurons.
    disp('Making neurons...'); 
    MakeNeurons('min_trans_length',10);

%% Pull traces out of each neuron using the High-pass movie.
    disp('Normalizing traces...'); 
    NormalTraces('SLPDF.h5');
    MakeROIavg;
    load('ProcOut.mat','NeuronPixels','Xdim','Ydim','NumFrames');
    load('ROIavg.mat');
    MakeROIcorrtraces(NeuronPixels,Xdim,Ydim,NumFrames,ROIavg);
    
%% Expand transients.
    disp('Expanding transients...'); 
    ExpandTransients(0);

%% Calculate peak of all transients.
    AddPoTransients;    

%% Determine rising events/on-times for all transients.
    DetectGoodSlopes;

    %Merge ambiguous neurons.
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

end