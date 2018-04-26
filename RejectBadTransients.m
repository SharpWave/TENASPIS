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
[GoodTransient,NotFirstFrame] = deal(true(1,NumTransients));
reject_reason = cell(1,NumTransients);

%% Analyze transient and apply criteria
disp('analyzing transients for rejection');
for i = 1:NumTransients
    FirstFrame = FrameList{i}(1);
    LastFrame = FrameList{i}(end);
    TransientLength(i) = LastFrame-FirstFrame+1;
    
    FirstCent = BlobWeightedCentroids{FirstFrame}{ObjList{i}(1)};
    LastCent = BlobWeightedCentroids{LastFrame}{ObjList{i}(end)};
    TravelDist(i) = sqrt((FirstCent(1)-LastCent(1))^2+(FirstCent(2)-LastCent(2))^2);
    
    NotFirstFrame(i) = ~ismember(1,FrameList{i});
    
    GoodTransient(i) = (TransientLength(i) >= MinNumFrames) && (TravelDist(i) < MaxCentroidTravelDistance) && NotFirstFrame(i);
    if ~GoodTransient(i)
        if TransientLength(i) < MinNumFrames
            reject_reason{i} = 'too short';
        end
        if TravelDist(i) >= MaxCentroidTravelDistance
            reject_reason{i} = [reject_reason{i} ' + moves too much'];
        end
        if ~NotFirstFrame(i)
           reject_reason{i} = [reject_reason{i} ' + 1st frame'];
        end
    end
end

%% optional plotting
figure
subplot(1,2,1);
histogram(TransientLength,0:100);xlabel('transient length');
subplot(1,2,2);
histogram(TravelDist,0:0.1:15);xlabel('travel distance');

%% save data for analysis purposes
save TransientStats.mat TransientLength TravelDist reject_reason;

%% keep the good ones
TravelDist = TravelDist(GoodTransient);
TransientLength = TransientLength(GoodTransient);
FrameList = FrameList(GoodTransient);
ObjList = ObjList(GoodTransient);

disp(['kept ',int2str(sum(GoodTransient)),' out of ',int2str(length(GoodTransient)),' transients']);

%% save data
disp('saving good transients');
save VettedTransients.mat TravelDist TransientLength FrameList ObjList;


