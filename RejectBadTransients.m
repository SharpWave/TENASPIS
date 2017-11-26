    function [] = RejectBadTransients()
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    close all;
    DebugPlots = 0;

    disp('Rejecting transients based on centroid travel distance and duration criteria');

    %% load parameters
    [Xdim,Ydim,MinNumFrames,MaxCentroidTravelDistance] = Get_T_Params('Xdim','Ydim','MinNumFrames','MaxCentroidTravelDistance');

    %% load data
    disp('Loading blob and link data');
    load('BlobLinks.mat');


    %% setup vars
    NumTransients = length(FrameList);
    [GoodTransient,NotFirstFrame] = deal(true(1,NumTransients));

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

        if (DebugPlots)
            if (GoodTransient(i))
          figure(1);
          for j = FirstFrame:LastFrame
              temp = zeros(Xdim,Ydim);

              ObjNum = ObjList{i}(j-FirstFrame+1);
              try
              temp(BlobPixelIdxList{j}{ObjNum}) = 1;

              PlotRegionOutline(temp);
              end
          end
          display(['travel distance ',num2str(TravelDist(i))]);GoodTransient(i),
          
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


