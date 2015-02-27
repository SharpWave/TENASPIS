function [ idx] = findclosest(val,array)
%function [ idx] = findclosest(val,array)

[~,idx] = min(abs(array-val));

end

