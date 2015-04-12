function [] = ChangeMovie(infile,outfile);



info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','int32');

F0 = h5read(infile,'/Object',[1 1 1 1],[XDim YDim 1 1]);
h5write(outfile,'/Object',int32(zeros(size(F0))),[1 1 1 1],[XDim YDim 1 1]);

for i = 2:NumFrames
  display(['Calculating temporal difference for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  F1 = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]);
  DF = F1-F0;
  F0 = F1;
  if (i <= 20)
      DF = zeros(size(DF));
  end
  h5write(outfile,'/Object',int32(DF),[1 1 i 1],[XDim YDim 1 1]);
end

  