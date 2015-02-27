function [] = PostProcessICA()
% this function takes an ICA .mat file as written by Inscopix Mosaic,
% does a bit of post-processing, and hopefully spits out something
% that will form the basis for my continued employment as a scientist

close all;

% "Magic numbers"
NumICA = 400;
ZeroThresh = 5; % Below this the IC gets zeroed out
RingThresh = 15; % Dividing line between inside and outside of cell ROI
SR = 20; % Sampling rate in Hz
MaxDist = 25; % maximum radius from middle of ICA

% STEP 1: Input the independent components

for i = 1:NumICA % load the ICA .mat file, put it in a data structure
    filename = ['Obj_',int2str(i),'_1 - IC filter ',int2str(i),'.mat'];
    load(filename); % loads two things, Index and Object
    IC{i} = Object(1).Data;
end

Xdim = size(IC{1},1);
Ydim = size(IC{1},2);


% STEP 2: Fix the filter(s)

for i = 1:NumICA
    % just zero out everything less than 5 
    temp = IC{i};
    tempOut = IC{i};
    
    temp(temp < RingThresh) = 0;
    
    tempOut(tempOut < ZeroThresh) = 0;
    COM{i} = centerOfMass(tempOut);
    
    tempOut(tempOut > RingThresh) = 0;
    FixedIC{i} = temp;
    FixedICnz{i} = find(FixedIC{i} > 0);
    FixedICOut{i} = tempOut;
    FixedICOutnz{i} = find(FixedICOut{i} > 0);
end

% Fix overly large or not-contiguous filters
for i = 1:NumICA
    center = COM{i};
    for j = 1:length(FixedICnz{i})
        [ind(1),ind(2)] = ind2sub(size(FixedIC{i}),FixedICnz{i}(j));
        d = norm(ind-center);
        if (d > MaxDist) 
            
            FixedIC{i}(FixedICnz{i}(j)) = 0;
        end
    end
    
    for j = 1:length(FixedICOutnz{i})
        [ind(1),ind(2)] = ind2sub(size(FixedIC{i}),FixedICOutnz{i}(j));
        d = norm(ind-center);
        if (d > MaxDist) 
            FixedICOut{i}(FixedICOutnz{i}(j)) = 0;
        end
    end
    
    FixedICnz{i} = find(FixedIC{i} > 0);
    FixedICOutnz{i} = find(FixedICOut{i} > 0);

    COM{i} = centerOfMass(FixedIC{i});
 
end

        
        

% Fix overlapping sections
for i = 1:NumICA
    for j = 1:NumICA
        
        if (i == j) continue;end; % 
        
        % Check for overlap between inside and inside
        common = intersect(FixedICnz{i}(:),FixedICnz{j}(:));
        if (length(common) > 0) % we got some overlap, zero out both
            FixedIC{i}(common) = 0;
            FixedIC{j}(common) = 0;
            FixedICnz{i} = find(FixedIC{i} > 0);
            FixedICnz{j} = find(FixedIC{j} > 0);
        end
        
        % Check for overlap between inside and outside
        common = intersect(FixedICnz{i}(:),FixedICOutnz{j}(:));
        if (length(common) > 0) % we got some overlap, fix it
            FixedICOut{j}(common) = 0;
            FixedICOutnz{j} = find(FixedICOut{j} > 0);
        end
        
        
    end
end

            



% STEP 3: load the frickin movie
% I'm going to assume that the movie file is in the same directory as the 
% IC .mat files.  

display('Loading movie data');

MovieData = h5read('ICmovie.h5','/Object'); % MovieData dims are X,Y,T
NumFrames = size(MovieData,3);
t = (1:NumFrames)/SR;

% STEP 4: Use filters to get traces
for j = 1:NumFrames
  tempFrame = double(squeeze(MovieData(:,:,j)));
  display(['Calculating F traces for movie frame ',int2str(j),' out of ',int2str(NumFrames)]);
    for i = 1:NumICA
      FLData(i,j) = sum(sum(FixedIC{i}(FixedICnz{i}).*tempFrame(FixedICnz{i}))); 
      FLDataOut(i,j) = sum(sum(FixedICOut{i}(FixedICOutnz{i}).*tempFrame(FixedICOutnz{i})));
    end
end

% STEP 5: Compensate the fluorescence signal
for i = 1:NumICA
    MeanRatio = mean(FLData(i,:))/mean(FLDataOut(i,:));
    CFLData(i,:) = (FLData(i,:)-MeanRatio*FLDataOut(i,:));
    CFLData(i,:) = zscore(NP_QuickFilt(CFLData(i,:),0.01,4,SR));
end

% Step 6: Manually step through
figure(1);
for i = 1:NumICA
    subplot(2,1,1);imagesc(FixedIC{i}+FixedICOut{i});axis square;caxis([0 15]);
    subplot(2,1,2);plot(t,CFLData(i,:))
    ToKeep = input([int2str(i),' Keep this one or not? [y,n] --->'],'s');
    if (strcmp(ToKeep,'y') ~= 1)
        GoodIC(i) = 0;
    else
        GoodIC(i) = 1;
    end
end

% Step 7: Keep the good ones
GoodICidx = find(GoodIC == 1);
NumGood = length(GoodICidx);
GoodFLData = CFLData(GoodICidx,:);
GoodCom = COM(GoodICidx);
GoodICf = FixedIC(GoodICidx);
GoodICOut = FixedICOut(GoodICidx);

%save FLdata.mat GoodFLData GoodCom GoodIC GoodICOut MovieData

AllIC = zeros(size(GoodICf{1}));

for i = 1:length(GoodICidx)
    AllIC = AllIC + GoodICf{i};
end
figure(2);imagesc(AllIC);

for i = 1:NumGood
    for j = 1:NumGood
        p1 = GoodCom{i};
        p2 = GoodCom{j};
        ICdistance(i,j) = norm(p1-p2);
    end
end

[r,p] = corr(GoodFLData');

figure(3);
imagesc(r);

figure(4);
plot(r(:),ICdistance(:),'*')



keyboard;



    



