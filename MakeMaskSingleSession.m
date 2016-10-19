function MakeMaskSingleSession(movie)
% MakeMaskSingleSession(movie)
% 
%   Makes a mask of the field of view after displaying a maximum
%   projection. Circle over a large area where you see cells. Saves as
%   singlesessionmask.mat with a logical matrix called neuronmask that is
%   true in the area over the mask.
%
%   INPUT
%       movie: file name of movie you want to draw mask on. Must be same
%       dimensions as other movies in directory. 
%
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

close all;

% Get movie information. 
[~,Xdim,Ydim,NumFrames] = loadframe(movie,1);

% step 1 build up a maximum projection, using every 5th frame
newmax = zeros(Xdim,Ydim);
for i = 1:5:NumFrames
    temp = loadframe(movie,i);
    newmax(temp > newmax) = temp(temp > newmax);
end

figure;
%imagesc(newmax);colormap gray;axis equal;

% Draw mask. 
ToContinue = 'n';
display('draw a circle around the area with good cells');
while ~(strcmp(ToContinue,'y'))
    neuronmask = roipoly(newmax);
    figure;imagesc(neuronmask);
    
    ToContinue = input('OK with the mask you just drew? [y/n] --->','s');
end

%Save.
save singlesessionmask.mat neuronmask;

end

