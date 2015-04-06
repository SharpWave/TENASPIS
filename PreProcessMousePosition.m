function [xpos_interp,ypos_interp,start_time,MoMtime] = PreProcessMousePosition(filepath)

close all;

try
    load Pos.mat
    return
catch 

    

    
% Script to take position data at given timestamps and output and interpolate 
% to any given timestamps.

PosSR = 30; % native sampling rate in Hz of position data (used only in smoothing)
aviSR = 30.0003; % the framerate that the .avi thinks it's at


% Import position data from DVT file
try
pos_data = importdata(filepath);
%f_s = max(regexp(filepath,'\'))+1;
%mouse_name = filepath(f_s:f_s+2);
%date = [filepath(f_s+3:f_s+4) '-' filepath(f_s+5:f_s+6) '-' filepath(f_s+7:f_s+10)];

% Parse out into invididual variables
frame = pos_data(:,1);
time = pos_data(:,2); % time in seconds
Xpix = pos_data(:,3); % x position in pixels (can be adjusted to cm)
Ypix = pos_data(:,4); % y position in pixels (can be adjusted to cm)
catch
% Video.txt is there instead of Video.DVT
pos_data = importdata('Video.txt');
Xpix = pos_data.data(:,6);
Ypix = pos_data.data(:,7);
time = pos_data.data(:,4);
end

xAVI = Xpix*.6246;
yAVI = Ypix*.6246;

figure(777);plot(Xpix,Ypix);title('pre-corrected data');

% NRK Edit startpos
try
    h1 = implay('Raw.AVI');
    obj = VideoReader('Raw.AVI');
catch
    avi_filepath = ls('*.avi');
    h1 = implay(avi_filepath);
    disp(['Using ' avi_filepath ])
    obj = VideoReader(avi_filepath);
end
% NRK edit end

% NRK edit
if exist('Pos_temp.mat','file')
    use_temp = input('Pos_temp.mat detected.  Enter "y" to use or "n" to start from scratch: ','s');
    if strcmpi(use_temp,'y')
        load('Pos_temp.mat')
        MoMtime
    else
        MouseOnMazeFrame = input('on what frame number does Mr. Mouse arrive on the maze??? --->');
        MoMtime = (MouseOnMazeFrame)*(time(2)-time(1))+time(1)
    end
else
    MouseOnMazeFrame = input('on what frame number does Mr. Mouse arrive on the maze??? --->');
    MoMtime = (MouseOnMazeFrame)*(time(2)-time(1))+time(1)
end
close(h1); % Close Video Player


figure(555);
subplot(4,3,1:3);plot(time,Xpix);xlabel('time (sec)');ylabel('x position (cm)');yl = get(gca,'YLim');line([MoMtime MoMtime], [yl(1) yl(2)],'Color','r');axis tight;
subplot(4,3,4:6);plot(time,Ypix);xlabel('time (sec)');ylabel('y position (cm)');yl = get(gca,'YLim');line([MoMtime MoMtime], [yl(1) yl(2)],'Color','r');axis tight;

v0 = readFrame(obj);
MorePoints = 'y';
length(time)

while (strcmp(MorePoints,'y'))
  subplot(4,3,1:3);plot(time,Xpix);xlabel('time (sec)');ylabel('x position (cm)');hold on;yl = get(gca,'YLim');line([MoMtime MoMtime], [yl(1) yl(2)],'Color','r');hold off;axis tight;
  subplot(4,3,4:6);plot(time,Ypix);xlabel('time (sec)');ylabel('y position (cm)');hold on;yl = get(gca,'YLim');line([MoMtime MoMtime], [yl(1) yl(2)],'Color','r');hold off;axis tight;
  MorePoints = input('Is there a flaw that needs to be corrected?  [y/n] -->','s');

  
  if (strcmp(MorePoints,'n') ~= 1 && strcmp(MorePoints,'g') ~= 1)
    FrameSelOK = 0;
    while (FrameSelOK == 0)
        display('click on the good points around the flaw then hit enter');
        [DVTsec,~] = ginput(2); % DVTsec is start and end time in DVT seconds
        sFrame = findclosest(time,DVTsec(1)); % index of start frame
        eFrame = findclosest(time,DVTsec(2)); % index of end frame
        aviSR*sFrame;

        if (sFrame/aviSR > obj.Duration || eFrame/aviSR > obj.Duration)
            
            continue;
        end
        obj.currentTime = sFrame/aviSR; % sFrame is the correct frame #, but .avi reads are done according to time
        v = readFrame(obj);
        FrameSelOK = 1;
    end
    figure(555);
    subplot(4,3,11);imagesc(flipud(v));hold on; % plot Video
    plot(xAVI(sFrame:eFrame),yAVI(sFrame:eFrame),'LineWidth',1.5);hold off; % plot the selected trajectory
    framesToCorrect = sFrame:eFrame;
    
    edit_start_time = time(sFrame);
    edit_end_time = time(eFrame);
    disp(['You are currently editing from ' num2str(edit_start_time) ...
        ' sec to ' num2str(edit_end_time) ' sec.'])
    for i = 1:floor(length(framesToCorrect)/2);
        % plot x and y values for the selected frames
        figure(555);
        subplot(4,3,1:3);plot(time,Xpix);xlabel('time (sec)');ylabel('x position (cm)');hold on;yl = get(gca,'YLim');line([MoMtime MoMtime], [yl(1) yl(2)],'Color','r');hold off;axis tight;set(gca,'XLim',[sFrame/aviSR eFrame/aviSR]);
        subplot(4,3,4:6);plot(time,Ypix);xlabel('time (sec)');ylabel('y position (cm)');hold on;yl = get(gca,'YLim');line([MoMtime MoMtime], [yl(1) yl(2)],'Color','r');hold off;axis tight;set(gca,'XLim',[sFrame/aviSR eFrame/aviSR]);
        
        % plot the velocity
        subplot(4,3,7:9);
        vel = sqrt(diff(Xpix).^2+diff(Ypix).^2)*(time(2)-time(1));
        plot(time(MouseOnMazeFrame:end-1),vel(MouseOnMazeFrame:end));hold off;axis tight;xlabel('time (sec)');ylabel('velocity (units/sec)');
        
        % plot the current sub-trajectory
        subplot(4,3,11);
        imagesc(flipud(v));hold on;
        plot(xAVI(sFrame:eFrame),yAVI(sFrame:eFrame),'LineWidth',1.5);hold off;title('chosen segment');
        
        % plot the current total trajectory
        subplot(4,3,10);
        imagesc(flipud(v));hold on;
        plot(xAVI(MouseOnMazeFrame:end),yAVI(MouseOnMazeFrame:end),'LineWidth',1.5);hold off;title('overall trajectory (post mouse arrival)');
        
        % plot the current video frame
        figure(1702);pause(0.1);
        gcf;
        obj.currentTime = framesToCorrect(i*2)/aviSR;
        v = readFrame(obj);
        imagesc(flipud(v));title('click here');
        
        % plot the existing position marker on top
        hold on;plot(xAVI(sFrame+i*2),yAVI(sFrame+i*2),'ro','MarkerSize',4);
        display(['Time is ' num2str(time(sFrame+i*2)) ' seconds. Click the mouse''s back']);
        [xm,ym] = ginput(1);
        
        % apply corrected position to current frame
        xAVI(sFrame+i*2) = xm;
        yAVI(sFrame+i*2) = ym;
        Xpix(sFrame+i*2) = ceil(xm/0.6246);
        Ypix(sFrame+i*2) = ceil(ym/0.6246);
        
        % interpolate and apply correct position for previous frame
        xAVI(sFrame+i*2-1) = xAVI(sFrame+i*2-2)+(xm-xAVI(sFrame+i*2-2))/2;
        yAVI(sFrame+i*2-1) = yAVI(sFrame+i*2-2)+(ym-yAVI(sFrame+i*2-2))/2;
        Xpix(sFrame+i*2-1) = ceil(xAVI(sFrame+i*2-1)/0.6246);
        Ypix(sFrame+i*2-1) = ceil(yAVI(sFrame+i*2-1)/0.6246);
        
        
        % plot marker
        plot(xm,ym,'or','MarkerSize',4,'MarkerFaceColor','r');hold off;

        
    end
    disp(['You just edited from ' num2str(edit_start_time) ...
        ' sec to ' num2str(edit_end_time) ' sec.'])
    close(1702);
    % NRK edit
    save Pos_temp.mat Xpix Ypix xAVI yAVI MoMtime MouseOnMazeFrame
  continue
  end
  
  if (strcmp(MorePoints,'g'))
      % generate a movie and show it
      for i = 1:length(time)
        obj.currentTime = i/aviSR; % sFrame is the correct frame #, but .avi reads are done according to time
        v = readFrame(obj);
        figure(6156);
        imagesc(flipud(v));hold on;
        plot(xAVI(i),yAVI(i),'or','MarkerSize',5,'MarkerFaceColor','r');hold off;
        F(i) = getframe(gcf);
      end
      save F.mat F;implay(F);pause;
  end
        
end


XpixPF = Xpix;
YpixPF = Ypix;

Xpix = NP_QuickFilt(Xpix,0.0000001,1,PosSR);
Ypix = NP_QuickFilt(Ypix,0.0000001,1,PosSR);

if size(pos_data,2) == 5
    motion = pos_data(:,5);
end

frame_rate_emp = round(1/mean(diff(time))); % empirical frame rate (frames/sec)

% Generate times to match brain imaging data timestamps
fps_brainimage = 20; % frames/sec for brain image timestamps

start_time = ceil(min(time)*fps_brainimage)/fps_brainimage;
max_time = floor(max(time)*fps_brainimage)/fps_brainimage;
time_interp = start_time:1/fps_brainimage:max_time;

if (max(time_interp) >= max_time)
    time_interp = time_interp(1:end-1);
end

%% Do Linear Interpolation

% Get appropriate time points to interpolate for each timestamp
time_index = arrayfun(@(a) [max(find(a >= time)) min(find(a < time))],...
    time_interp,'UniformOutput',0);
time_test_cell = arrayfun(@(a) a,time_interp,'UniformOutput',0);

xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xpix(a),...
    b),time_index,time_test_cell);

ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ypix(a),...
    b),time_index,time_test_cell);

save Pos.mat xpos_interp ypos_interp time_interp start_time MoMtime

end





