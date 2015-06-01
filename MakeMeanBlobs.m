function [MeanBlobs] = MakeMeanBlobs(c,cTon,GoodTrs)
% Computes the mean value of all pixels in a neuron's "Blob"

load Segments.mat;
load CC.mat;

for i = 1:max(c)
    MeanBlobs{i} = [];
end

for i = 1:length(c)
    CurrNeuron = cTon(c(i));
    
    if (isempty(MeanBlobs{CurrNeuron}))
        MeanBlobs{CurrNeuron} = zeros(Xdim,Ydim);
        NumFrames(CurrNeuron) = 0;
    end
    CurrSeg = GoodTrs(i);
    
    for j = 1:length(SegChain{CurrSeg})
        FrameNum = SegChain{CurrSeg}{j}(1);
        ObjNum = SegChain{CurrSeg}{j}(2);
        ts = regionprops(cc{FrameNum},'all');
        tempFrame = zeros(Xdim,Ydim);
        %keyboard;
        tempFrame(ts(ObjNum).PixelIdxList) = 1;
        MeanBlobs{CurrNeuron} = MeanBlobs{CurrNeuron} + tempFrame;
        NumFrames(CurrNeuron) = NumFrames(CurrNeuron) + 1;
    end
    
    
    
end

colors = rand(length(MeanBlobs),3);

for i = 1:length(MeanBlobs)
    
    temp = zeros(Xdim,Ydim);
    try
        temp(find(MeanBlobs{i} > 0.9)) = 1;
    catch
        continue;
    end
    
    b = bwboundaries(temp);
    x{i} = b{1}(:,1);
    x{i} = x{i}+(rand(size(x{i}))-0.5)/2;
    y{i} = b{1}(:,2);
    y{i} = y{i}+(rand(size(y{i}))-0.5)/2;
    plot(y{i},x{i},'Color',colors(i,:));hold on;
end
hold off;
keyboard;
