function [x,y,speed,FT,FToffset,FToffsetRear] = AlignImagingToTracking(Pix2Cm,FT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SR = 20;

[x,y,start_time,MoMtime] = PreProcessMousePosition('Video.DVT');
x = x.*Pix2Cm;
y = y.*Pix2Cm;
dx = diff(x);
dy = diff(y);
speed = sqrt(dx.^2+dy.^2)*SR;

% align starts of Fluorescence video and Plexon tracking to the arrival of
% the mouse of the maze
fTime = (1:size(FT,2))/SR;
fStart = findclosest(MoMtime,fTime);
FT = FT(:,fStart:end);
fTime = (1:size(FT,2))/SR;

plexTime = (0:length(x)-1)/SR+start_time;
pStart = findclosest(MoMtime,plexTime);
x = x(pStart:end);
y = y(pStart:end);
speed = speed(pStart:end);
plexTime = (1:length(x))/SR;

Flength = size(FT,2);
FToffsetRear = 0;

% if Inscopix or Plexon is longer than the other, chop
if (length(plexTime) <= Flength)
    % Chop the FL
    FT  = FT(:,1:length(plexTime));
    FToffsetRear = length(plexTime) - Flength;
    Flength = length(plexTime);
    
else
    speed = speed(1:Flength);
    x = x(1:Flength);
    y = y(1:Flength);
end

if (length(speed) < length(x))
    speed(end+1) = 0;
end

speed(1:100) = 0; % a hack, but otherwise screwy things happen

%%%%%%%%% adjust by half the movie smoothing window
HalfWindow = 10;

% shift position and speed right
x = [zeros(1,HalfWindow),x(1:end-HalfWindow)];
y = [zeros(1,HalfWindow),y(1:end-HalfWindow)];
speed = [zeros(1,HalfWindow),speed(1:end-HalfWindow)];

% chop the first HalfWindow
x = x(HalfWindow+1:end);
y = y(HalfWindow+1:end);
speed = speed(HalfWindow+1:end);
FT = FT(:,HalfWindow+1:end);

FToffset = fStart + HalfWindow + 1;

end

