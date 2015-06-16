function [MeanBlobs] = MakeMeanBlobs(c,cTon,GoodTrs, varargin)
% Computes the mean value of all pixels in a neuron's "Blob". Set varargin
% 'suppress_output' to 0 if you wish to see progress displayed on your
% screen (default = 0).

suppress_output = 1;

for j = 1:length(varargin)
    if strcmpi(varargin{j},'suppress_output')
        suppress_output = varargin{j+1};
    end
end

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
    
    if suppress_output == 0
        disp(['Part 1: ' num2str(i) ' of ' num2str(length(c)) '.'])
    end
    
end

load ProcOut.mat;
TrPerMin = NumTransients./NumFrames*20*60;
[~,bidx] = histc(TrPerMin,[0:max(TrPerMin)/9:max(TrPerMin)]);
[~,cidx] = histc(TrPerMin,[0:max(TrPerMin)/length(colormap):max(TrPerMin)]);
colormap('jet');
cm = colormap;
colors = rand(length(MeanBlobs),3);
[~,plotorder] = sort(TrPerMin);

for i = 1:length(MeanBlobs)
    
    temp = zeros(Xdim,Ydim);
    try
        temp(find(MeanBlobs{plotorder(i)} > 0.9)) = 1;
    
    if (NumTransients(plotorder(i)) <= 1)
        continue;
    end
    b = bwboundaries(temp);
    x{i} = b{1}(:,1);
    %x{i} = x{i}+(rand(size(x{i}))-0.5)/2;
    y{i} = b{1}(:,2);
    %y{i} = y{i}+(rand(size(y{i}))-0.5)/2;
    plot(y{i},x{i},'Color','k','LineWidth',bidx(plotorder(i))+1);hold on;
    plot(y{i},x{i},'Color',cm(cidx(plotorder(i))-1,:),'LineWidth',bidx(plotorder(i)));hold on;
    
    catch
        continue;
    end
    
    if suppress_output == 0
        disp(['Part 2: ' num2str(i) ' of ' num2str(length(MeanBlobs)) '.'])
    end
end
hold off;
save MeanBlobs.mat MeanBlobs;
