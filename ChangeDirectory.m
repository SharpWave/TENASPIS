function [dirstr] = ChangeDirectory(animal_id,sess_date,sess_num,change_dir_flag)
% [dirstr] = ChangeDirectory(animal_id,sess_date,sess_num,change_dir_flag)
% 
% Changes to the appropriate working directory for the mouse in question,
% and/or outputs that directory in dirstr.
% If change_dir_flag is not specified or is set to 1, this will change to
% the working directory. If change_dir_flag is set to 0, dirstr will still
% be output but you will remain in the original directory.
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

if ~exist('sess_num','var')
    sess_num = 1;
end

if ~exist('change_dir_flag','var')
    change_dir_flag = 1; % default value
end

% CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
% cd(MasterDirectory);

load(fullfile(MasterDirectory,'MasterDirectory.mat'));

% cd(CurrDir);

animals = {MD.Animal};
dates = {MD.Date};
sessions = [MD.Session];

i = find(strcmp(animals,animal_id) & strcmp(dates,sess_date) & sessions == sess_num);

if length(i) > 1
    disp('Multiple directories found! Check MakeMouseSessionList.'); 
elseif isempty(i)
    disp('Directory not found! Check MakeMouseSessionList.'); 
else
    dirstr = MD(i).Location; 
    
    if change_dir_flag
        cd(dirstr); 
    end
end

end
