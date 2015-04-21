function [PixelList,meanareas,meanX,meanY,NumEvents,frames] = UpdateClusterInfo(c,Xdim,Ydim,PixelList,Xcent,Ycent,ClustersToUpdate,meanareas,meanX,meanY,NumEvents,frames)

if nargin <= 6
    ClustersToUpdate = unique(c);
end


    
for i = ClustersToUpdate'
    display(['updated cluster # ',int2str(i)]);
    cluidx = find(c == i);

    % for each transient in the cluster, accumulate stats
    for j = 1:length(cluidx)
        try
          validpixels = PixelList{cluidx(j)};
        catch
          keyboard;
        end
        if (j == 1)
          newpixels = validpixels;
        else
          newpixels = intersect(newpixels,validpixels);
        end
        if (cluidx(j) ~= i)
            frames{i} = [frames{i},frames{cluidx(j)}];
        end

    end
    BitMap = logical(zeros(Xdim,Ydim));
    BitMap(newpixels) = 1;
    b = bwconncomp(BitMap,4);
    r = regionprops(b,'all'); % known issue where sometimes the merge creates two discontiguous areas. if changes to AutoMergeClu don't fix the problem then the fix will be here.
    if (length(r) == 0)
        display('foundit');
        keyboard;
    end
    PixelList{i} = newpixels;
    meanareas(i) = r(1).Area;
    meanX(i) = r(1).Centroid(1);
    meanY(i) = r(1).Centroid(2);
    NumEvents(i) = length(cluidx);

end


end

