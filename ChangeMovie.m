function [] = ChangeMovie(infile,outfile);



info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','single');

F0 = h5read(infile,'/Object',[1 1 1 1],[XDim YDim 1 1]);
h5write(outfile,'/Object',single(zeros(size(F0))),[1 1 1 1],[XDim YDim 1 1]);

for i = 2:NumFrames
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  F1 = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]);
  DF = F1-F0;
  F0 = F1;
  h5write(outfile,'/Object',single(DF),[1 1 i 1],[XDim YDim 1 1]);
end

  