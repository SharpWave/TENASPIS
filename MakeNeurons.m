function [] = MakeNeurons()
% [] = MakeNeurons()
% arranges calcium transients into neurons, based on centroid locations
% inputs: none

MinPixelDist = 0.1:0.25:3.5

close all;

if (exist('InitClu.mat','file') == 0)
    InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim);
end

load InitClu.mat; %c Xdim Ydim PixelList Xcent Ycent frames meanareas meanX meanY NumEvents
NumIterations = 0;
NumCT = length(c);
oldNumCT = NumCT;
InitPixelList = PixelList;

% run AutoMergeClu, each time incrementing the distance threshold
for i = 1:length(MinPixelDist)
    Cchanged = 1;
    oldNumCT = NumCT;
    while (Cchanged == 1)
        [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames] = AutoMergeClu(MinPixelDist(i),c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames);
        NumIterations = NumIterations+1;
        NumClu(NumIterations) = length(unique(c));
        DistUsed(NumIterations) = MinPixelDist(i);

        
        if (NumClu(NumIterations) == oldNumCT)
            break;
        else
            oldNumCT = NumClu(NumIterations);
        end
    end
end

% OK now unpack these things

CurrClu = 0;
CluToPlot = unique(c);
for i = CluToPlot'
    CurrClu = CurrClu + 1;
    NeuronImage{CurrClu} = logical(zeros(Xdim,Ydim));
    NeuronImage{CurrClu}(PixelList{i}) = 1;
    NeuronPixels{CurrClu} = PixelList{i};
    caltrain{CurrClu} = zeros(1,NumFrames);
    caltrain{CurrClu}(frames{i}) = 1;
end

for i = 1:length(caltrain)
    FT(i,:) = caltrain{i};
end

figure;
PlotNeuronOutlines(InitPixelList,Xdim,Ydim,c)
figure;
plotyy(1:length(NumClu),NumClu,1:length(NumClu),DistUsed);
save ProcOut.mat NeuronImage NeuronPixels c meanX meanY Xdim Ydim FT caltrain NumFrames M NumClu MinPixelDist DistUsed InitPixelList -v7.3;

end

