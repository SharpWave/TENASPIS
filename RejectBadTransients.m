function [] = RejectBadTransients()

disp('Rejecting transients based on duration criteria');

%% load parameters
[Xdim,Ydim,MinNumFrames,SampleRate] = Get_T_Params('Xdim','Ydim','MinNumFrames','SampleRate');

%% load data
disp('Loading blob and link data');
load('BlobLinks.mat','FrameList','ObjList');

MinFrame = 60*SampleRate;

%% setup vars
NumTransients = length(FrameList);
[GoodTransient,NotTooEarly] = deal(true(1,NumTransients));

%% Analyze transient and apply criteria
disp('analyzing transients for rejection');
for i = 1:NumTransients    
    FirstFrame = FrameList{i}(1);
    LastFrame = FrameList{i}(end);
    TransientLength(i) = LastFrame-FirstFrame+1;
    
    NotTooEarly(i) = sum(ismember(1:MinFrame,FrameList{i})) == 0;    
    
    GoodTransient(i) = (TransientLength(i) >= MinNumFrames) && NotTooEarly(i);    
end


%% keep the good ones
TransientLength = TransientLength(GoodTransient);
FrameList = FrameList(GoodTransient);
ObjList = ObjList(GoodTransient);

disp(['kept ',int2str(sum(GoodTransient)),' out of ',int2str(length(GoodTransient)),' transients']);

%% save data
disp('saving good transients');
save VettedTransients.mat TransientLength FrameList ObjList;


