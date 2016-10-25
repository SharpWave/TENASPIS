function [PixelAvg] = AvgChunk(FrameChunk,FrameList,NumInputs,NumROIs,PixelIdx,ActBool)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Get Parameters
[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');

%% Load Chunk
%% MOVE THE LOAD TO HERE TO SAVE ON RAM

PixelAvg = cell(1,NumInputs);
for i = 1:NumInputs
    PixelAvg{i} = cell(1,NumROIs(i));
    for j = 1:NumROIs(i)
        ROIchunk = zeros(length(PixelIdx{i}{j}),sum(ActBool{i}{j}(FrameList)),'single');
        
        % REWRITE THIS TO KILL THIS LAST LOOP BECAUSE ITS WAY SLOWER
        % DESPITE ADDING MANY FEWER NUMBERS - THE COST OF BUILDING DATA
        % STRUCTURES IS TOO BIG
        
        for k = 1:length(PixelIdx{i}{j})
            [idx1,idx2]= ind2sub([Xdim Ydim],PixelIdx{i}{j}(k));
            
            ROIchunk(k,:) = squeeze(FrameChunk(idx1,idx2,ActBool{i}{j}(FrameList)));            
            
        end
        PixelAvg{i}{j} = sum(ROIchunk,2);
    end
end

end

