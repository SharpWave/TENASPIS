function [] = TenaspisVsPCAICA(moviefile)

load ProcOut.mat;
load ICoutput.mat;
load DumbTraces.mat;

for i = 1:length(NeuronImage)
    Tprops{i} = regionprops(NeuronImage{i});
    Tcent(i,1:2) = Tprops{i}.Centroid;
end

for i = 1:length(ICprops)
    Icent(i,1:2) = ICprops{i}.Centroid;
end

% compute all pairwise distances between neuron centroids
CluDist = pdist([Tcent;Icent],'euclidean');
CluDist = squareform(CluDist);

for i = 1:length(NeuronImage)
    for j = 1:length(ICprops)
        Cdist(i,j) = CluDist(i,j+length(NeuronImage));
    end
end

FrameLoaded = zeros(1,NumFrames);


NumTimesLoaded = sum(FT)+sum(ICFT);
[val,idx] = sort(NumTimesLoaded);
curr = length(idx);

for i = 1:length(idx)
    framecache{idx(curr)} = single(loadframe(moviefile,idx(curr)));
    FrameLoaded(idx(curr)) = 1;
    curr = curr-1;
    if (mod(i,1500) == 0)
    [user] = memory;
    user.MemAvailableAllArrays
    if (user.MemAvailableAllArrays < 10000000000)
        display([int2str(i),' out of ',int2str(length(idx)),' frames cached']);
        break;
    end
    end
end

for i = 1:length(NeuronImage)
    % average frame
    display(['Calculating Mean Image for Tenaspis Neuron ',int2str(i)]);
    ActiveF = find(FT(i,:));
    MeanT{i} = zeros(size(NeuronImage{1}));
    for j = 1:length(ActiveF)
        if (FrameLoaded(ActiveF(j)))
            frame = framecache{ActiveF(j)};
            %display('cache hit')
        else
            frame = single(loadframe(moviefile,ActiveF(j)));
        end
%         size(MeanT{i})
%         size(frame)
%         if (length(frame) == 0)
%             keyboard;
%         end
        MeanT{i} = MeanT{i}+frame;
    end
    nAFT(i) = length(ActiveF);
    if (nAFT(i) > 0)
        MeanT{i} = MeanT{i}./nAFT(i);
    end

    
end

for i = 1:length(ICimage)
    % average frame
    display(['Calculating Mean Image for IC Neuron ',int2str(i)]);
    ActiveF = find(ICFT(i,:));
    MeanI{i} = zeros(size(NeuronImage{1}));
    for j = 1:length(ActiveF)
        if (FrameLoaded(ActiveF(j)))
            frame = framecache{ActiveF(j)};
        else
            frame = single(loadframe(moviefile,ActiveF(j)));

        end
        MeanI{i} = MeanI{i}+frame;
    end
    nAFI(i) = length(ActiveF);
    if (nAFI(i) > 0)
        MeanI{i} = MeanI{i}./nAFI(i);
    end

end

for i = 1:length(NeuronImage)
    [mindist(i),ClosestT(i)] = min(Cdist(i,:));
    MeanDiff{i} = MeanT{i}-MeanI{ClosestT(i)};
end
clear framecache;
save TvP.mat;

figure;
keyboard;
for i = 1:length(NeuronImage)
    outT{i} = bwboundaries(NeuronImage{i});
    outI{i} = bwboundaries(ICimage{ClosestT(i)});
end

t = (1:length(NumTimesLoaded))/20;

for i = 1:length(NeuronImage)
    figure;set(gcf,'Position',[680 59 874 919])
    subplot(3,3,1);imagesc(MeanT{i});axis equal;axis tight;
      hold on;
      plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
      title(['Tenaspis Neuron #',int2str(i),' frames = ',int2str(nAFT(i))],'FontSize',8);
      CLim = get(gca,'CLim');
          set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]); 
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);  
    idx = ClosestT(i);  
    
    subplot(3,3,2);imagesc(MeanI{idx});axis equal;axis tight;%set(gca,'CLim',CLim');
      hold on;
      plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
      title(['PCAICA Neuron #',int2str(idx),' frames = ',int2str(nAFI(idx))],'FontSize',8);
          set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]); 
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);  
    
    subplot(3,3,3);imagesc(MeanDiff{i});hold on;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]); 
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
        
    title('Ten. - PCAICA','FontSize',8);
    
    subplot(3,3,4:6);
    plot(t,zscore(Rawtrace(i,:)),'DisplayName','Raw T.trace');hold on;
    plot(t,zscore(Dtrace(i,:)),'DisplayName','D1 T.trace');hold on;
    plot(t,zscore(ICtrace(idx,:)),'DisplayName','IC trace');axis tight;
    set(gca,'YLim',[-3 15]);
    
    subplot(3,3,7:9)
    plot(t,FT(i,:),'-r','LineWidth',5,'DisplayName','T. activity');hold on;
    plot(t,ICFT(idx,:),'-k','LineWidth',3,'DisplayName','ICA activity');axis tight
    pause;close;
end

keyboard;
% for each Tneuron, determine if it has a match (min distance < x)
% if match present, compare activity

% for each Ineuron, determine if it has a match