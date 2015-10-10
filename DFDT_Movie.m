function [] = DFDT_Movie(infile,outfile);
% [] = DFDT_Movie(infile,outfile);


info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'Datatype','int16');

F0 = h5read(infile,'/Object',[1 1 1 1],[XDim YDim 1 1]);
%F0 = int16(F0);
h5write(outfile,'/Object',int16(zeros(size(F0))),[1 1 1 1],[XDim YDim 1 1]);

for i = 2:NumFrames
  display(['Calculating temporal difference for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  F1 = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1])*500;
  DF = F1-F0;
  F0 = F1;

  if (i <= 20)
      DF = (zeros(size(DF)));
  end
  if ((max(DF(:)) > intmax('int16')) | (min(DF(:)) < intmin('int16')))
      error('integer conversion error');
  end
  
  h5write(outfile,'/Object',int16(DF),[1 1 i 1],[XDim YDim 1 1]);
end

  