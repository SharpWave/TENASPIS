function [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim, min_trans_length)
% [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim)
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

% If min_trans_length is not specified, set it as default (5).
if ~exist('min_trans_length','var')
    min_trans_length = 5;
end

% create segment averages
parfor i = 1:NumSegments
    display(['initializing transient # ',int2str(i)]);
    [PixelList{i},Xcent(i),Ycent(i),MeanArea(i),frames{i}] = AvgTransient(SegChain{i},cc,Xdim,Ydim);
    length(SegChain{i})
    
    GoodTr(i) = 1;
    
    if (MeanArea(i) < 60)
        GoodTr(i) = 0;
    end
    
    if (MeanArea(i) > 160)
        GoodTr(i) = 0;
    end
end

% edit out the faulty segments
GoodTrs = find(GoodTr);
PixelList = PixelList(GoodTrs);
Xcent = Xcent(GoodTrs);
Ycent = Ycent(GoodTrs);
MeanArea = MeanArea(GoodTrs);
frames = frames(GoodTrs);

c = (1:length(frames))'; 

[PixelList,meanareas,meanX,meanY,NumEvents] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent);

save_name = ['InitClu_minlength_' num2str(min_trans_length) '.mat'];
if min_trans_length == 5
    save InitClu.mat c Xdim Ydim PixelList Xcent Ycent frames meanareas meanX meanY NumFrames NumEvents GoodTrs min_trans_length -v7.3;
elseif min_trans_length ~= 5
     save(save_name,'c', 'Xdim', 'Ydim', 'PixelList', 'Xcent', 'Ycent', 'frames',...
         'meanareas', 'meanX', 'meanY', 'NumFrames', 'NumEvents', 'GoodTrs', 'min_trans_length', '-v7.3');
end
    

end

