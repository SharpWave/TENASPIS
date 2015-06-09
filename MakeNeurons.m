function [] = MakeNeurons()
% [] = MakeNeurons()
% arranges calcium transients into neurons, based on centroid locations
% inputs: none
% outputs: ProcOut.mat
% --------------------------------------
% Variables saved: (breaking this requires major version update)
%
% NumNeurons: final number of neurons
% NeuronImage: bitmap of each neuron roi
% NeuronPixels: list of active pixels for each neuron
% InitPixelList: list of active pixels for each calcium transient
% c: list of which cluster each transient belongs to
% meanX meanY: centroids of neurons
% Xdim Ydim: pixel dimensions of imaging window
% NumFrames: number of frames in the entire movie
% FT: binary neuron activity matrix
% VersionString: which release of Tenaspis was used

VersionString = '0.9.0.0-beta';
MinPixelDist = 0.1:1:5

close all;

load Segments.mat; %NumSegments SegChain cc NumFrames Xdim Ydim --- not loading and passing here breaks parallelization
if (exist('InitClu.mat','file') == 0)
    InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim);
end

load InitClu.mat; %c Xdim Ydim PixelList Xcent Ycent frames meanareas meanX meanY NumEvents cToSeg
NumIterations = 0;
NumCT = length(c);
oldNumCT = NumCT;
InitPixelList = PixelList;



% run AutoMergeClu, each time incrementing the distance threshold
for i = 1:length(MinPixelDist)
    Cchanged = 1;
    oldNumCT = NumCT;
    while (Cchanged == 1)
        [c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames,CluDist] = AutoMergeClu(MinPixelDist(i),c,Xdim,Ydim,PixelList,Xcent,Ycent,meanareas,meanX,meanY,NumEvents,frames);
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
[CluToPlot,nToc,cTon] = unique(c);
NumNeurons = length(CluToPlot);

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
    tempepochs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    NumTransients(i) = size(tempepochs,1);
    ActiveFrames{i} = find(FT(i,:) > eps);
end

figure;
PlotNeuronOutlines(InitPixelList,Xdim,Ydim,c)
figure;
plotyy(1:length(NumClu),NumClu,1:length(NumClu),DistUsed);

%[MeanBlobs,AllBlob] = MakeMeanBlobs(ActiveFrames,c);

save ProcOut.mat NeuronImage NeuronPixels NumNeurons c Xdim Ydim FT NumFrames NumTransients MinPixelDist DistUsed InitPixelList VersionString GoodTrs nToc cTon -v7.3;

end

