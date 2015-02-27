function [x,y,speed] = GetSpeed(SR,Pix2Cm)

[x,y] = PreProcessMousePosition('Video.DVT');
t = (1:length(x))/SR;

x = x.*Pix2Cm;
y = y.*Pix2Cm;

x1 = x;
x1(end:end+SR)= 0;
x2 = zeros(size(x1));
x2(SR+1:end) = x;
dx = abs(x1-x2);
dx = dx(1:length(x));
dx = convtrim(dx,ones(SR,1)./SR);
dxs = dx.^2;

y1 = y;
y1(end:end+SR)= 0;
y2 = zeros(size(y1));
y2(SR+1:end) = y;
dy = abs(y1-y2);
dy = dy(1:length(y));
dy = convtrim(dy,ones(SR,1)./SR);
dys = dy.^2;

speed = sqrt(dxs+dys);
% offset adjustment
speed = [zeros(1,ceil(SR/2)),speed];
speed = speed(1:length(x));