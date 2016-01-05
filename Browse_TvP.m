function [ output_args ] = Browse_TvP()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load TvP.mat;

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

end

