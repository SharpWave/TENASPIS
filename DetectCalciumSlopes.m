function [] = DetectCalciumSlopes()

% Next to last part of Tenaspis. goes through each neurons list of peaks
% and uses the Ca2+ traces to determine where the Ca2+ signal was rising,
% and thus the neuron was putatively spiking

load Reduced.mat;
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames'); %GoodPeaks GoodROIidx PixelIdxList GoodPeakAvg LPtrace -v7.3;

NumROIs = length(PixelIdxList);

InSlope = false;
thresh = 0.0001;
PSAbool = zeros(NumROIs,NumFrames);

for i = 1:NumROIs
    i/NumROIs
    DFDT{i} = diff(LPtrace{i});
    
    for j = 1:length(GoodPeaks{i})
        CurrFrame = GoodPeaks{i}(j);
        PSAbool(i,max(CurrFrame-5,1):CurrFrame) = 1;
        CurrFrame = max(CurrFrame - 6,1);
        StillInSlope = true;
        NumBadSlopes = 0;
        while(StillInSlope) 
            SlopeOK = DFDT{i}(CurrFrame) > thresh;
            if(SlopeOK)
                NumBadSlopes = 0;
            else
                NumBadSlopes = NumBadSlopes + 1;
            end
            if(NumBadSlopes >= 3)
                StillInSlope = false;
                PSAbool(i,CurrFrame:CurrFrame+4) = 0;
                break;
            end
            PSAbool(i,CurrFrame) = 1;
            CurrFrame = CurrFrame - 1;
            if(CurrFrame <= 0)
                break;
            end
        end
    end
end



NeuronPixelIdxList = PixelIdxList;
NumNeurons = NumROIs;

for i = 1:NumNeurons
    [xsub,ysub] = ind2sub([Xdim Ydim],NeuronPixelIdxList{i});
    
    NeuronAvg{i} = GoodPeakAvg{i}(PixelIdxList{i});
    NeuronImage{i} = zeros(Xdim,Ydim,'single');
    NeuronImage{i}(PixelIdxList{i}) = 1;
end

save FinalOutput.mat NeuronImage NeuronAvg NumNeurons NeuronPixelIdxList PSAbool

