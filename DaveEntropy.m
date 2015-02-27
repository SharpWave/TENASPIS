function [ h] = DaveEntropy( Tmap)

% calculate the base2 entropy of the calcium transient probability map
Tvec = Tmap(:);
h = 0;

for i = 1:length(Tvec)
    if (Tvec(i) > 0)
        h = h - log2(Tvec(i));
    end
end


end

