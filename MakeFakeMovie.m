function [ output_args ] = MakeFakeMovie(seed)
% Makes a fake dataset


rng(seed);
%% Set Parameters

Xdim = 200;
Ydim = 200;

NeuronRad = 5;
MaxDist = 6;
BorderBuff = 40;

NeuronDensity = 0.005;
NumNeurons = round(NeuronDensity*(Xdim-2*BorderBuff)*(Ydim-2*BorderBuff));
%NumNeurons = 150;
NumFrames = 20000;
RiseLen = 12;
decrate = 0.965;
pAct = 0.001;
FilterDev = 7;
save FakeParams.mat Xdim Ydim NeuronRad MaxDist BorderBuff NumNeurons NumFrames RiseLen decrate pAct FilterDev seed;

%% Set up ROIs
RiseInc = 1/RiseLen;

RiseSweep = (1/RiseLen:1/RiseLen:1);

BackgroundF = 1.5;



TraceMat = zeros(NumNeurons,NumFrames);
PSAbool = false(NumNeurons,NumFrames);

LowPassFilter = fspecial('gaussian',[100 100],FilterDev);
LowPassFilter = LowPassFilter;
h5create('fake.h5','/Object',[Xdim Ydim NumFrames 1],'ChunkSize',...
    [Xdim Ydim 1 1],'Datatype','single');



% part 1: the neurons

Cents = [];
p = ProgressBar(NumNeurons);

BigAvg = zeros(Xdim,Ydim);

for i = 1:NumNeurons
    % 1. set x and y centroid randomly
    
    FoundGoodCent = false;
    
    while(~FoundGoodCent)
        %   a. choose centroid randomly
        tempCent(1,1) = ceil(rand*Xdim);
        tempCent(1,2) = ceil(rand*Ydim);
        
        %   b.0 check range
        if tempCent(1,1) <= BorderBuff | tempCent(1,1) > Xdim-BorderBuff | tempCent(1,2) <= BorderBuff | tempCent(1,2) > Ydim-BorderBuff
            continue;
        end
        
        %   b. check whether too close
        tempdist = pdist([Cents;tempCent]);
        tempdist = squareform(tempdist);
        tempdist(i,i) = Inf;
        
        if (~any(tempdist(i,:) < MaxDist))
            Cents(i,:) = tempCent;
            FoundGoodCent = true;
        end
    end

    % 2. set pixels based on centroid
    CircMask{i} = MakeCircMask(Xdim,Ydim,NeuronRad,tempCent(1,1),tempCent(1,2));
    
    % 3. create spike trains
    CurrFrame = 2;
    InRise = false;
    RiseBank = 0;
    
    while (CurrFrame <= NumFrames)
        if (InRise)
            TraceMat(i,CurrFrame) = TraceMat(i,CurrFrame-1)+RiseInc;
            PSAbool(i,CurrFrame) = true;
            CurrFrame = CurrFrame + 1;
            
            RiseBank = RiseBank - RiseInc;
            if (RiseBank <= 0)
                InRise = false;                
            end
            
            continue;
        end
        
        % not in a rise
        if (rand < pAct)
            % start a new rise
            InRise = true;
            RiseBank = 1;
            continue;
        else
            TraceMat(i,CurrFrame) = TraceMat(i,CurrFrame-1)*decrate;
            PSAbool(i,CurrFrame) = true;
            CurrFrame = CurrFrame + 1;
        end
    end
        
    
    %   b. model somatic GCaMP decays
    try
    BigAvg(CircMask{i}) = 1;
    catch
        keyboard;
    end
    imagesc(BigAvg);
    
    p.progress;
end
p.stop;
figure(1);imagesc(BigAvg);

blankframe = zeros(Xdim,Ydim,'single');
figure;
% part 2: rendering
p = ProgressBar(NumFrames)
for i = 1:NumFrames
    
    % 1. start with blank frame
    temp = blankframe;
    % 2. add neurons
    for j = 1:NumNeurons
        temp(CircMask{j}) = TraceMat(j,i);

    end
    
    
    
    % 3. add background
    temp = temp+0.2;
    
    temp = temp+rand(Xdim,Ydim)*0.05;
    
    
    
    
    % 4. smear
    temp = imfilter(temp,LowPassFilter,'replicate')*1000;
    
    %imagesc(temp);axis image;colormap gray;colorbar;pause;
    % 5. save
    h5write('fake.h5','/Object',temp,[1 1 i 1],[Xdim Ydim 1 1]);
    p.progress;
end
p.stop;

save FakeData.mat TraceMat CircMask PSAbool;
end

