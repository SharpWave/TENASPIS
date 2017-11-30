function [ ] = mov2h5(filename)
% mov2h5(filename) Takes .mov file and converts it to .h5 file

[p,f ] = fileparts(filename);
h5name = fullfile(p,[f '.h5']);

obj = VideoReader(filename);
Xdim = obj.Width;
Ydim = obj.Height;
nframes = round(obj.Duration/(1/obj.FrameRate));

h5create(h5name,'/Object',[Ydim Xdim nframes 1],'Datatype','single');

h = waitbar(nframes, 'Converting .mov to .h5');
for j = 1:nframes
    frame_use = readFrame(obj);
    h5write(h5name,'/Object', squeeze(frame_use(:,:,1)), [1 1 j 1],...
        [Ydim Xdim 1 1]);
    waitbar(j/nframes,h);
end
close(h)


end

