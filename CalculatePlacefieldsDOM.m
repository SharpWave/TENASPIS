function [] = CalculatePlacefieldsDOM(RoomStr,CutStart)
% [] = [] = CalculatePlacefieldsDOM(RoomStr,CutStart)
% RoomStr, e.g. '201a'
% CutStart -- if the movie is one of the ones where we went and removed
% the first six frames, set this to 1, otherwise omit it
% This script takes the outputs saved by ExtractTraces and the Video.DVT
% Placefields are calculated and tested using an adapted version of the
% Dombeck et al 

close all;

if (nargin < 2)
    CutStart = 0;
end

load FinalTraces.mat; % load the saved traces
yOut = y;
xOut = x;

Flength = size(FT,2);
NumCells = size(FT,1);

% normalize each trace by its max
for i = 1:NumCells
   m = max(FT(i,:));
   if (m > 0)
       FT(i,:) = FT(i,:)/m;
   end
end

minspeed = 7;

SR = 20;

Pix2Cm = 0.15;

if (nargin == 0)
    Pix2Cm = 0.15;
    display('assuming room 201b');
    % factor for 201a is 0.0709
else
    if (strcmp(RoomStr,'201a'))
        Pix2Cm = 0.0709;
        display('Room 201a');
    end
end

[x,y,speed] = GetSpeed(SR,Pix2Cm);
% x and y come out of this in cm units, speed is cm/sec

if (CutStart == 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this section stays until Inscopix figures out their external sync issue
% first 6 frames get dropped
x = x(7:end);
y = y(7:end);
speed = speed(7:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%%% correct any size mismatch between Cineplex and Inscopix
if (length(speed) <= Flength)
    % Chop the FL
    FT  = FT(:,1:length(speed));
    Flength = length(speed)
else
    speed = speed(1:Flength);
    x = x(1:Flength);
    y = y(1:Flength);
end
speed(1:100) = 0; % a hack, but otherwise screwy things happen

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

t = (1:Flength)/SR;

figure(1);plot(t,speed);axis tight;xlabel('time (sec)');ylabel('speed cm/s');

%spiketrain = dumb_fl2act(FT,0.01,0.5);

% Set up binning and smoothers for place field analysis

% Dombeck used 2.5 cm bins
Xrange = max(x)-min(x);
Yrange = max(y)-min(y);

NumXBins = ceil(Xrange/2.5);
NumYBins = ceil(Yrange/2.5);

Xedges = (0:NumXBins)*2.5+min(x);
Yedges = (0:NumYBins)*2.5+min(y);

figure(2);hold on;plot(x,y);

% draw all of the edges
for i = 1:length(Xedges)
    z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z,'Color','r');
end

for i = 1:length(Yedges)
    z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z,'Color','r');
end

axis tight;

[counts,Xbin] = histc(x,Xedges);
[counts,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumXBins+1))) = NumXBins;
Ybin(find(Ybin == (NumYBins+1))) = NumYBins;

Xbin(find(Xbin == 0)) = 1;
Ybin(find(Ybin == 0)) = 1;

OccMap = zeros(NumXBins,NumYBins);
MovMap = zeros(NumXBins,NumYBins);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate Occupancy maps, both for all times and for times limited to 
% when the mouse was moving above minspeed
% OccMap and MovMap are in # of visits

for i = 1:Flength
    OccMap(Xbin(i),Ybin(i)) = OccMap(Xbin(i),Ybin(i))+1;
    if(speed(i) >= minspeed)
        MovMap(Xbin(i),Ybin(i)) = MovMap(Xbin(i),Ybin(i))+1;
    end
end

% Smooth both of these maps using an 8-neighbor discrete smoother

SmOccMap = SmoothDave(OccMap);
SmMovMap = SmoothDave(MovMap);


for i = 1:NumCells
  [FMap{i},TMap{i}] = calcmap(FT(i,:),MovMap,Xbin,Ybin,speed,minspeed);
  %FMap{i} = SmoothDave(FMap{i});
  %TMap{i} = SmoothDave(TMap{i});
  ip(i) = IsPlacefield(FMap{i},TMap{i})
  pval(i) = StrapIt(FT(i,:),MovMap,Xbin,Ybin,speed,minspeed)
  
end

keyboard;

save PlaceMaps.mat x y t xOut yOut speed minspeed FT spiketrain PlaceMap AdjMap MovMap OccMap Smoother Smoother2 SMovMap SMovMap2 c IC ICnz; 
return;
