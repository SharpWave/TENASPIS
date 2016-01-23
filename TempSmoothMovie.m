function [] = TempSmoothMovie(infile,outfile,smoothfr);
% [] = TempSmoothMovie(infile,outfile,smoothfr);
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

smfun = hann(smoothfr)./sum(hann(smoothfr));

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','single');

for i = 1:smoothfr-1
    F{i} = single(h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]));
    h5write(outfile,'/Object',F{i},[1 1 i 1],[XDim YDim 1 1]);
end

disp('Smoothing frames...');
p = ProgressBar(NumFrames);
for i = smoothfr:NumFrames
  F{smoothfr} = single(h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]));
  Fout = zeros(size(F{1}));
  for j = 1:smoothfr
    Fout = Fout+F{j}.*smfun(j);
  end
  h5write(outfile,'/Object',Fout,[1 1 i 1],[XDim YDim 1 1]);

  for j = 1:smoothfr-1
      F{j} = F{j+1};
  end
  p.progress;
end
p.stop;

end

  