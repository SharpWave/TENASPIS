function MakeT2Movies(varargin)
% MakeT2Movies(NAME,VALUE)
%
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
%   Takes cropped, motion-corrected movie and makes two movies from it. 
%
% INPUTS
%   NAME:
%       'path' whose VALUE can be a string, the path containing the session
%       usually in the form X:\Animal\Date\Session. Default=runs uigetfile.
%
%       'd1' whose VALUE can be a logical, whether or not you want to also
%       make a first derivative movie from the 3-pixel smoothed movie.
%       Default=false.
%   
% OUTPUTS - saved to directory above motion-corrected movie path.
%
%   SLPDF.h5: Takes a 3-pixel smoothed version of the input movie and
%   divides it by the 20-pixel smoothed version of the same movie. Then,
%   take the DF/F of the quotient. 
%
%   DFF.h5: DF/F of the 3-pixel smoothed movie. 
%

%% Parse inputs. 
    p = inputParser; 
    p.addParameter('path',false);
    p.addParameter('d1',false,@(x) islogical(x));
    p.parse(varargin{:});
    path = p.Results.path;  %File path.
    d1 = p.Results.d1;      %Temporal first derivative movie?
    
%% File names.
    %If the path is specified, grab the h5 file name.
    if ischar(path)
        cd(fullfile(path,'MotCorrMovie-Objects')); 
        h5 = ls('*.h5'); 
        MotCorrh5 = fullfile(pwd,h5); 

    %Otherwise, select the file with a UI. 
    else
        [MotCorrh5,path] = uigetfile('*.h5');
        MotCorrh5 = fullfile(path,MotCorrh5);
        path = fileparts(fileparts(path)); % Grab folder above the one containing MotCorrh5 movie
    end
    
    %File names. 
    SLPDFname = fullfile(path,'SLPDF.h5');              %Spatial low pass divide DF/F.
    DFFname = fullfile(path,'DFF.h5');                  %DF/F of spatially smoothed movie.
    threePixName = fullfile(path,'threePixSmooth.h5');  %Spatially smoothed movie.
    tempfilename = fullfile(path,'temp.h5');            %Spatial low pass divide (before DF/F).
    
%% Set up.
    %Make files. 
    info = h5info(MotCorrh5,'/Object'); 
    [~,Xdim,Ydim,nFrames] = loadframe(MotCorrh5,1);
    h5create(tempfilename,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single');
    h5create(threePixName,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single'); 
    
    %Spatial filters. 
    LPfilter = fspecial('disk',20);
    threePixfilter = fspecial('disk',3);

%% Writing. 
    disp('Making Movies')
    info = h5info(MotCorrh5,'/Object');
    
    % Initialized ProgressBar
    resol = 1; % Percent resolution for progress bar
    p = ProgressBar(100/resol);
    update_inc = round(nFrames/(100/resol)); % Get increments for updating ProgressBar
    
    for i=1:nFrames
        frame = single(loadframe(MotCorrh5,i,info));
        
        LPframe = imfilter(frame,LPfilter,'same','replicate');              %20-pixel filter.
        threePixFrame = imfilter(frame,threePixfilter,'same','replicate');  %3-pixel filter.
       
        h5write(threePixName,'/Object',threePixFrame,[1 1 i 1],...          %Write 3-pixel smoothed.
            [Xdim Ydim 1 1]); 
        h5write(tempfilename,'/Object',threePixFrame./LPframe,[1 1 i 1],... %Write LP divide.
            [Xdim Ydim 1 1]); 
        
        if round(i/update_inc) == (i/update_inc) % Update progress bar
            p.progress;
        end
        
    end
    p.stop;
    
    if d1
        disp('Making D1Movie.h5');     
        %Temporal smooth. 
        TempSmoothMovie(threePixName,'SMovie.h5',20); 
        
        %First derivative movie. 
        multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5');
        if ~isempty(multiplier_use)
            delete D1Movie.h5
            multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5',multiplier_use);
            save multiplier.mat multiplier_use
        end
        delete SMovie.h5
    end
    
    disp('Making SLPDF.h5...');         %DF/F of LP divide. 
    Make_DFF(tempfilename,SLPDFname);

    disp('Making DFF.h5...');           %DF/F of 3-pixel smoothed. 
    Make_DFF(threePixName,DFFname);
    
%% Delete temporary files
    delete(tempfilename);
    delete(threePixName);

end