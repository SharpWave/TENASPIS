function [] = integerizemovie(infile,outfile,mfactor)
% takes a movie, multiplies it by factor, rounds, saves

[frame,Xdim,Ydim,NumFrames] = loadframe(infile,1);
info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[Xdim Ydim 1 1],'Datatype','int32');

for i = 1:NumFrames
    temp = loadframe(infile,i);
    mins(i) = min(temp(:));
    maxes(i) = max(temp(:));
end

figure;subplot(1,2,1);hist(mins);title('min pixel values');
subplot(1,2,2);hist(maxes);title('max pixel values');
pause;

for i = 1:NumFrames
    temp = loadframe(infile,i);
    temp = int32(temp.*mfactor);
    h5write(outfile,'/Object',temp,[1 1 i 1],[Xdim Ydim 1 1]);
end
