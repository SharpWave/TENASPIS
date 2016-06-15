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

AI(5).animal = 'GCamp6f_41';
AI(5).init_date = '08_05_2015';
AI(5).init_sess = 1;

AI(6).animal = 'GCamp6f_46';
AI(6).init_date = '08_14_2015';
AI(6).init_sess = 1;

AI(7).animal = 'GCamp6f_30_2';
AI(7).init_date = '06_10_2015';
AI(7).init_sess = 1;

AI(8).animal = 'GCamp6f_45_treadmill';
AI(8).init_date = '11_09_2015';
AI(8).init_sess = 2;

AI(10).animal = 'GCamp6f_48_treadmill';
AI(10).init_date = '11_30_2015';
AI(10).init_sess = 2; 

AI(11).animal = 'GCamp6f_45_altpilot';
AI(11).init_date = '01_13_2016';
AI(11).init_sess = 1; 

AI(12).animal = 'GCamp6f_48';
AI(12).init_date = '08_29_2015';
AI(12).init_sess = 1;

AI(13).animal = 'GCamp6f_45_DNMP';
AI(13).init_date = '04_01_2016';
AI(13).init_sess = 1; 

AI(14).animal = 'Aquila';
AI(14).init_date = '04_28_2016';
AI(14).init_sess = 1; 

AI(15).animal = 'Libra';
AI(15).init_date = '05_13_2016';
AI(15).init_sess = 1; 

AI(16).animal = 'Bellatrix';
AI(16).init_date = '06_13_2016';
AI(16).init_sess = 1; 

AI(17).animal = 'Polaris';
AI(17).init_date = '06_14_2016';
AI(17).init_sess = 1; 

for i = 1:length(AI)
    if (strcmpi(AI(i).animal,animal_id))
        init_date = AI(i).init_date;
        init_sess = AI(i).init_sess;
        return;
    end
end
        

end

