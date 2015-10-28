function [] = ExtractBlobs(file,todebug,thresh,mask)
% [] = ExtractBlobs(file,todebug,thresh,mask)
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
% extract active cell "blobs" from movie in file
% todebug 0 or 1 depending if you want to go through frame-by-frame
% thresh is initial threshold (try BlobStats for thresh determination)
% mask is the binary mask of which areas to use and not to use
% use MakeBlobMask to make a mask

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);



if (nargin < 4)
    mask = ones(Xdim,Ydim);
end
oldmask = mask;

initareas = [];

parfor i = 1:NumFrames
    
    tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    
    if (i <= 20)
        % Don't detect neurons on first 20 frames
        mask = zeros(Xdim,Ydim);
    else
        mask = oldmask;
    end
    
    [~,cc{i},ccprops{i},initareas_tmp] = SegmentFrame(tempFrame,0,mask,thresh);
    initareas = [initareas,initareas_tmp];

    display(['Detecting Blobs for frame ',int2str(i)]);

end

keyboard;


save CC.mat cc ccprops thresh mask;



            
