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
[NumFrames,FrameChunkSize,Xdim,Ydim] = Get_T_Params('NumFrames','FrameChunkSize','Xdim','Ydim');

% max number of samples to interpolate places where a transient skips frames

GapFillLen = 0;

% Load Blob pixel lists and centroids
disp('Loading blobs');
load('Blobs.mat','BlobPixelIdxList','BlobWeightedCentroids');

%% set up some variables
TransientIdx = cell(1,NumFrames);

% Count the number of blobs in each frame
NumBlobs = zeros(1,NumFrames);
for i = 1:NumFrames
    NumBlobs(i) = length(BlobPixelIdxList{i});
end

CurrIdx = 1;

for i = 1:1+GapFillLen       
    if (NumBlobs(i) == 0)  
        TransientIdx{i} = [];
        continue;
    end
   
    for j = 1:NumBlobs(i)
       TransientIdx{i}(j) = CurrIdx;
       FrameList{CurrIdx} = i;
       ObjList{CurrIdx} = j;
       CurrIdx = CurrIdx+1;
    end
     
end
NextNewIdx = CurrIdx;

%% Run through loop to connect blobs between successive frames
p = ProgressBar(floor(NumFrames / FrameChunkSize));
disp('Linking Blobs');

for i = 2+GapFillLen:NumFrames
    
    for j = 1:NumBlobs(i)
        CurrCent = BlobWeightedCentroids{i}{j};
        CurrCentIdx = sub2ind([Xdim Ydim],ceil(CurrCent(2)),ceil(CurrCent(1)));
        FoundMatch = 0;
        SamplesToCheck = (i-1:-1:i-1-GapFillLen)
        CurrSamp = i-1;
        while (~FoundMatch && CurrSamp >= SamplesToCheck(end))
            for k = 1:NumBlobs(CurrSamp)
                PrevCent = BlobWeightedCentroids{CurrSamp}{k};
                PrevIdxList = BlobPixelIdxList{CurrSamp}{k};
                
                CentDist = sqrt((PrevCent(1)-CurrCent(1)).^2+(PrevCent(2)-CurrCent(2)).^2);
                
                if (CentDist < 1.2)%(ismember(CurrCentIdx,PrevIdxList))
                    FoundMatch = k;
                    MatchSamp = CurrSamp;
                    break;
                end
            end
            CurrSamp = CurrSamp-1;
        end
        if (FoundMatch > 0)
            % get transient index of match
            PrevIdx = TransientIdx{MatchSamp}(FoundMatch);
            % set this blob's transient index to match's
            TransientIdx{i}(j) = single(PrevIdx);
            % add this frame and object numbers to transient's bloblist
            
            
            % add blob to skipped samples

            for k = MatchSamp+1:i-1
                NumBlobs(k) = NumBlobs(k)+1;
                BlobPixelIdxList{k}{NumBlobs(k)} = BlobPixelIdxList{i}{j};
                BlobWeightedCentroids{k}{NumBlobs(k)} = BlobWeightedCentroids{i}{j};
                TransientIdx{k}(NumBlobs(k)) = PrevIdx;
                FrameList{PrevIdx} = [FrameList{PrevIdx},single(k)];
                ObjList{PrevIdx} = [ObjList{PrevIdx},single(NumBlobs(k))];
            end
            FrameList{PrevIdx} = [FrameList{PrevIdx},single(i)];
            ObjList{PrevIdx} = [ObjList{PrevIdx},single(j)];
            
        else
            % Set up a new Transient
            TransientIdx{i}(j) = single(NextNewIdx);
            FrameList{NextNewIdx} = single(i);
            ObjList{NextNewIdx} = single(j);
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

save BlobLinks.mat TransientIdx FrameList ObjList BlobPixelIdxList BlobWeightedCentroids;

