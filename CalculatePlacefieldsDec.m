function [] = CalculatePlacefieldsDec(RoomStr)
% [] = [] = CalculatePlacefieldsDOM(RoomStr)
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
cmperbin = .5;

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

% if Inscopix or Plexon is longer than the other, chop
if (length(plexTime) <= Flength)
    % Chop the FL
    FT  = FT(:,1:length(plexTime));
    Flength = length(plexTime)
else
    speed = speed(1:Flength);
    x = x(1:Flength);
    y = y(1:Flength);
end

if (length(speed) < length(x))
    speed(end+1) = 0;
end

speed(1:100) = 0; % a hack, but otherwise screwy things happen

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)


runepochs = NP_FindSupraThresholdEpochs(speed,minspeed);
isrunning = speed >= minspeed;

t = (1:length(x))./SR;


figure(1);plot(t,speed);axis tight;xlabel('time (sec)');ylabel('speed cm/s');

%spiketrain = dumb_fl2act(FT,0.01,0.5);

% Set up binning and smoothers for place field analysis

% Dombeck used 2.5 cm bins
Xrange = max(x)-min(x);
Yrange = max(y)-min(y);

NumXBins = ceil(Xrange/cmperbin);
NumYBins = ceil(Yrange/cmperbin);

Xedges = (0:NumXBins)*cmperbin+min(x);
Yedges = (0:NumYBins)*cmperbin+min(y);

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


MovMap = zeros(NumXBins,NumYBins);
SpeedMap = zeros(NumXBins,NumYBins);
RunSpeedMap = zeros(NumXBins,NumYBins);
OccMap = zeros(NumXBins,NumYBins);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate Occupancy maps, both for all times and for times limited to 
% when the mouse was moving above minspeed
% OccMap and MovMap are in # of visits

for i = 1:Flength
   if (isrunning(i))
     MovMap(Xbin(i),Ybin(i)) = MovMap(Xbin(i),Ybin(i))+1;
     if (i ~= Flength)
       RunSpeedMap(Xbin(i),Ybin(i)) = RunSpeedMap(Xbin(i),Ybin(i))+speed(i);
     end
   end
   
   OccMap(Xbin(i),Ybin(i)) = OccMap(Xbin(i),Ybin(i))+1;
   if (i ~= Flength)
     SpeedMap(Xbin(i),Ybin(i)) = SpeedMap(Xbin(i),Ybin(i))+speed(i);
   end
end
SpeedMap = SpeedMap./OccMap;
RunSpeedMap = RunSpeedMap./MovMap;

SP = poopsi(FT,0.01,0.5);
figure;
allmap = zeros(size(MovMap));

for i = 1:NumCells
  TMap{i} = calcmapdec(SP(i,:),MovMap,Xbin,Ybin,isrunning);

  [ip(i),outmap] = IsPlacefield(TMap{i},cmperbin);
  if(ip(i))
    allmap = allmap+outmap;
  end
  if(ip(i))
    pval(i) = StrapIt(SP(i,:),MovMap,Xbin,Ybin,cmperbin,runepochs,isrunning,0);
  end

  
end

keyboard;

save PlaceMaps.mat x y t xOut yOut speed minspeed FT SP PlaceMap AdjMap MovMap OccMap Smoother Smoother2 SMovMap SMovMap2 c IC ICnz; 
return;


