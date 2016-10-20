function MakeFilteredMovies(varargin)
% MakeFilteredMovies(NAME,VALUE)
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
%   SHPDFF.h5: SpatialHighPass DFF. Takes a 3-pixel smoothed version of the input movie and
%   divides it by the 20-pixel smoothed version of the same movie. Then,
%   take the DF/F of the quotient.
%
%   3PDFF.h5: DF/F of the 3-pixel smoothed movie.
%

[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

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
SHPDFF = fullfile(path,'SHPDFF.h5');              %Spatial high pass divide DF/F.
3PDFF = fullfile(path,'3PDFF.h5');                  %DF/F of spatially smoothed movie.
threePixName = fullfile(path,'threePixSmooth.h5');  %Spatially smoothed movie.
tempfilename = fullfile(path,'temp.h5');            %Spatial high pass divide (before DF/F).

%% Set up.
%Make files.

h5create(tempfilename,'/Object',info.Dataspace.Size,'ChunkSize',...
    [Xdim Ydim 1 1],'Datatype','single');
h5create(threePixName,'/Object',info.Dataspace.Size,'ChunkSize',...
    [Xdim Ydim 1 1],'Datatype','single');

%Spatial filters.
LPfilter = fspecial('disk',20);
threePixfilter = fspecial('disk',3);

%% Writing.
disp('Making Movies')

% Initialized ProgressBar
p = ProgressBar(NumChunks);

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames(MotCorrh5,FrameList);
    LPframe = imfilter(frame,LPfilter,'same','replicate');              %20-pixel filter.
    
for i=1:NumFrames
    frame = single(LoadFrames(MotCorrh5,i));
    
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

%     if d1
%         disp('Making D1Movie.h5');
%         %Temporal smooth.
%         TempSmoothMovie(threePixName,'SMovie.h5',20);
%
%         %First derivative movie.
%         multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5');
%         if ~isempty(multiplier_use)
%             delete D1Movie.h5
%             multiplier_use = DFDT_Movie('SMovie.h5','D1Movie.h5',multiplier_use);
%             save multiplier.mat multiplier_use
%         end
%         delete SMovie.h5
%     end

disp('Making SHPDFF.h5...');         %DF/F of LP divide.
Make_DFF(tempfilename,SHPDFF);

disp('Making 3PDFF.h5...');           %DF/F of 3-pixel smoothed.
Make_DFF(threePixName,3PDFF);


%% Delete temporary files
delete(tempfilename);
delete(threePixName);

end