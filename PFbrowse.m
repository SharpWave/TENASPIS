function [AllFields] = PFbrowse(h5file,CellsToBrowse)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% less shitty thing that shows you all of the placefields
% things on the plot
% 1: an average of all of the movie frames where the cell was active, with
% the cell outline overlaid

% 2: all of the cell outlines with this one highlighted (optional: against
% some sort of background image
%
% 3: the TMap, with the total traj on top, with hit trajs highlighted
%
% 4: All of the placefields with this one highlighted

close all

load PFstats.mat; % PFpcthits PFnumhits PFactive PFnumepochs PFepochs MaxPF PFcentroid PFsize PFpixels
load PlaceMaps.mat; % x y t xOutline yOutline speed minspeed FT TMap RunOccMap OccMap SpeedMap RunSpeedMap NeuronImage NeuronPixels cmperbin pval Xbin Ybin;

c = colormap;
c = [[0 0 0];c];

NumNeurons = length(NeuronImage);
NumFrames = length(x);

if (nargin < 2)
    CellsToBrowse = 1:NumNeurons;
end

% create a sum of all of the place fields
AllFields = zeros(size(TMap{1}));

for i = CellsToBrowse
    boolmap = (TMap{i} > 0);
    AllFields = AllFields + boolmap;
end
figure;imagesc(AllFields);


figure;
set(gcf,'Position',[680 78 1156 900]);

load DumbTraces.mat;
Dtrace = Dtrace(:,FToffset-1:end);
Rawtrace = Rawtrace(:,FToffset-1:end);
Dtrace = Dtrace(:,1:NumFrames);
Rawtrace = Rawtrace(:,1:NumFrames);

for i = CellsToBrowse
    i
    % Plot # 1 : Movie frames
    subplot(4,2,1);
    activeframes = find(FT(i,:) == 1);
    avgframe{i} = zeros(size(NeuronImage{1}));
    for j = activeframes
        % PROBLEM: this new FT doesn't match the original one, need proper
        % offset
        if ((j +FToffset) > NumFrames)
            continue
        end
            
        avgframe{i} = avgframe{i} + double(loadframe(h5file,j+FToffset));
    end
    avgframe{i} = avgframe{i}./length(activeframes);
    imagesc(avgframe{i});hold on;colormap gray;plot(xOutline{i},yOutline{i},'-r');title([int2str(length(activeframes)),' active frames']);hold off;
    
    ae = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    NumTransients = size(ae,1);
    
    % Plot #2: cell outlines
    subplot(4,2,2);
    imagesc(avgframe{i});hold on;colormap gray;
    for j = 1:NumNeurons
        plot(xOutline{j},yOutline{j},'-b');
    end
    plot(xOutline{i},yOutline{i},'-r');hold off;title([int2str(NumTransients),' total calcium transients']); 
    
    % Plot #3: TMap
    WhichField = MaxPF(i);
    temp = zeros(size(TMap{1}));
    temp(PFpixels{i,WhichField}) = TMap{i}(PFpixels{i,WhichField});
    subplot(4,2,3);
    imagesc(temp);colorbar; %hold on;plot(Ybin,Xbin,'-r','Linewidth',0.5);hold off; % TRAJ COVERS UP PF Heatmap
    colormap(gca,c);
    
    % Plot #4 : All placefields
    subplot(4,2,4);
    imagesc(AllFields);hold on;%plot(Ybin,Xbin);
    colormap(gca,c);
    BoolField = temp > 0;
    b = bwboundaries(BoolField,4);
    if (~isempty(b))
        yt{i} = b{1}(:,1);
        xt{i} = b{1}(:,2);
        plot(xt{i},yt{i},'-r');
        title([int2str(PFnumhits(i,WhichField)),' hits out of ',int2str(PFnumepochs(i,WhichField)),' visits']);
        
    end
    hold off;
    
    % Plot #5 : Traces
    Dtrace(i,:) = zscore(Dtrace(i,:));
    Rawtrace(i,:) = zscore(Rawtrace(i,:));
    
    ae = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    subplot(4,2,5:6);
    
    plot((1:NumFrames)/20,Dtrace(i,:));hold on;
    for j = 1:size(ae,1)
       plot((ae(j,1):ae(j,2))/20,Dtrace(i,ae(j,1):ae(j,2)),'-r','LineWidth',3); 
    end
    hold off;axis tight;
    
    
    subplot(4,2,7:8);
    plot((1:NumFrames)/20,Rawtrace(i,:));hold on;
    for j = 1:size(ae,1)
       plot((ae(j,1):ae(j,2))/20,Rawtrace(i,ae(j,1):ae(j,2)),'-r','LineWidth',3); 
    end
    hold off;axis tight;
    
     
    
    
    
    
    
    
    
    
    pause;
end

