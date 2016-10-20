function MakeFilteredMovies(varargin)
% MakeFilteredMovies(varargin)
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
%   BPDFF.h5: SpatialBandPass DFF. Takes a 3-pixel smoothed version of the input movie and
%   divides it by the 20-pixel smoothed version of the same movie. Then,
%   take the DF/F of the quotient.
%
%   LPDFF.h5: DF/F of the 3-pixel smoothed movie.

%% Get Parameters and setup frame chunking
[Xdim,Ydim,NumFrames,FrameChunkSize,HighPassRadius,LowPassRadius] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize','HighPassRadius','LowPassRadius');

ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

%% Parse inputs.
p = inputParser;
p.addParameter('path',false);

p.parse(varargin{:});

path = p.Results.path;  %File path.


%% Input File names.
% If the path is specified, grab the h5 file name.
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

%% Output File names.
BPDFF = fullfile(path,'BPDFF.h5');              % DF/F normalized spatial band pass filtered movie
LPDFF = fullfile(path,'LPDFF.h5');                % DF/F normalized Low pass filtered movie
LowPassName = fullfile(path,'LowPass.h5');        % Low pass filtered movie
BandPassName = fullfile(path,'BandPass.h5');      % High pass filtered movie

%% Set up.
% create output files

h5create(BandPassName,'/Object',info.Dataspace.Size,'ChunkSize',...
    [Xdim Ydim 1 1],'Datatype','single');
h5create(LowPassName,'/Object',info.Dataspace.Size,'ChunkSize',...
    [Xdim Ydim 1 1],'Datatype','single');

% create Spatial filters.
HighPassFilter = fspecial('disk',HighPassRadius);
LowPassFilter = fspecial('disk',LowPassRadius);

%% Writing.
disp('Filtering Movies')

% Initialized ProgressBar
p = ProgressBar(NumChunks);

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames(MotCorrh5,FrameList);
    
    HPChunk = imfilter(FrameChunk,HighPassFilter,'same','replicate'); % Big radius filter to smooth out background
    LPChunk = imfilter(FrameChunk,LowPassFilter,'same','replicate'); % Small radius filter to reduce pixel noise
    
    h5write(LowPassName,'/Object',LPChunk,[1 1 ChunkStarts(i) 1],...          %Write Lowpass
        [Xdim Ydim length(FrameList) 1]);
    
    h5write(BandPassName,'/Object',LPChunk./HPChunk,[1 1 ChunkStarts(i) 1],... %Write LP divide.
        [Xdim Ydim length(FrameList) 1]);
    
    p.progress;
end
p.stop;

%% Calculate DF/F 
disp('Making BPDFF.h5...');    %DF/F of BP
Make_DFF(BandPassName,BPDFF);

disp('Making LPDFF.h5...');    %DF/F of Low Pass
Make_DFF(LowPassName,LPDFF);

%% Delete temporary files
delete(BandPassName);
delete(LowPassName);

end