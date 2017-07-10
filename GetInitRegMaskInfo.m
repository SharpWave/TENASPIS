function [init_date,init_sess] =  GetInitRegMaskInfo(animal_id)
% [init_date,init_sess] =  GetInitRegMaskInfo(animal_id)
%
%   Gets the date and session number of the initial session for the animal
%   specified as animal_id. This session will contain the minimum
%   projection of the initial recording to which future recording sessions
%   will be aligned. Animal entries and their respective initial dates and
%   session numbers must be manually edited in this function prior to
%   running it. 
%
%   INPUT
%       animal_id: String, ID of the animal. Must be unique and must match one
%       of the AI.animal fields below. 
%
%   OUTPUTS
%       init_date: String, date of the initial session in the format
%       MM_DD_YYYY. 
%
%       init_sess: Scalar, initial session number. 
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


%% Initial session data.
i = 1;
AI(i).animal = 'GCaMP6f_31';        %Manually specify animal ID here.
AI(i).init_date = '09_29_2014';     %Manually specify initial date here.
AI(i).init_sess = 1;                %Manually specify initial session here. 

i = i+1;
AI(i).animal = 'GCamp6f_30';
AI(i).init_date = '11_11_2014';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'GCamp6f_44';
AI(i).init_date = '07_10_2015';
AI(i).init_sess = 2;

i = i+1;
AI(i).animal = 'GCamp6f_45';
AI(i).init_date = '08_05_2015';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'GCamp6f_41';
AI(i).init_date = '08_05_2015';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'GCamp6f_46';
AI(i).init_date = '08_14_2015';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'GCamp6f_30_2';
AI(i).init_date = '06_10_2015';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'GCamp6f_45_treadmill';
AI(i).init_date = '11_30_2015';
AI(i).init_sess = 10;

i = i+1;
AI(i).animal = 'GCamp6f_48_treadmill';
AI(i).init_date = '04_18_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'GCamp6f_45_altpilot';
AI(i).init_date = '01_13_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'GCamp6f_48';
AI(i).init_date = '08_29_2015';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'GCamp6f_45_DNMP';
AI(i).init_date = '04_01_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'Aquila';
AI(i).init_date = '04_28_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'Libra';
AI(i).init_date = '05_13_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'Bellatrix';
AI(i).init_date = '06_20_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'Polaris';
AI(i).init_date = '06_21_2016';
AI(i).init_sess = 1;

i = i+1;
AI(i).animal = 'Bellatrix_AK';
AI(i).init_date = '11_07_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'KC_DRG';
AI(i).init_date = '12_15_2016';
AI(i).init_sess = 1; 

i = i+1;
AI(i).animal = 'Liya';
AI(i).init_date = '06_18_2017';
AI(i).init_sess = 1; 

i = i + 1;
AI(i).animal = 'Selin';
AI(i).init_date = '09_28_2016';
AI(i).init_sess = 1; 


% For each animal you have, add onto the structure array: 
% i = i+1;
% AI(i).animal = _ANIMAL NAME HERE_
% AI(i).init_date = _INITIAL DATE HERE_
% AI(i).init_sess = _INITIAL SESSION NUMBER HERE_

%% Perform search. 
all_ids = {AI.animal};                      %Cell array of all names.
ind = find(strcmpi(animal_id,all_ids));     %Find name that matches input.

%Set outputs. 
init_date = AI(ind).init_date;               
init_sess = AI(ind).init_sess;
        
end