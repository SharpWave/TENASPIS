function [MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames,ClustersToUpdate,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap)


NumClusters = length(unique(c));

if nargin <= 7
    ClustersToUpdate = unique(c);
end


    
for i = ClustersToUpdate'
    display(['updated cluster # ',int2str(i)]);
    MeanNeuron{i} = zeros(Xdim,Ydim);
    cluidx = find(c == i);
    areas = [];
    Xs = [];
    Ys = [];
    for j = 1:length(cluidx)
        overlap(i,j) = 0;
        validpixels = (seg{cluidx(j)} > 0.7);
        MeanNeuron{i} = MeanNeuron{i} + validpixels;
        areas = [areas,sum(validpixels(:))];
        Xs = [Xs,Xcent(cluidx(j))];
        Ys = [Ys,Ycent(cluidx(j))];
        for k = 1:length(cluidx)
            if (j ~= k)
                overlap(i,j) = max(overlap(i,j),length(intersect(frames{cluidx(j)},frames{cluidx(k)})) > 0);
            end
        end
    end
    meanareas(i) = mean(areas);
    meanX(i) = mean(Xs);
    meanY(i) = mean(Ys);
    NumEvents(i) = length(cluidx);
    Invalid(i) = sum(overlap(i,:)) > 0;
    MeanNeuron{i} = MeanNeuron{i}./length(cluidx);
    
end


end

