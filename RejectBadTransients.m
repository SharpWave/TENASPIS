function [] = RejectBadTransients()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

disp('Rejecting transients based on centroid travel distance and duration criteria');

%% load parameters
[MinNumFrames,MaxCentroidTravelDistance] = Get_T_Params('MinNumFrames','MaxCentroidTravelDistance');

%% load data
disp('Loading blob and link data');
load('BlobLinks.mat','FrameList','ObjList');
load('Blobs.mat','BlobWeightedCentroids');

%% setup vars
NumTransients = length(FrameList);
GoodTransient = true(1,NumTransients);

%% Analyze transient and apply criteria
disp('analyzing transients for rejection');
for i = 1:NumTransients
    FirstFrame = FrameList{i}(1);
    LastFrame = FrameList{i}(end);
    TransientLength(i) = LastFrame-FirstFrame+1;
    
    FirstCent = BlobWeightedCentroids{FirstFrame}{ObjList{i}(1)};
    LastCent = BlobWeightedCentroids{LastFrame}{ObjList{i}(end)};
    TravelDist(i) = sqrt((FirstCent(1)-LastCent(1))^2+(FirstCent(2)-LastCent(2))^2);
    
    GoodTransient(i) = (TransientLength(i) >= MinNumFrames) && (TravelDist(i) < MaxCentroidTravelDistance);
end

%% save data for analysis purposes
save TransientStats.mat TransientLength TravelDist;

%% keep the good ones
TravelDist = TravelDist(GoodTransient);
TransientLength = TransientLength(GoodTransient);
FrameList = FrameList(GoodTransient);
ObjList = ObjList(GoodTransient);

disp(['kept ',int2str(sum(GoodTransient)),' out of ',int2str(length(GoodTransient)),' transients']);

%% save data
disp('saving good transients');
save VettedTransients.mat TravelDist TransientLength FrameList ObjList;


