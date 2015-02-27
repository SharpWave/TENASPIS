function [xpos_interp,ypos_interp,Xmin,Xmax,Ymin,Ymax] = PreProcessMousePosition2(filepath)

try
    load Pos.mat
    return
catch 
    
    
% Script to take position data at given timestamps and output and interpolate 
% to any given timestamps.

PosSR = 30; % native sampling rate in Hz of position data

% Import position data from DVT file

pos_data = importdata(filepath);
%f_s = max(regexp(filepath,'\'))+1;
%mouse_name = filepath(f_s:f_s+2);
%date = [filepath(f_s+3:f_s+4) '-' filepath(f_s+5:f_s+6) '-' filepath(f_s+7:f_s+10)];

% Parse out into invididual variables
frame = pos_data(:,1);
time = pos_data(:,2); % time in seconds
Xpix = pos_data(:,3); % x position in pixels (can be adjusted to cm)
Ypix = pos_data(:,4); % y position in pixels (can be adjusted to cm)

% fix sections where Xpix and Ypix go to 0, indicating gaps in position
% tracking

Xold = Xpix;
Yold = Ypix;

Xpix = UnfuckTraces(Xpix',5000,1);
Ypix = UnfuckTraces(Ypix',5000,1);

keyboard;

figure(777);plot(Xpix,Ypix);
figure(666);subplot(2,1,1);hist(Xpix,300);subplot(2,1,2);plot(Xpix);

keyboard;

Xmin = input('Enter X min ->>');
Xmax = input('Enter X max ->>');

figure;
subplot(2,1,1);hist(Ypix,300);subplot(2,1,2);plot(Ypix);


Ymin = input('Enter Y min ->>');

Ymax = input('Enter Y max ->>');

Xpix(find(Xpix < Xmin)) = Xmin;
Xpix(find(Xpix > Xmax)) = Xmax;
Ypix(find(Ypix < Ymin)) = Ymin;
Ypix(find(Ypix > Ymax)) = Ymax;

e = NP_FindSupraThresholdEpochs(-1*Xpix,-1*Xmin-1);

for i = 1:size(e,1)
    Xpix(e(i,1):e(i,2)) = Xpix(e(i,1)-1);
end

e = NP_FindSupraThresholdEpochs(-1*Ypix,-1*Ymin-1);
for i = 1:size(e,1)
    Ypix(e(i,1):e(i,2)) = Ypix(e(i,1)-1);
end

keyboard;


Xpix = NP_QuickFilt(Xpix,0.0000001,1,PosSR);
Ypix = NP_QuickFilt(Ypix,0.0000001,1,PosSR);

if size(pos_data,2) == 5
    motion = pos_data(:,5);
end

frame_rate_emp = round(1/mean(diff(time))); % empirical frame rate (frames/sec)

% Conjure up set of times to test script
fps_test = 20; % frames/sec for dummy timestamps

start_time = min(time);
max_time = max(time);
time_test = start_time:1/fps_test:max_time;

%% Do Linear Interpolation

% Get appropriate time points to interpolate for each timestamp
time_index = arrayfun(@(a) [max(find(a >= time)) min(find(a < time))],...
    time_test,'UniformOutput',0);
time_test_cell = arrayfun(@(a) a,time_test,'UniformOutput',0);

xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xpix(a),...
    b),time_index,time_test_cell);

ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ypix(a),...
    b),time_index,time_test_cell);

%% Sanity Check
% figure
% subplot(2,1,1)
% plot(time,Xpix,'b-',time_test,xpos_interp,'rx')
% subplot(2,1,2)
% plot(time,Ypix,'b-',time_test,ypos_interp,'rx')

save Pos.mat xpos_interp ypos_interp Xmin Xmax Ymin Ymax

end





