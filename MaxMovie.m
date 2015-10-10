function [] = MaxMovie(infile,outfile)

% makes of movie of the max evolving


figure1 = figure;
set(gcf,'Position',[1          41        1920         964]);

aviobj = VideoWriter(outfile,'MPEG-4');
aviobj.FrameRate = 60;
open(aviobj);

[frame,Xdim,Ydim,NumFrames] = loadframe(infile,1); 

maxframe = zeros(size(frame));

for i = 1:NumFrames
    [frame,Xdim,Ydim,NumFrames] = loadframe(infile,i);
    frame = double(frame);
    maxframe = max(frame,maxframe);
    imagesc(maxframe);
    colormap gray;
    axis equal;axis off;
    F = getframe;
    writeVideo(aviobj,F);hold off;
end  
    

