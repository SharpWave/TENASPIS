function [] = MakeBlobMask()
%[] = MakeBlobMask()
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
% creates an image of all naively detected blobs, asks the user to draw the
% good stuff, then saves the mask to disk

ToContinue = 'n';
display('draw a circle around the area with good cells');
while(strcmp(ToContinue,'y') ~= 1)
    neuronmask = roipoly;
    figure;imagesc(neuronmask);
    ToContinue = input('OK with the mask you just drew? [y/n] --->','s');
end
save manualmask.mat neuronmask
close all;

end

