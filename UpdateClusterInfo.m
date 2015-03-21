function [MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap] = UpdateClusterInfo(c,Xdim,Ydim,seg,Xcent,Ycent,frames,ClustersToUpdate,MeanNeuron,meanareas,meanX,meanY,NumEvents,Invalid,overlap)


NumClusters = length(unique(c));

if nargin <= 7
    ClustersToUpdate = unique(c);
end


    
for i = ClustersToUpdate'
    int2str(i)
    display(['updated cluster # ',int2str(i)]);
    MeanNeuron{i} = single(zeros(Xdim,Ydim));
    cluidx = find(c == i);
    areas = [];
    Xs = [];
    Ys = [];
    % for each transient in the cluster, accumulate stats
    for j = 1:length(cluidx)
        overlap(i,j) = 0;
        validpixels = (seg{cluidx(j)} == 1);
        if (j == 1)
          MeanNeuron{i} = MeanNeuron{i} + validpixels;
        else
          MeanNeuron{i} = MeanNeuron{i} .* validpixels;
        end
       
        for k = 1:length(cluidx)
            if (j ~= k)
                overlap(i,j) = max(overlap(i,j),length(intersect(frames{cluidx(j)},frames{cluidx(k)})) > 0);
            end
        end
    end
    b = bwconncomp(MeanNeuron{i},4);
    r = regionprops(b,'all'); % known issue where sometimes the merge creates two discontiguous areas. if changes to AutoMergeClu don't fix the problem then the fix will be here.
    
    meanareas(i) = r(1).Area;
    meanX(i) = r(1).Centroid(1);
    meanY(i) = r(1).Centroid(2);
    NumEvents(i) = length(cluidx);
    Invalid(i) = sum(overlap(i,:)) > 0;
end


end

