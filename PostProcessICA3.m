function [] = PostProcessICA2(MinSize)
% this function takes an ICA .mat file as written by Inscopix Mosaic,
% does a bit of post-processing, and hopefully spits out something
% that will form the basis for my continued employment as a scientist

% this version does the background correction in a very different
% way than the initial version.

close all;

% "Magic numbers"
NumICA = 400;
ZeroThresh = 5; % Below this the IC gets zeroed out
RingThresh = 25; % Dividing line between inside and outside of cell ROI
SR = 20; % Sampling rate in Hz
MaxDist = 25; % maximum radius from middle of ICA
LocalRad = 50;
MinRad = 20;
if (nargin == 0)
    MinSize = 50;
end


% STEP 1: Input the independent components

for i = 1:NumICA % load the ICA .mat file, put it in a data structure
    filename = ['Obj_',int2str(i),'_1 - IC filter ',int2str(i),'.mat'];
    load(filename); % loads two things, Index and Object
    IC{i} = Object(1).Data;
end

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

% STEP 2: Shape the filters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:NumICA
    % just zero out everything less than 5 
    temp = IC{i};
    temp(temp < RingThresh) = 0;
     
    FixedIC{i} = temp;
    FixedICnz{i} = find(FixedIC{i} > 0);
    COM{i} = centerOfMass(temp);
end

% Zero out IC pixels too far away from the center
for i = 1:NumICA
    center = COM{i};
    for j = 1:length(FixedICnz{i})
        [ind(1),ind(2)] = ind2sub(size(FixedIC{i}),FixedICnz{i}(j));
        d = norm(ind-center);
        if (d > MaxDist) 
            FixedIC{i}(FixedICnz{i}(j)) = 0;
        end

    end
    FixedICnz{i} = find(FixedIC{i} > 0);
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
    end
end

% Look at size distribution of IC's
for i = 1:NumICA
    ICsize(i) = length(FixedICnz{i});
end
figure(21);hist(ICsize,20);

% Add up the IC filters
All_Mask = zeros(size(IC{1}));
for i = 1:NumICA
    temp = IC{i};
    temp(find(temp < 15)) = 0;
    All_Mask = All_Mask+temp;
end
figure(10);imagesc(All_Mask);caxis([0 30]);colorbar;
Outside_Mask_idx = find(All_Mask == 0);

% STEP 3: load the frickin movie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I'm going to assume that the movie file is in the same directory as the 
% IC .mat files.  

display('Loading movie data');

%MovieData =  % MovieData dims are X,Y,T
tempData = h5read('ICmovie.h5','/Object',[1 1 1 1],[1 1 Inf 1]);
disp('determined number of frames');
NumFrames = length(tempData);
t = (1:NumFrames)/SR;

% STEP 4: Use filters to get traces %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make radius based masks for the IC's
for i = 1:NumICA
  c = COM{i};
  if (isempty(c))
      rmask{i} = zeros(size(IC{1}));
      rmasknz{i} = [];
      tidx{i} = [];
      continue;
  end
  
  for k = 1:Xdim
      for l = 1:Ydim
         rmask{i}(k,l) = (norm([k l]-c) < LocalRad) && (norm([k l]-c) > MinRad);
      end
  end  
  rmasknz{i} = find(rmask{i}(:) > 0);
  tidx{i} = intersect(rmasknz{i},Outside_Mask_idx);
end

% Just set the masks to all ones
for i = 1:NumICA
    FixedIC{i}(FixedICnz{i}) = 1;
end


for j = 1:NumFrames
  tempIn = h5read('ICmovie.h5','/Object',[1 1 j 1],[Xdim Ydim 1 1]);  
  tempFrame = double(tempIn);
  display(['Calculating F traces for movie frame ',int2str(j),' out of ',int2str(NumFrames)]);

    for i = 1:NumICA
      % Calculate foreground 
      
      FLData(i,j) = sum(sum(tempFrame(FixedICnz{i})))./length(FixedICnz{i});
      
      % Calculate background
      tempBG = tempFrame(tidx{i});
      %BGr(i,j) = sum(sum(tempFrame(tidx{i})))./length(tidx{i});
      BGr(i,j) = median(tempBG(:));
    end
end



% STEP 5: Compensate the fluorescence signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:NumICA
    CFLData(i,:) = FLData(i,:)-BGr(i,:);
    CFLData(i,:) = CFLData(i,:)-mode(CFLData(i,:));
    CFLData(i,:) = CFLData(i,:)./std(CFLData(i,:));
end


% Step 6: Manually step through
figure(1);
for i = 1:NumICA
    if (isnan(CFLData(i,1)) || (ICsize(i) < MinSize))
        GoodIC(i) = 0;
        continue;
    end
    
    subplot(2,1,1);imagesc(FixedIC{i});axis square;caxis([0 1]);
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


save FLdata.mat GoodFLData GoodCom GoodICf;

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


%GoodFLData(find(GoodFLData < 4)) = 0;

[r,p] = corr(GoodFLData');

figure(3);
imagesc(r);

figure(4);
plot(r(:),ICdistance(:),'*')





keyboard;



    



