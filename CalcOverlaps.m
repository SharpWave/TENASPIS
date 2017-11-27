function [Overlaps] = CalcOverlaps(PixelIdxList,MaxDist)

[Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
NumTransients = length(PixelIdxList);
Overlaps = zeros(NumTransients,NumTransients,'single');
Xcent = zeros(1,NumTransients);
Ycent = zeros(1,NumTransients);
minx = zeros(1,NumTransients);
miny = zeros(1,NumTransients);
maxx = zeros(1,NumTransients);
maxy = zeros(1,NumTransients);

if(nargin < 2)
    MaxDist = 20;
end

for i = 1:NumTransients
    if(isempty(PixelIdxList{i}))
        continue;
    end
    [x{i},y{i}] = ind2sub([Xdim Ydim],PixelIdxList{i});
    minx(i) = min(x{i});
    miny(i) = min(y{i});
    maxx(i) = max(x{i});
    maxy(i) = max(y{i});
    Xcent(i) = round(mean(x{i}));
    Ycent(i) = round(mean(y{i}));
end
    

for i = 1:NumTransients
    if(isempty(PixelIdxList{i}))
        continue;
    end
    
    for j = 1:NumTransients
        if (i == j)
            continue;
        end
        
        if (i > j)
            Overlaps(i,j) = Overlaps(j,i);
            continue;
        end
        
        if(isempty(PixelIdxList{j}))
            continue;
        end
        
        CentDist = sqrt((Xcent(i)-Xcent(j)).^2+(Ycent(i)-Ycent(j)).^2);
        if(CentDist > MaxDist)
            continue;
        end

        
        % Make sure everything is in range
        
        if((minx(i) <= maxx(j)) && (minx(j) <= maxx(i)) && (miny(i) <= maxy(j)) && (miny(j) <= maxy(i)))
            Overlaps(i,j) = length(intersect(PixelIdxList{i},PixelIdxList{j}));
        end

    end
end


