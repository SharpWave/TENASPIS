function [] = CalculatePlacefields(RoomStr)
% [] = CalculatePlacefields()
% This script takes the outputs saved by ExtractTraces and the Video.DVT
% file written by cineplex and 

close all;

load FinalTraces.mat; % load the saved traces
yOut = y;
xOut = x;

Flength = size(FT,2);
NumCells = size(FT,1);
minspeed = 2;

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this section stays until Inscopix figures out their external sync issue
% first 6 frames get dropped
x = x(7:end);
y = y(7:end);
speed = speed(7:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
speed(1:100) = 0;


Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

t = (1:Flength)/SR;

figure(1);plot(t,speed);axis tight;xlabel('time (sec)');ylabel('speed cm/s');

% Run OOPSI to generate spiking data
V.Ncells = 1;
V.T = Flength;
V.dt = 1/SR;
P.gam = 0.988;%0.941; 
V.fast_poiss = 1;
spiketrain = zeros(size(FT));

for i = 1:NumCells
    if(sum(FT(i,:)) > 0)
        spiketrain(i,:) = DWS_oopsi(FT(i,:),V,P);display('ran oops');
        spiketrain(i,find(spiketrain(i,:) <= 0.05)) = 0; % takes care of a case where oopsi gives funky results for mostly 0 traces
    else
        spiketrain(i,:) = 0;
    end
end
%spiketrain = poopsi(FT,0.01,0.5);

% Set up binning and smoothers for place field analysis
NumSpatBins = 128; % bins per edge
Xedges = (0:NumSpatBins)*(max(x)-min(x))/NumSpatBins+min(x);
Yedges = (0:NumSpatBins)*(max(y)-min(y))/NumSpatBins+min(y);

figure(2);hold on;plot(x,y);
% draw all of the edges
for i = 1:length(Xedges)
    z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z,'Color','r');
    z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z,'Color','r');
end
axis tight;

[counts,Xbin] = histc(x,Xedges);
[counts,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumSpatBins+1))) = NumSpatBins;
Ybin(find(Ybin == (NumSpatBins+1))) = NumSpatBins;

Xbin(find(Xbin == 0)) = 1;
Ybin(find(Ybin == 0)) = 1;

OccMap = zeros(NumSpatBins,NumSpatBins);
MovMap = zeros(NumSpatBins,NumSpatBins);

r = (-NumSpatBins:NumSpatBins)/NumSpatBins;
Smooth = 0.15;
Smoother = exp(-r.^2/Smooth^2/2);
Smoother = Smoother/sum(Smoother);

