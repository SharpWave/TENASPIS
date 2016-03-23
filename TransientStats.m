function [DistTrav] = TransientStats(SegChain)
% [DistTrav,Ac,Xc,Yc] = TransientStats(SegChain)
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
% For each detected calcium transient, track evolution of area and centroid

load Blobs.mat;

DistTrav = zeros(1,length(SegChain));
Xc = cell(1,length(SegChain);
Yc = cell(1,length(SegChain); 
for i = 1:length(SegChain)
    % for each transient
    
    for j = [1,length(SegChain{i})]
        % for each frame in the transient
        frame = SegChain{i}{j}(1);
        seg = SegChain{i}{j}(2);
        r = regionprops(cc{frame},'Centroid');
        
        
        Xc{i}(j) = r(seg).Centroid(1);
        Yc{i}(j) = r(seg).Centroid(2);
        

    end
    DistTrav(i) = sqrt((Xc{i}(end)-Xc{i}(1))^2+(Yc{i}(end)-Yc{i}(1))^2);

end
% 
% 
% keyboard;
% % BrowseThrough
% for i = 1:NumSegments
%     subplot(1,2,1);plot(Ac{i});xlabel('frame');ylabel('area of blob')'
%     subplot(1,2,2);plot(Xc{i},Yc{i});xlabel('x centroid');ylabel('y centroid');
%     set(gca,'Xlim',[0 Xdim],'Ylim',[0 Ydim])
%     pause;
% end
% keyboard;




end

