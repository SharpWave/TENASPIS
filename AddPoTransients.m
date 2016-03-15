function AddPoTransients()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
load pPeak.mat;
load ExpTransients.mat;
load('ProcOut.mat','NumNeurons','NumFrames','NeuronPixels','NeuronImage','Xdim','Ydim');

expPosTr = PosTr;

Cents = zeros(length(NeuronImage),2); 
rankthresh = 0.55;

for i = 1:length(NeuronImage)
    b = bwconncomp(NeuronImage{i});
    r = regionprops(b,'Centroid');
    Cents(i,1:2) = r.Centroid;
end

temp = pdist(Cents);
CentDist = squareform(temp);

display('checking buddies');
for j = 1:NumNeurons
    buddies{j} = [];
    for i = 1:NumNeurons
        if (i == j)
            continue;
        end
        if (CentDist(i,j) <= 15)
            buddies{j} = [buddies{j},i];
        end
        
    end
end

disp('Adding potential transients...');
p = ProgressBar(NumNeurons); 
for i = 1:NumNeurons
    %display(['Neuron ',int2str(i)]);

    PoEpochs = NP_FindSupraThresholdEpochs(PoPosTr(i,:),eps);
    for j = 1:size(PoEpochs,1)
        % check for buddies
        buddyspike = 0;
        buddyconfs = [];
        
        for k = 1:length(buddies{i})
            if sum(expPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0
                buddyspike = 1;
                
                
            end
            if (sum(PoPosTr(buddies{i}(k),PoEpochs(j,1):PoEpochs(j,2))) > 0)
                buddyconfs = [buddyconfs,buddies{i}(k)];
               
            end
        end
        
        if buddyspike
            %display('buddy spike');
            continue;
        end
        
        maxidx = [];
        % no buddy spike, check peak

        ps = PoTrPeakIdx{i}(j)-10;
        for k = ps:PoTrPeakIdx{i}(j)
            
            f = loadframe('SLPDF.h5',k);
            [~,maxidx(k)] = max(f(NeuronPixels{i}));
            
        end
        
        meanpix = [];
        if ~isempty(buddyconfs)
            %display('buddy conflict');
            for k = 1:length(buddyconfs)
                meanpix(k) = mean(f(NeuronPixels{buddyconfs(k)}));
            end
            if (mean(f(NeuronPixels{i})) < max(meanpix))
                %display('lost conflict');
                continue;
            end
        end
        
        [xp,yp] = ind2sub([Xdim,Ydim],maxidx(end-10:end));
        
        meanmaxidx = sub2ind([Xdim,Ydim],round(median(xp)),median(mean(yp)));
        peakpeak = pPeak{i}(meanmaxidx);
        peakrank = mRank{i}(meanmaxidx);
        
        if (peakpeak > 0) && (peakrank > rankthresh)
            %display('new transient!');
            expPosTr(i,PoEpochs(j,1):PoEpochs(j,2)) = 1;
        else
            display('pixels off kilter');
            if peakpeak == 0
                %display('this pixel is never the peak');
            end
            if peakrank < rankthresh
                %display('mean rank of the peak not high enough');
            end
        end
        
    end
    
    p.progress;
end
p.stop; 

save expPosTr.mat expPosTr;

end

