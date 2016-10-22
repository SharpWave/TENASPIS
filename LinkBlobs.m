function [] = LinkBlobs()
%[] = LinkBlobs()
% Load the output of ExtractBlobs.m and find sets of blobs that appear in
% the same spot on consectuive frames - putative calcium transients
%
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
%
disp('Processing blobs into calcium transient ROIs: first step is to link blobs that appear in the same spot on consecutive frames');

%% load parameters
[NumFrames,FrameChunkSize,BlobLinkThresholdCoeff] = Get_T_Params('NumFrames','FrameChunkSize','BlobLinkThresholdCoeff');

% Load Blob pixel lists and centroids
disp('Loading blobs');
load('Blobs.mat','BlobPixelIdxList','BlobWeightedCentroids','BlobMinorAxisLength');

%% set up some variables
TransientIdx = cell(1,NumFrames);
InitNumBlobs = length(BlobPixelIdxList{1});
if (InitNumBlobs > 0)
    TransientIdx{1} = (1:InitNumBlobs);
else
    TransientIdx{1} = [];
end
NextNewIdx = InitNumBlobs+1;

for i = 1:InitNumBlobs
    FrameList{i} = 1;
    ObjList{i} = i;
end

%% Run through loop to connect blobs between successive frames
p = ProgressBar(floor(NumFrames / FrameChunkSize));
disp('Linking Blobs');
for i = 2:NumFrames
    CurrNumBlobs = length(BlobPixelIdxList{i});
    PrevNumBlobs = length(BlobPixelIdxList{i-1});
    for j = 1:CurrNumBlobs
        CurrCent = BlobWeightedCentroids{i}{j};
        FoundMatch = 0;
        for k = 1:PrevNumBlobs
            PrevCent = BlobWeightedCentroids{i-1}{k};
            cdist = sqrt((PrevCent(1)-CurrCent(1))^2+(PrevCent(2)-CurrCent(2))^2);
            if (cdist < BlobMinorAxisLength{i-1}(k)*BlobLinkThresholdCoeff)
                FoundMatch = k;
                break;
            end
        end
        if (FoundMatch > 0)
            % get transient index of match
            PrevIdx = TransientIdx{i-1}(FoundMatch);
            % set this blob's transient index to match's
            TransientIdx{i}(j) = PrevIdx;
            % add this frame and object numbers to transient's bloblist
            FrameList{PrevIdx} = [FrameList{PrevIdx},i];
            ObjList{PrevIdx} = [ObjList{PrevIdx},j];
        else
            % Set up a new Transient
            TransientIdx{i}(j) = NextNewIdx;
            FrameList{NextNewIdx} = i;
            ObjList{NextNewIdx} = j;
            NextNewIdx = NextNewIdx + 1;
        end
    end
    if (mod(i,FrameChunkSize) == 0)
        p.progress;
    end
end
p.stop;

%% save outputs
disp('saving blob link information');
save BlobLinks.mat TransientIdx FrameList ObjList;
    
