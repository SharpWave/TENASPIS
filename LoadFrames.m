function [frames] = LoadFrames(file,framenums)
% [frames] = loadframe(file,framenums)
%
% Loads frames from an h5 file
%
% INPUTS:
%   file: fullpath to h5 file
%
%   framenums: frame numbers of file to load
%
% OUTPUTS:
%   frames: an array of the frames you loaded
%
%%
% Copyright 2015 by David Sullivan, Nathaniel Kinsky, and William Mau
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

%% Get parameters & find filetype
try
    [Xdim,Ydim,~,tstack] = Get_T_Params('Xdim','Ydim','NumFrames','tstack');

catch % Set T_PARAMS if not already done
    Set_T_Params(file)
    [Xdim,Ydim,~,tstack] = Get_T_Params('Xdim','Ydim','NumFrames','tstack');
end
[~,~,ext] = fileparts(file); % Get filetype
filetype = ext(2:end);

%% find sets of consecutive frames in framenums and grab their indices
fmap = zeros(1,max(framenums));
fmap(framenums) = 1;
fep = NP_FindSupraThresholdEpochs(fmap,eps,0);
loadchunks = [];

for i = 1:size(fep,1)
    chunksize = fep(i,2)-fep(i,1)+1;
    loadchunks(i,1:2) = [fep(i,1),chunksize];
end

%% load the frames
curr = 1;

frames = zeros(Xdim,Ydim,length(framenums),'single');

switch filetype
    case 'h5'
        for i = 1:size(fep,1)
            frames(:,:,curr:(curr+loadchunks(i,2)-1)) = ...
                h5read(file,'/Object',[1 1 loadchunks(i,1) 1],...
                [Xdim Ydim loadchunks(i,2) 1]);
            curr = curr+loadchunks(i,2);
        end
    case {'tiff','tif'}
        if isempty(tstack)
            tstack = TIFFStack(file);
        end
        for i = 1:size(fep,1)
            frames(:,:,curr:(curr+loadchunks(i,2)-1)) = ...
                tstack(:,:,loadchunks(i,1):(sum(loadchunks(i,:))-1));
            curr = curr+loadchunks(i,2);
        end
        
    otherwise
        error('files must be in either h5 or tiff format')
        
end

end