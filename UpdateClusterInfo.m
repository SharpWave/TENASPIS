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

OrigEaterList = PixelList{EaterClu};

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


tempthresh = threshold;

okmerge = false;
while ((~okmerge) && (tempthresh < max(tempFrame(:))))
    tempthresh = tempthresh+threshold/20;
    pidxlist = SegmentFrame(tempFrame,[],false,tempthresh);
    while (isempty(pidxlist)&& (tempthresh < max(tempFrame(:))))
        tempthresh = tempthresh+threshold/20;
        pidxlist = SegmentFrame(tempFrame,[],false,tempthresh);
    end
    
    % find the matching segment
    for i = 1:length(pidxlist)
        if any(ismember(OrigEaterList,pidxlist{i}))
            [~,idx] = max(tempFrame(pidxlist{i}));
            if (ismember(pidxlist{i}(idx),OrigEaterList))
                okmerge = true;
                break;
            end
        end
        
    end
    
end

if (tempthresh < max(tempFrame(:)))
   PixelList{EaterClu} = single(pidxlist{i});
end

PixelAvg{EaterClu} = tempFrame(PixelList{EaterClu});

[~,idx] = max(PixelAvg{EaterClu});
[Ycent(EaterClu),Xcent(EaterClu)] = ind2sub([Xdim Ydim],PixelList{EaterClu}(idx));

%% update centroid
% tempbin = blankframe;
% tempbin(PixelList{EaterClu}) = 1;
% tempval = blankframe;
% tempval(PixelList{EaterClu}) = PixelAvg{EaterClu};
% props = regionprops(tempbin,tempval,'WeightedCentroid');
% Xcent(EaterClu) = single(props.WeightedCentroid(1));
% Ycent(EaterClu) = single(props.WeightedCentroid(2));

end