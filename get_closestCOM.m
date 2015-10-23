function [ refpoints ] = get_closestCOM( xyvec,COM )
% [ refpoints ] = get_closestCOM( xyvec,COM )
%get_closestCOM Get closest COMs of cells to use
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
% INPUTS
% xyvec:    n x 2 vector of points with xvalues in column 1 and y values in column 2
% COM:      1 x k cell of 1 x 2 vectors , NOTE: [ yCOM xCOM] because MATLAB
%           is dumb like that
% OUTPUTS
% refpoints: centers of mass of selected cells, NOTE: [xCOM yCOM}

xvec_use = [xyvec(:,2) xyvec(:,1)]; % Swap x and y input values to make up for MATLAB bug
refpoints = zeros(size(xvec_use));
for j = 1: size(xvec_use,1)
    temp = cellfun(@(a) sqrt((xvec_use(j,:)-a)*(xvec_use(j,:)-a)'), COM);
    refpoints(j,1) = COM{find(min(temp) == temp)}(2);
    refpoints(j,2) = COM{find(min(temp) == temp)}(1);
end

end

