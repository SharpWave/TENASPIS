function [ output_args ] = MakeFakeMovie()
% Makes a fake dataset

Xdim = 500;
Ydim = 500;

NeuronRad = 3;
MaxDist = 6;

NumNeurons = 600;
NumFrames = 20000;

RiseLen = 12;
RiseInc = 1/RiseLen;

BaselineNeuronF = 1;
BackgroundF = 50;

TraceMat = zeros(NumNeurons,NumFrames);

LowPassFilter = fspecial('gaussian',[100 100],10);
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
    
    %   a. choose times and durations of rises
    
    %   b. model somatic GCaMP decays
    
    BigAvg(CircMask{i}) = 1;
    imagesc(BigAvg);
    
    p.progress;
end
p.stop;
keyboard;


% part 2: rendering
for i = 1:NumFrames
    % 1. start with blank frame
    
    % 2. add neurons
    
    % 3. add background
    
    % 4. smear
    
    % 5. save
end

end

