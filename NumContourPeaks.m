function [ thresh,x,y ] = NumContourPeaks(IC,ICarea)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
maxval = max(IC(:));

temp = flip(sort(IC(:)));
thresh = temp(ICarea);

for i = round(thresh):0.1:maxval
    c = contourc(IC,[i,i]);
    numregions = length(find(c(1,:) == i));
    if (numregions == 1) 
      break;
    end
end

thresh = i;
x = c(1,2:end);
y = c(2,2:end);

% imagesc(IC)
% hold on;
% plot(x,y,'-r','LineWidth',5);

