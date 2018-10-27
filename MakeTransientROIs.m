function [] = MakeTransientROIs()

% The idea is that calcium transient segmentation is less noisy during the
% rise than during the fall - we're gonna chop the portion of the
% transients with the fall so that the ROIs are cleaner

[Xdim,Ydim,MinNumFrames,SampleRate] = Get_T_Params('Xdim','Ydim','MinNumFrames','SampleRate');
MinPixelFrequency = 0.2;

%% load data
disp('Loading blob and link data');
load('BlobLinks.mat');

global T_MOVIE;

NumTransients = length(FrameList);
GoodTransient = true(length(FrameList),1);

for i = 1:NumTransients
    if ((length(FrameList{i}) <= 5) )
        GoodTransient(i) = false;
        continue;
    end
    BlobUnion = [];
    for j = 1:length(FrameList{i})
        Blob = BlobPixelIdxList{FrameList{i}(j)}{ObjList{i}(j)};
        BlobUnion = [BlobUnion;Blob];
    end
    
    Cent1 = BlobWeightedCentroids{FrameList{i}(1)}{ObjList{i}(1)};
    
    % make a trace for this thing
    TempTrace = CalcROITrace(BlobUnion,FrameList{i});
    
    % First sample of trace is detection level
    % anything less than detection level gets tossed
    % Remaining rising samples are ok
    % falling samples greater than half the peak height are ok
    
    DetectionLevel = TempTrace(1);
    GoodFrame = true(length(TempTrace),1);
    GoodFrame(TempTrace < DetectionLevel) = false;
    Slopes = [0,diff(TempTrace)];
    HalfPeak = max(TempTrace)/2;
    GoodFrame((Slopes < 0) & (TempTrace < HalfPeak)) = false;
    
    GreenFrames = find(GoodFrame == true);
    
    % check for minimum # of frames again
    if (length(GreenFrames) <= 5)
        GoodTransient(i) = false;
        continue;
    end
    
    % check travel distance
    LastGreen = GreenFrames(end);
    Cent2 = BlobWeightedCentroids{FrameList{i}(LastGreen)}{ObjList{i}(LastGreen)};
    TravelDist = sqrt((Cent1(1)-Cent2(1)).^2+(Cent1(2)-Cent2(2)).^2);
    if (TravelDist > 6)
        GoodTransient(i) = false;
        continue;
    end

    AllGreenPixels = [];
    for j = 1:length(GreenFrames)
        TI(i).Blob{j} = BlobPixelIdxList{FrameList{i}(GreenFrames(j))}{ObjList{i}(GreenFrames(j))};
        AllGreenPixels = [AllGreenPixels;TI(i).Blob{j}];       
    end
    
    [GreenBlob,~,ic] = unique(AllGreenPixels);
    Green_freq = accumarray(ic,1)/length(GreenFrames);
    idx = find(Green_freq >= MinPixelFrequency);
    
    % save the info
    TI(i).ROIidx = GreenBlob(idx);
    TI(i).FrameList = GreenFrames;
end
TI = TI(GoodTransient);
save TI.mat TI;
    

end

