function [] = Make_DFF(moviefile,outfile)
% [] = Make_DFF(moviefile,outfile)
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
%
disp('applying the DF/F normalization to a movie');

%% Get Parameters and setup frame chunking
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

%% create output file ('ChunkSize' here not related to FrameChunkSize)
h5create(outfile,'/Object',[Xdim Ydim NumFrames 1],'ChunkSize',[Xdim Ydim 1 1],'Datatype','single');

%% Get the average frame of the movie
display('determining average frame');
avgframe = zeros(Xdim,Ydim); % Initialize variable

p = ProgressBar(NumChunks);

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = LoadFrames(moviefile,FrameList);
    avgframe = avgframe+sum(FrameChunk,3);
    p.progress;
end
p.stop;
avgframe = avgframe./NumFrames;

%% normalize frames and save
display('normalizing frames and saving');

p = ProgressBar(NumChunks);

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = single(LoadFrames(moviefile,FrameList));
    rep_avgframe = repmat(avgframe,[1 1 size(FrameChunk,3)]);
    
    NewChunk = (FrameChunk-rep_avgframe)./rep_avgframe;
    
    h5write(outfile,'/Object',NewChunk,[1 1 ChunkStarts(i) 1],[Xdim Ydim length(FrameList) 1]);
    p.progress;  
end
p.stop;

end
