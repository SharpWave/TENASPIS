function [init_date,init_sess] =  GetInitRegMaskInfo(animal_id)
% [init_date,init_sess] =  GetInitRegMaskInfo(animal_id)
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

AI(1).animal = 'GCaMP6f_31';
AI(1).init_date = '09_29_2014';
AI(1).init_sess = 1;

AI(2).animal = 'GCamp6f_30';
AI(2).init_date = '11_11_2014';
AI(2).init_sess = 1;

AI(3).animal = 'GCamp6f_44';
AI(3).init_date = '07_10_2015';
AI(3).init_sess = 2;

AI(4).animal = 'GCamp6f_45';
AI(4).init_date = '08_05_2015';
AI(4).init_sess = 1;

for i = 1:length(AI)
    if (strcmpi(AI(i).animal,animal_id))
        init_date = AI(i).init_date;
        init_sess = AI(i).init_sess;
        return;
    end
end
        

end

