function [meanframe,stdframe,meanframepos,stdframepos] = moviestats(file)
%[meanframe,stdframe,meanframepos,stdframepos] = moviestats(file)
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
%
%   Gets basic statistics about movie frames. 
%
%   INPUT
%       file: Movie file. 
%
%   OUTPUTS
%       meanframe: 1xF vector (F = number of frames), mean value of pixels
%       per frame.
%
%       stdframe: 1xF vector, standard deviation of pixel intensity per
%       frame.
%
%       meanframepos: 1xF vector, mean value of positive pixels per frame.
%
%       stdframepos: 1xF vector, SD of positive pixel intensity per frame. 
%

%% Set up.
%Get movie info. 
info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);

% Pre-allocate
meanframe = zeros(1,NumFrames);
stdframe = zeros(1,NumFrames);

%If demanded, also provide the mean values and standard deviations of
%positive pixels.
if nargout > 2
    meanframepos = zeros(1,NumFrames);
    stdframepos = zeros(1,NumFrames);
end

% Initialize Progress Bar
resol = 1; % Percent resolution for progress bar, in this case 10%
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
p = ProgressBar(100/resol);

%% Calculate stats.
for i = 1:NumFrames
    frame = double(loadframe(file,i,info));
    meanframe(i) = mean(frame(:));          %Take the mean of the pixels. 
    stdframe(i) = std(frame(:));            %Take the standard deviation of the pixels. 
    
    if (nargout > 2)
        pos = find(frame(:) > 0);           %Get positive pixels.
        meanframepos(i) = mean(frame(pos)); %Mean of positive pixels.
        stdframepos(i) = std(frame(pos));   %SD of positive pixels.
    end
    
    % Update progress bar
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
    
end

p.stop; % Terminate progress bar

end

