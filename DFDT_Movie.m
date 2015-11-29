function [multiplier_use] = DFDT_Movie(infile,outfile,multiplier)
% [] = DFDT_Movie(infile,outfile,multiplier)
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

% Set multiplier to fill out all of int16 range.  Default is 500 unless
% otherwise specified
if nargin < 3
    multiplier = 500; % Default value
end

save DFDT_multiplier.mat multiplier;

info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'Datatype','int16');

F0 = h5read(infile,'/Object',[1 1 1 1],[XDim YDim 1 1]);
%F0 = int16(F0);
h5write(outfile,'/Object',int16(zeros(size(F0))),[1 1 1 1],[XDim YDim 1 1]);

maxDF = 0; minDF = 0; bad_frames = [];
for i = 2:NumFrames
  F1 = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1])*multiplier;
  DF = F1-F0;
  F0 = F1;

  if (i <= 20)
      DF = (zeros(size(DF)));
  end
  if ((max(DF(:)) > intmax('int16')) || (min(DF(:)) < intmin('int16')))
      if isempty(bad_frames) % only display warning once
          disp(['Specified multiplier of ' num2str(multiplier) ' is too large.'])
          disp('Calculating correct multiplier to use')
      end
      %       error('integer conversion error');
      
      maxDF = max([maxDF max(DF(:))]); minDF = min([minDF min(DF(:))]); % Calculate max and mins
      bad_frames = [bad_frames i];
  elseif isempty(bad_frames) % If all is ok, continue writing
      display(['Calculating temporal difference for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
      h5write(outfile,'/Object',int16(DF),[1 1 i 1],[XDim YDim 1 1]);
  end
  
end

% Calculate new multiplier to use if necessary
if ~isempty(bad_frames)
      scale_factor = min([abs(single(intmax('int16'))/maxDF) abs(single(intmin('int16'))/minDF)]);
      multiplier_use = floor(multiplier*scale_factor);
      num_bad_frames = length(bad_frames);
      disp(['Multiplier used results in clipping for ' num2str(num_bad_frames) ' frames. Re-run with multiplier = ' num2str(multiplier_use)])
else
      multiplier_use = [];
end
  
end

  