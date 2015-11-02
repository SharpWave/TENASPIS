function [animal_id,sess_date,sess_num,no_movie_process,ManMask,no_blobs] = ParseTenaspisInput(args);
% [animal_id,sess_date,sess_num,no_movie_process,ManMask,no_blobs] = ParseTenaspisInput(args);
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
animal_id = [];
sess_date = [];
sess_num = [];
no_movie_process = 0;
ManMask = 0;
no_blobs = 0;

for i = 1:length(args)
    if (mod(i,2) == 0)
        continue;
    end
    if (strcmp(args{i},'animal_id'))
        animal_id = args{i+1};
    end
    
    if (strcmp(args{i},'sess_date'))
        sess_date = args{i+1};
    end
    
    if (strcmp(args{i},'sess_num'))
        sess_num = args{i+1};
    end
    
    if (strcmp(args{i},'no_movie_process'))
        no_movie_process = args{i+1};
    end
    
    if (strcmp(args{i},'manual_mask'))
        ManMask = args{i+1};
    end
    
    if (strcmp(args{i},'no_blobs'))
        no_blobs = args{i+1};
    end
    
end

end

