function [ mouse_name, session_date, session_num ] = get_name_date_session( folder_path )
% [ mouse_name, session_data, session_num ] = get_name_date_session( folder_path )
%   Gets mouse name, session date, and session number from folder path.
%   All values are strings
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

% Formats for pulling files and sessions
date_format = '(?<month>\d+)_(?<day>\d+)_(?<year>\d+)';
session_format = '(?<sesh_number>\d?) -';
mouse_format = '\\(?<name>G\w+\d+)';

% Get date.
temp = regexp(folder_path,date_format,'names');
temp_start = regexp(folder_path,date_format); % Get start index of date folder
session_date = [temp.month '_' temp.day '_' temp.year];

% Get session number
temp_folder =folder_path(temp_start + 9:end); % Grab everything after date
temp2 = regexp(temp_folder,session_format,'names');
if isempty(temp2)
    % Assign session number as 1 if there are no subfolders within
    % the date folder
    session_num = num2str(1);
else
    session_num = temp2.sesh_number;
end
%Get mouse name.
temp3 = regexp(folder_path,mouse_format,'names');

mouse_name = temp3(1).name;

end

