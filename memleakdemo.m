function [] = memleakdemo(out_avifile)


aviobj = VideoWriter(out_avifile);
aviobj.FrameRate = 4;
open(aviobj);

figure;
set(gcf,'Position',[611 102 1079 862]);

for i = 1:3000
    frame = rand(300);
    imagesc(frame);
    F = getframe(gcf);
    writeVideo(aviobj,F);
    clear F;
end
close(gcf);
close(aviobj);
end

