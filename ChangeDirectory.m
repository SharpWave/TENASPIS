function dirstr = ChangeDirectory(animal_id,sess_date,sess_num,change_dir_flag)
% dirstr = ChangeDirectory(animal_id,sess_date,sess_num,change_dir_flag)
%
% Changes to the appropriate working directory for the mouse in question,
% and/or outputs that directory in dirstr.
%
%   INPUTS
%       animal_id: String, ID of the animal.
%
%       sess_date: String, date in the format MM_DD_YYYY. 
%
%   (optional)
%       sess_num: Scalar, session number. 
%
%       change_dir_flag: Logical, whether you want to move to that
%       directory. If change_dir_flag is not specified or is set to 1, this
%       will change to the working directory. If change_dir_flag is set to
%       0, dirstr will still be output but you will remain in the original
%       directory.
%
%   OUTPUT
%       dirstr: String, directory corresponding to inputs.
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

%%
%Default value of sess_num = 1.
if ~exist('sess_num','var')
    sess_num = 1;
end

%Default value of change_dir_flag = 1. 
if ~exist('change_dir_flag','var')
    change_dir_flag = 1; 
end

%Fetch Master Directory from upper level function(s). 
global MasterDirectory;
if ~isempty(MasterDirectory)
    load(fullfile(MasterDirectory,'MasterDirectory.mat'));
elseif isempty(MasterDirectory)
    load('C:\MasterData\MasterDirectory.mat');
    disp('''MasterDirectory'' global variable not found.  Using C:\MasterData')
end
    

%Concatenate fields for searching. 
animals = {MD.Animal};
dates = {MD.Date};
sessions = [MD.Session];

%Find MD entry that matches the input animal, date, AND session.
i = find(strcmp(animals,animal_id) & strcmp(dates,sess_date) & sessions == sess_num);

if length(i) > 1        %If multiple entries match, throw an error. 
    disp('Multiple directories found! Check MakeMouseSessionList.'); 
elseif isempty(i)       %If no entries match, throw an error. 
    disp('Directory not found! Check MakeMouseSessionList.'); 
else                    %If one entry matches, get directory name and...
    dirstr = MD(i).Location; 
    
    if change_dir_flag  %...if flagged, change directory. 
        cd(dirstr); 
    end
end

end
