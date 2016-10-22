function [ output_args ] = MakeTransientROIs()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Get parameters
[Xdim,Ydim,NumFrames,FrameChunkSize,MinPixelPresence] = Get_T_Params('Xdim','Ydim','NumFrames','FrameChunkSize','MinPixelPresence');

%% load data
load('VettedTransients.mat','FrameList','ObjList');
NumTransients = length(FrameList);

%% get pixel participation averages

end

