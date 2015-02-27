function [NumActivations] = AnalyzePF(infile)

load([infile,'.mat']);
NumCells = length(AdjMap);
Thresh = 0.01;

IsPlaceCell = zeros(NumCells,1);




for i = 1:NumCells
    i
    if (mode(spiketrain(i,200:end)) ~= 0)
        % if, despite my best efforts, something got fucked
        continue;
    end
    
    if(sum(spiketrain(i,:)) == 0)
        continue;
    end
    
    Activations = NP_FindSupraThresholdEpochs(spiketrain(i,:),Thresh);
    NumActivations(i) = size(Activations,1);
    
    for j = 1:size(Activations,1)
        xAct{i}(j) = x(Activations(j,1));
        yAct{i}(j) = y(Activations(j,1));
    end
    
    MeanX(i) = mean(xAct{i});
    MeanY(i) = mean(yAct{i});
    
    if (size(Activations,1) <= 1)
        MeanPFDist(i) = inf;
        continue;
    end
    
    PlaceDist{i} = pdist([xAct{i}',yAct{i}']);
    z = linkage(PlaceDist{i});
        
    %hold on;plot(MeanX(i),MeanY(i),'o');
    
end

    

