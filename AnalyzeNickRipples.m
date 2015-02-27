function [] = AnalyzeNickRipples()

close all;
EEGSR = 1000;

%Go to directory
!cd K:\MECINAC SWRS
filename = 'Prospero8_SWRS1.plx';

% Load Channel 0 LFP
[adfreq, n, ts, fn, LFP] = plx_ad(filename,0);

% make a time (in seconds) vector
t = (1:length(LFP))./EEGSR;

% Filter for ripples between 100 and 200 Hz
FiltSig = NP_QuickFilt(LFP,100,200,EEGSR);

% Rectify and smooth to create a ripple detection signal
smwin = ones(5,1);
RipSig = FiltSig.^2;
RipSig = convtrim(RipSig,smwin);

% Normalize the ripple detection signal,plot
RipSig = zscore(RipSig);
figure(1);plot(t,RipSig);axis tight;

% zero out the running portion of the recording
RunEnd = 2100; % in seconds
RipSig(1:RunEnd*EEGSR) = 0;

% Extract ripple epochs. 
threshold = 5; % # of standard deviations
minlength = 80; % minimum duration over threshold

RipEpochs = NP_FindSupraThresholdEpochs(RipSig,threshold,minlength);

% fancy schmancy plot showing our detected ripples

figure(2);
plot(t,LFP,'-k','LineWidth',1);hold on;

for i = 1:size(RipEpochs,1)
    timeframe = (RipEpochs(i,1):RipEpochs(i,2));
    plot(t(timeframe),LFP(timeframe),'-r','LineWidth',2);
end
length(RipEpochs)/(length(LFP)-RunEnd*1000)*1000 % ripple rate

% extract the timestamps of the laser ON events
LaserOnCh = 5; 
[n, LaserOnSec, sv] = plx_event_ts(filename,LaserOnCh);
LaserOn = ceil(LaserOnSec * 1000)+3000;

% CCG between laser events and ripples
Times = [RipEpochs(:,1)',LaserOn'];
Groups = [ones(size(RipEpochs(:,1)'))*2,ones(size(LaserOn'))];
BinSize = 1000;
HalfBins = 30;
figure;
[out, t, FiringRate] = CCG(Times, Groups, BinSize, HalfBins, EEGSR,1:2,'scale',[],1);


% for each laser period, count the ripples
RipStartBool = zeros(size(LFP));
RipStartBool(RipEpochs(:,1)) = 1;

for i = 1:length(LaserOn)
    RipsPerSecOn(i) = sum(RipStartBool(LaserOn(i):LaserOn(i)+3000))/3;
    RipsPerSecOff(i) = sum(RipStartBool(LaserOn(i)-3001:LaserOn(i)-1))/3;
end

[h,p] = ttest(RipsPerSecOff,RipsPerSecOn)

    




