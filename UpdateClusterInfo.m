function [PixelList,PixelAvg,BigPixelAvg,Xcent,Ycent,FrameList,ObjList] = UpdateClusterInfo(FoodClu,PixelList,PixelAvg,BigPixelAvg,CircMask,...
    Xcent,Ycent,FrameList,ObjList,EaterClu,BlobPixelIdxList)
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

%% figure out the frequency of the pixels in the blobs in all of the transients to determine the new ROI
tempPixFreqs = CalcPixFreq(FrameList{EaterClu},ObjList{EaterClu},BlobPixelIdxList)*length(FrameList{EaterClu});
totalframes = length(FrameList{EaterClu});

for j = 1:length(FoodClu)
    tempPixFreqs = tempPixFreqs+CalcPixFreq(FrameList{FoodClu(j)},ObjList{FoodClu(j)},BlobPixelIdxList)*length(FrameList{FoodClu(j)});
    totalframes = totalframes + length(FrameList{FoodClu(j)});    
end
tempPixFreqs = tempPixFreqs/totalframes;
% set new ROI
PixelList{EaterClu} = find(tempPixFreqs >= 0.5);

%% sum up the pixels in the neighborhood of the new cluster
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
    FrameList{FoodClu(j)} = [];
    ObjList{FoodClu(j)} = [];
    PixelList{FoodClu(j)} = [];
    PixelAvg{FoodClu(j)} = [];
    BigPixelAvg{FoodClu(j)} = [];
    Xcent(FoodClu(j)) = NaN;
    Ycent(FoodClu(j)) = NaN;
end

%% update ROI
tempFrame = blankframe;
tempFrame(CircMask{EaterClu}) = BigPixelAvg{EaterClu};

PixelAvg{EaterClu} = tempFrame(PixelList{EaterClu});

[~,idx] = max(PixelAvg{EaterClu});
[Ycent(EaterClu),Xcent(EaterClu)] = ind2sub([Xdim Ydim],PixelList{EaterClu}(idx));

end