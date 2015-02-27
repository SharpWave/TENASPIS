function [ outmat] = SmoothDave(inmat)
% [ outmat] = SmoothDave(inmat)
% inmat is a 2d matrix

inmat(find(isnan(inmat))) = 0;
outmat = zeros(size(inmat));

d = [ 1 0; -1 0; 1 1; 0 1; -1 1; 1 -1; 0 -1; -1 -1]; 

for i = 1:size(outmat,1)
    for j = 1:size(outmat,2)
        neighbors = d+repmat([i j],[8 1]);
        NumGood = 0;
        for k = 1:8
            try
                outmat(i,j) = outmat(i,j) + inmat(neighbors(k,1),neighbors(k,2));
                NumGood = NumGood + 1;
            end
        end
        
        outmat(i,j) = outmat(i,j)/NumGood;
    end
end

end

