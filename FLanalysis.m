function [] = FLanalysis()
close all;
SR = 20;
dfThresh = 0.05;
SpeedThresh = 2; % threshold in cm/sec

load FLdata.mat
[x,y] = PreProcessMousePosition('Video.DVT');
t = (1:length(x))/SR;

VidLength = length(t);
ICLength = size(GoodFLData,2);

if (VidLength < ICLength)
    GoodFLData = GoodFLData(:,1:VidLength);
else
    if (ICLength < VidLength)
        t = t(1:ICLength);
        x = x(1:ICLength);
        y = y(1:ICLength);
    end
end
x = x.*0.0675;
y = y.*0.0675;


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

OKspeed = speed > SpeedThresh;
keyboard;


%% derivative-based event detection
for i = 1:size(GoodFLData,1)
    g = GoodFLData(i,:);
    d = [diff(g),0];
    f = convtrim(d,ones(SR*2.5,1))./(SR*2.5);
    e = NP_FindSupraThresholdEpochs(f,dfThresh);
    GoodEp = zeros(1,size(e,1));
    for j = 1:size(e,1)
        if (sum(OKspeed(e(j,1):e(j,2))) > 0)
            GoodEp(j) = 1;
        end
    end
    
    e = e(find(GoodEp == 1),:);
    
    SpikeT{i} = e(:,1);
    SpikeA{i} = [];
    for j = 1:length(SpikeT{i})
        [val,idx] = max(GoodFLData(i,e(j,1):e(j,2)));
        SpikeA{i}(j) = idx+e(j,1)-1;
    end
end


figure(1)





for i = 1:81
    %plot(x(SpikeT{i}),y(SpikeT{i}),'or','MarkerSize',5,'MarkerFaceColor','r');hold on;
    tempFL = GoodFLData(i,:);
    tempFL(find(tempFL < 0)) = 0.01;
    subplot(9,9,i);
    plot(x,y,'Color',[0.5 0.5 0.5]);axis tight;hold on;
    %scatter(x(SpikeT{i}),y(SpikeT{i}),tempFL(SpikeA{i})*5,tempFL(SpikeA{i}),'filled');colorbar;hold off;pause;
    scatter(x(SpikeT{i}),y(SpikeT{i}),50,tempFL(SpikeA{i}),'filled');set(gca,'XTick',[]);set(gca,'YTick',[]);
end
figure(2);
for i = 82:length(GoodFLData)
    %plot(x(SpikeT{i}),y(SpikeT{i}),'or','MarkerSize',5,'MarkerFaceColor','r');hold on;
    tempFL = GoodFLData(i,:);
    tempFL(find(tempFL < 0)) = 0.01;
    subplot(9,9,i-81);
    plot(x,y,'Color',[0.5 0.5 0.5]);axis tight;hold on;
    %scatter(x(SpikeT{i}),y(SpikeT{i}),tempFL(SpikeA{i})*5,tempFL(SpikeA{i}),'filled');colorbar;hold off;pause;
    scatter(x(SpikeT{i}),y(SpikeT{i}),50,tempFL(SpikeA{i}),'filled');set(gca,'XTick',[]);set(gca,'YTick',[]);
end

keyboard;
for i = 1:size(GoodFLData,1)
    %plot(x(SpikeT{i}),y(SpikeT{i}),'or','MarkerSize',5,'MarkerFaceColor','r');hold on;
    tempFL = GoodFLData(i,:);
    tempFL(find(tempFL < 0)) = 0.01;
    
    plot(x,y);axis tight;hold on;
    %scatter(x(SpikeT{i}),y(SpikeT{i}),tempFL(SpikeA{i})*5,tempFL(SpikeA{i}),'filled');colorbar;hold off;pause;
    scatter(x(SpikeT{i}),y(SpikeT{i}),150,tempFL(SpikeA{i}),'filled');colorbar;hold off;pause;
end

keyboard;

for i = 1:size(GoodFLData,1)
    %subplot(3,1,1);imagesc(GoodICf{i});axis square;colorbar;
    tempFL = GoodFLData(i,:);
    tempFL(find(tempFL < 0)) = 0.0001;
    subplot(2,1,1);scatter(x,y,tempFL,tempFL,'filled');colorbar;axis tight;
    subplot(2,1,2);plot(t,GoodFLData(i,:));axis tight;
    pause;
end


