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
[Xdim,Ydim,NumFrames,FrameChunkSize] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize');

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[Xdim Ydim 1 1],'Datatype','single');

%% Get averages.
display('determining averages');
avgframe = zeros(Xdim,Ydim); % Initialize variable

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
for i = 1:NumFrames
   [frame] = loadframe(moviefile,i,info); 
   avgframe = avgframe+single(frame);
   
   if round(i/update_inc) == (i/update_inc) % Update progress bar
       p.progress;
   end
   
end
avgframe = avgframe./NumFrames;
p.stop;

%% Make DFF
display('calculating and saving DFF');

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
for i = 1:NumFrames
    [frame,~,~,~] = LoadFrames(moviefile,i); 
    newframe = (single(frame)-avgframe)./avgframe;
    h5write(outfile,'/Object',newframe,[1 1 i 1],[Xdim Ydim 1 1]);
    
    if round(i/update_inc) == (i/update_inc) % Update progress bar
       p.progress;
    end
   
end
p.stop;

end
