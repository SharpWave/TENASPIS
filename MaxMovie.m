function [outputArg1,outputArg2] = MaxMovie()

global T_MOVIE;

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

HalfWinLength = 6;
h5create('MaxMovie.h5','/Object',[Xdim Ydim NumFrames 1],'ChunkSize',[Xdim Ydim 1 1],'Datatype','single');

p = ProgressBar(NumFrames);
for i = 1:NumFrames
  sidx = max(1,i-HalfWinLength);
  fidx = min(i+HalfWinLength,NumFrames);
  MaxFrame = max(T_MOVIE(:,:,sidx:fidx),[],3);
  h5write('MaxMovie.h5','/Object',MaxFrame,[1 1 i 1],[Xdim Ydim 1 1]);
  p.progress;
end
p.stop;
