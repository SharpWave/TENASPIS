function [meanframe,stdframe,meanframepos,stdframepos] = moviestats(file)
%[meanframe,stdframe] = moviestats(file)
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

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);

% Initialize Progress Bar
resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar

% Pre-allocate
meanframe = zeros(1,NumFrames);
stdframe = zeros(1,NumFrames);

% Calculate stats
for i = 1:NumFrames
    frame = double(loadframe(file,i,info));
    meanframe(i) = mean(frame(:));
    stdframe(i) = std(frame(:));
    
    if (nargout > 2)
        pos = find(frame(:) > 0);
        meanframepos(i) = mean(frame(pos));
        stdframepos(i) = std(frame(pos));
    end
    
    % Update progress bar
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
    
end

p.stop; % Terminate progress bar

end

