function [] = DFDT_Movie(infile,outfile);
% [] = DFDT_Movie(infile,outfile);
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

info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'Datatype','int16');

F0 = h5read(infile,'/Object',[1 1 1 1],[XDim YDim 1 1]);
%F0 = int16(F0);
h5write(outfile,'/Object',int16(zeros(size(F0))),[1 1 1 1],[XDim YDim 1 1]);

for i = 2:NumFrames
  display(['Calculating temporal difference for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  F1 = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1])*500;
  DF = F1-F0;
  F0 = F1;

  if (i <= 20)
      DF = (zeros(size(DF)));
  end
  if ((max(DF(:)) > intmax('int16')) | (min(DF(:)) < intmin('int16')))
      error('integer conversion error');
  end
  
  h5write(outfile,'/Object',int16(DF),[1 1 i 1],[XDim YDim 1 1]);
end

  