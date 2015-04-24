function [ output_args ] = MPFM(out_avifile)
% make a fun movie of our mouse and his placefields
%   Detailed explanation goes here

close all;

load PlaceMaps.mat;
load PFstats.mat;

NumFrames = length(x);
NumNeurons = length(NeuronImage);

figure;
set(gcf,'Position',[534 72 1171 921]);

aviobj = VideoWriter(out_avifile);
aviobj.FrameRate = 20;
open(aviobj);

% assign each neuron a color
colors = rand(NumNeurons,3);

for i = 1:NumFrames
    
    set(gcf,'Position',[534 72 1171 921]);
    % plot trajectory, hold on
    plot(Xbin,Ybin,'-','Color',[0.2 0.2 0.2]);hold on;axis tight;
    Xa = get(gca,'XLim');
    Ya = get(gca,'YLim');
    
    % plot mouse marker
    plot(Xbin(i),Ybin(i),'ok','MarkerSize',30,'MarkerFaceColor','k');
    
    % find active neurons
    an = find(FT(:,i));
    
    % for each active neuron
    for j = an'
        % get PF outline (if avail)
        WhichField = MaxPF(j);
        temp = zeros(size(TMap{1}));
        tp = PFpixels{j,WhichField};
        try
        temp(tp) = 1;
        catch
            keyboard;
        end
        % plot PF outline (using correct color)
        b = bwboundaries(temp,4);
        if (~isempty(b))
            
            yt = b{1}(:,2);
            xt = b{1}(:,1);
            xt= xt+(rand(size(xt))-0.5)/2;
            yt= yt+(rand(size(yt))-0.5)/2;
            %colors(j,:)
            plot(xt,yt,'Color',colors(j,:),'LineWidth',5);
            
            
        end
    end
    set(gca,'XLim',Xa,'YLim',Ya);
    % getframe
    F = getframe(gcf);
    % write to avi
    writeVideo(aviobj,F);
    hold off;
    gcf;
end