Smooth = 0.05;
Smoother2 = exp(-r.^2/Smooth^2/2);
Smoother2 = Smoother2/sum(Smoother2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate Occupancy maps, both for all times and for times limited to 
% when the mouse was moving above minspeed
for i = 1:Flength
    OccMap(Xbin(i),Ybin(i)) = OccMap(Xbin(i),Ybin(i))+1/SR;
    if(speed(i) >= minspeed)
        MovMap(Xbin(i),Ybin(i)) = MovMap(Xbin(i),Ybin(i))+1/SR;
    end
end

% Smooth the occupancy maps
SMovMap = conv2(Smoother2, Smoother2, MovMap, 'same');
SMovMap2 = conv2(Smoother2, Smoother2, MovMap, 'same');

keyboard;

for i = 1:NumCells
    PlaceMap{i} = zeros(NumSpatBins);
    for j = 1:Flength
        if (speed(j) >= minspeed)
            PlaceMap{i}(Xbin(j),Ybin(j)) = PlaceMap{i}(Xbin(j),Ybin(j)) + spiketrain(i,j);
        end
    end

    PlaceMap{i}(isnan(PlaceMap{i})) = 0;
    PlaceMap{i} = conv2(Smoother2,Smoother2,PlaceMap{i},'same');
    PlaceMap{i} = PlaceMap{i}./SMovMap;
    PlaceMap{i}(isinf(PlaceMap{i})) = 0;
    
    temphsv = [];
    temphsv(:,:,3) = 1./(1+1./SMovMap2'./50);
    temphsv(:,:,1) = 2/3-2/3*PlaceMap{i}'/max(PlaceMap{i}(:));
    temphsv(:,:,2) = ones(size(MovMap'));
    AdjMap{i} = hsv2rgb(temphsv);
end

save PlaceMaps.mat x y t xOut yOut speed minspeed FT spiketrain PlaceMap AdjMap MovMap OccMap Smoother Smoother2 SMovMap SMovMap2 c IC ICnz; 
return;

%everything below this line might be useful in the future
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





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
    nsp(i,:) = spiketrain(i,:);
end

figure;imagesc(t,1:NumCells,nsp);caxis([0 1]);colormap hot;

Secs = 2;

NumSec = ceil(Flength/SR/Secs);

bedges = (0:NumSec)*SR*Secs+1;

for i = 1:NumCells
    for j = 1:length(bedges)-1
        MeanSp(i,j) = mean(nsp(i,bedges(j):min(bedges(j+1),Flength)));
    end
end

figure;imagesc(bedges(1:end-1),1:NumCells,MeanSp);

rsp = MeanSp; 

for i = 1:length(bedges)-1
    for j = 1:length(bedges)-1
      nOver(i,j) = sum(rsp(:,i).*rsp(:,j));%./sum(rsp(:,i));
    end
end

figure;imagesc((1:length(bedges))*Secs,(1:length(bedges))*Secs,nOver);


figure(2112);opengl hardware;
speedok = speed >= minspeed;

flen = length(t);

for i = 1:NumCells
    kr = spiketrain(i,:).*speedok+eps;
    kr = kr/max(kr);
    
    figure(2112);
    subplot(3,4,1),scatter(x',y',kr'*140, kr','filled');xlabel('x position');ylabel('y position');axis tight;
    subplot(3,4,2),imagesc(AdjMap{i});set(gca,'YDir','normal');axis tight;
    subplot(3,4,3),scatter(t',y',kr'*140, kr','filled');xlabel('time (sec)');ylabel('y position');axis tight;
    subplot(3,4,4),scatter(x',t',kr'*140, kr','filled');xlabel('x position');ylabel('time (sec)');axis tight;
    
    % find 4 maxima
    [max1,idx1] = nanmax(FT(i,1:ceil(flen/4)));
    [max2,idx2] = nanmax(FT(i,ceil(flen/4)+1:ceil(flen/2)));idx2 = idx2+ceil(flen/4); 
    [max3,idx3] = nanmax(FT(i,ceil(flen/2)+1:ceil(flen/4*3)));idx3 = idx3+ceil(flen/2);
    [max4,idx4] = nanmax(FT(i,ceil(flen*3/4)+1:end));idx4 = idx4+ceil(flen*3/4);
    
    frame1 = h5read('FLmovie.h5','/Object',[1 1 idx1 1],[Xdim Ydim 1 1]);
    frame2 = h5read('FLmovie.h5','/Object',[1 1 idx2 1],[Xdim Ydim 1 1]);
    frame3 = h5read('FLmovie.h5','/Object',[1 1 idx3 1],[Xdim Ydim 1 1]);
    frame4 = h5read('FLmovie.h5','/Object',[1 1 idx4 1],[Xdim Ydim 1 1]);
    

    
    subplot(3,4,5:8),plot(t,FT(i,:));axis tight;xlabel('time (sec)');ylabel('DF/F');
    subplot(3,4,9:12),plot(t,spiketrain(i,:));hold on;plot(t,kr,'-r');hold off;axis tight;xlabel('time (sec)');ylabel('estimated spiking (a.u.)');
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    
    figure(2113);
    subplot(1,4,1);imagesc(frame1);colormap gray;hold on;plot(xOut{i},yOut{i},'-r');hold off;title(['t = ',num2str(ceil(idx1/20))]);caxis([0 0.2]);
    subplot(1,4,2);imagesc(frame2);colormap gray;hold on;plot(xOut{i},yOut{i},'-r');hold off;title(['t = ',num2str(ceil(idx2/20))]);caxis([0 0.2]);
    subplot(1,4,3);imagesc(frame3);colormap gray;hold on;plot(xOut{i},yOut{i},'-r');hold off;title(['t = ',num2str(ceil(idx3/20))]);caxis([0 0.2]);
    subplot(1,4,4);imagesc(frame4);colormap gray;hold on;plot(xOut{i},yOut{i},'-r');hold off;title(['t = ',num2str(ceil(idx4/20))]);caxis([0 0.2]);
    %pause;
    %save2pdf(['C:\pdf\PF',int2str(i),'.pdf'],gcf,300);
    i
    response = input('does this cell actually have a placefield?  ->>','s');
    if (strcmp(response,'y') == 1)
        GoodField(i) = 1;
    else
        GoodField(i) = 0;
    end
end


keyboard;


    
    

  

end

