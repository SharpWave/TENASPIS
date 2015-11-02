function [] = BlobDetectMovie(infile,out_avifile,cc,climits,delayframes)

close all;



figure1 = figure;
set(gcf,'Position',[1          41        1920         964]);

aviobj = VideoWriter(out_avifile,'MPEG-4');
aviobj.FrameRate = 20;
open(aviobj);

for i = 1:length(cc)
    [frame,Xdim,Ydim,NumFrames] = loadframe(infile,i);
    imagesc(frame);caxis(climits);colormap gray;
    x = [];
    y = [];
    
    for j = 1:length(cc{i}.PixelIdxList)
        temp = zeros(Xdim,Ydim);
        temp(cc{i}.PixelIdxList{j}) = 1;
        b = bwboundaries(temp);
        y{j} = b{1}(:,1);
        x{j} = b{1}(:,2);
    end
    
    hold on;
    if (i >= delayframes)
        for j = 1:length(x)
            hold on;
            plot(x{j},y{j},'-r','LineWidth',3);
        end
    end
    
    hold off;
    axis equal;
    axis off;
    
    
    line([140 210.5],[400 400],'LineWidth',5,'Color','k')
    % Create textbox
    tempobj = annotation(figure1,'textbox',...
        [0.6994375 0.171161826251701 0.0515624986185382 0.0280082982296271],...
        'String',{['t = ',num2str(round(i/20)),' seconds']},...
        'LineStyle','none');
    
    % Create textbox
    annotation(figure1,'textbox',...
        [0.397875 0.283929193608964 0.0323333333333334 0.0287368154318838],...
        'String',{'100 µm'},...
        'LineStyle','none',...
        'FitBoxToText','off');
    
    
    F = getframe;
    
    writeVideo(aviobj,F);hold off;
    delete(tempobj);
end
close(gcf);
close(aviobj);
end