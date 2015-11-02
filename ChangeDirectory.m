function [dirstr] = ChangeDirectory(animal_id,sess_date,sess_num)
% [dirstr] = ChangeDirectory(animal_id,sess_date,sess_num)
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

if(~exist('sess_num'))
    sess_num = 1;
end

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

load MasterDirectory.mat;

cd(CurrDir);

NumEntries = length(MD);

for i = 1:NumEntries

    if (strcmp(MD(i).Date,sess_date) & (MD(i).Session == sess_num) & strcmp(MD(i).Animal,animal_id))
        cd(MD(i).Location);
        dirstr = (MD(i).Location);
        return;
    end
end

display('Directory not found');