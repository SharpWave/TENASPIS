function [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,FrameList,ObjList] = UpdateClusterInfo(FoodClu,PixelList,PixelAvg,BigPixelAvg,CircMask,...
    Xcent,Ycent,FrameList,ObjList,EaterClu)
% [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,FrameList,ObjList] = UpdateClusterInfo(FoodClus,PixelList,PixelAvg,BigPixelAvg,CircMask,...
%    Xcent,Ycent,FrameList,ObjList,EaterClu)
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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
%% Get params
[Xdim,Ydim,threshold] = Get_T_Params('Xdim','Ydim','threshold');

%% setup variables for averaging the pixels together
tempFrameCount = zeros(size(CircMask{EaterClu}),'single');
tempAvg = zeros(size(CircMask{EaterClu}),'single');
blankframe = zeros(Xdim,Ydim,'single');

%% union the Food pixel lists into the eater pixel lists
for j = 1:length(FoodClu)
    PixelList{EaterClu} = union(PixelList{EaterClu},PixelList{FoodClu(j)});
end

%% for each cluster, add pixels that overlap with the currclu circmask
AllClu = [EaterClu,FoodClu];
for j = 1:length(AllClu)    
    [binans,firstidx] = ismember(CircMask{EaterClu},CircMask{AllClu(j)});
    okpix = find(binans);    
    tempFrameCount(okpix) = tempFrameCount(okpix)+length(FrameList{AllClu(j)});
    tempAvg(okpix) = tempAvg(okpix)+BigPixelAvg{AllClu(j)}(firstidx(okpix))*length(FrameList{AllClu(j)});    
end
% take the mean
tempAvg = tempAvg./tempFrameCount;
BigPixelAvg{EaterClu} = tempAvg;

%% concatenate the framelists and objlists
for j = 1:length(FoodClu)
    FrameList{EaterClu} = [FrameList{EaterClu},FrameList{FoodClu(j)}];
    ObjList{EaterClu} = [ObjList{EaterClu},ObjList{FoodClu(j)}];
end

%% update ROI
tempFrame = blankframe;
tempFrame(CircMask{EaterClu}) = BigPixelAvg{EaterClu};
threshFrame = tempFrame > threshold;
b = bwconncomp(threshFrame,4);
for i = 1:b.NumObjects
    if(~isempty(intersect(b.PixelIdxList{i},PixelList{EaterClu})))
        break;
    end
end

if(isempty(intersect(b.PixelIdxList{i},PixelList{EaterClu})))
   error('I think we ate a cluster and need to deal with that');
end

PixelList{EaterClu} = single(b.PixelIdxList{i});
PixelAvg{EaterClu} = tempFrame(PixelList{EaterClu});

%% update centroid
tempbin = blankframe;
tempbin(PixelList{EaterClu}) = 1;
tempval = blankframe;
tempval(PixelList{EaterClu}) = PixelAvg{EaterClu};
props = regionprops(tempbin,tempval,'WeightedCentroid');
Xcent(EaterClu) = single(props.WeightedCentroid(1));
Ycent(EaterClu) = single(props.WeightedCentroid(2));

end