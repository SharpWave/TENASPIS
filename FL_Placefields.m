function [ output_args ] = FL_Placefields(Pix2Cm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

close all;

load SignalTracev7.mat; % load the saved traces

Flength = size(GoodSignalTrace,2);
NumCells = size(GoodSignalTrace,1);
minspeed = 10;

SR = 20;

if (nargin == 0)
    Pix2Cm = 0.15;
    display('assuming room 201b');
    % factor for 201a is 0.0709
end


[x,y,speed] = GetSpeed(SR,Pix2Cm);



% this section stays until Inscopix figures out their external sync issue
% first 6 frames get dropped
x = x(7:end);
y = y(7:end);
speed = speed(7:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (length(speed) <= Flength)
    % Chop the FL
    GoodSignalTrace  = GoodSignalTrace(:,1:length(speed));
    Flength = length(speed)
else
    speed = speed(1:Flength);
    x = x(1:Flength);
    y = y(1:Flength);
end
speed(1:100) = 0;

Xdim = size(GoodICf{1},1)
Ydim = size(GoodICf{1},2)

t = (1:Flength)/SR;

% generate spiketrains
spiketrain = zeros(size(GoodSignalTrace));

% parameters for oopsi
V.Ncells = 1;
V.T = Flength;
V.dt = 1/SR;
P.gam = 0.981;%0.941; 


for i = 1:NumCells
  i
  f = GoodSignalTrace(i,:);
  for j = 1:4
      f = convtrim(f,ones(3,1))./3;
  end
  f(find(f <= 0)) = 0;
  f = convtrim(f,[1 1 1])/3;
  spikef(i,:) = f;
  spiketrain(i,:) = DWS_oopsi(f,V,P);
end

NumSpatBins = 64; % bins per edge
Xedges = (0:NumSpatBins)*(max(x)-min(x))/NumSpatBins+min(x);
Yedges = (0:NumSpatBins)*(max(y)-min(y))/NumSpatBins+min(y);

figure(1);hold on;plot(x,y);
% draw all of the edges
for i = 1:length(Xedges)
    z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z,'Color','r');
    z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z,'Color','r');
end


[counts,Xbin] = histc(x,Xedges);
[counts,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumSpatBins+1))) = NumSpatBins;
Ybin(find(Ybin == (NumSpatBins+1))) = NumSpatBins;

Xbin(find(Xbin == 0)) = 1;
Ybin(find(Ybin == 0)) = 1;

OccMap = zeros(NumSpatBins,NumSpatBins);
MovMap = zeros(NumSpatBins,NumSpatBins);

r = (-NumSpatBins:NumSpatBins)/NumSpatBins;
Smooth = 0.05;
Smoother = exp(-r.^2/Smooth^2/2);
Smoother = Smoother/sum(Smoother);

for i = 1:Flength
    OccMap(Xbin(i),Ybin(i)) = OccMap(Xbin(i),Ybin(i))+1/SR;
    if(speed(i) >= minspeed)
       MovMap(Xbin(i),Ybin(i)) = MovMap(Xbin(i),Ybin(i))+1/SR; 
    end
end

SMovMap = conv2(Smoother, Smoother, MovMap, 'same');


for i = 1:NumCells
    PlaceMap{i} = zeros(NumSpatBins);
    for j = 1:Flength
        if (speed(j) >= minspeed)
            PlaceMap{i}(Xbin(j),Ybin(j)) = PlaceMap{i}(Xbin(j),Ybin(j)) + spiketrain(i,j);
        end
    end
    SpikeMap{i} = PlaceMap{i};
    PlaceMap{i} = PlaceMap{i}./MovMap;
    PlaceMap{i}(isnan(PlaceMap{i})) = 0;
    PlaceMap{i} = conv2(Smoother,Smoother,PlaceMap{i},'same');
    %PlaceMap{i} = PlaceMap{i}./SMovMap;
    PlaceMap{i}(isinf(PlaceMap{i})) = 0;
end

Curr = 1;
WinCurr = 1;

while (Curr < NumCells)
    if (mod(Curr,64) == 1)
        figure;
        WinCurr = 1;
    end
    
    subplot(8,8,WinCurr);imagesc(PlaceMap{Curr}');set(gca,'YDir','normal');title(int2str(Curr));
    Curr = Curr+1;
    WinCurr = WinCurr +1;
end

for i = 1:NumCells
    nsp(i,:) = spiketrain(i,:)./std(spiketrain(i,:));
end

figure;imagesc(t,1:NumCells,nsp);caxis([0 1]);colormap hot;

Secs = 1;

NumSec = ceil(Flength/SR/Secs);

bedges = (0:NumSec)*SR*Secs+1;

for i = 1:NumCells
    for j = 1:length(bedges)-1
        MeanSp(i,j) = mean(nsp(i,bedges(j):min(bedges(j+1),Flength)));
    end
end

figure;imagesc(bedges(1:end-1),1:NumCells,MeanSp);

rsp = MeanSp >= 0.25;

for i = 1:length(bedges)-1
    for j = 1:length(bedges)-1
      nOver(i,j) = sum(rsp(:,i).*rsp(:,j));%./sum(rsp(:,i));
    end
end

figure;imagesc(nOver);


figure(2112);
speedok = speed >= minspeed;

for i = 1:NumCells
    kr = spiketrain(i,:).*speedok+eps;
    kr = kr/max(kr);
    subplot(3,4,1),scatter(x,y,kr*140, kr,'filled');xlabel('x position');ylabel('y position');
    subplot(3,4,2),imagesc(PlaceMap{i}');set(gca,'YDir','normal');
    subplot(3,4,3),scatter(t,y,kr*140, kr,'filled');xlabel('time (sec)');ylabel('y position');
    subplot(3,4,4),scatter(x,t,kr*140, kr,'filled');xlabel('x position');ylabel('time (sec)');
    subplot(3,4,5:8),plot(t,GoodSignalTrace(i,:));axis tight;xlabel('time (sec)');ylabel('DF/F');
    subplot(3,4,9:12),plot(t,spiketrain(i,:));axis tight;xlabel('time (sec)');ylabel('estimated spiking (a.u.)');
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);pause(1);
    save2pdf(['C:\pdf\PF',int2str(i),'.pdf'],gcf,300);
    i
    %response = input('does this cell actually have a placefield?  ->>','s');
%     if (strcmp(response,'y') == 1)
%         GoodField(i) = 1;
%     else
%         GoodField(i) = 0;
%     end
end


keyboard;


    
    

  

end

