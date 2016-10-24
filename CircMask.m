function [cmask] = CircMask(Xdim,Ydim,radius,Xcent,Ycent)
% Based on a stackoverflow response from user Amro

t = linspace(0, 2*pi, 50);   %# approximate circle with 50 points
r = radius;                      %# radius
c = [Xcent Ycent];

BW = poly2mask(r*cos(t)+c(1), r*sin(t)+c(2), Xdim, Ydim);
cmask = find(BW);
end

