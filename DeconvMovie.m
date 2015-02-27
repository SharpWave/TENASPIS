function [] = DeconvMovie(infile,outfile);

radius = 30;

psf = fspecial('gaussian',radius,radius);

info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','uint16');

for i = 1:NumFrames
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  tempFrame = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]);
  
  %%% EXPERIMENTAL: Sharpening
  tempFrame = edgetaper(tempFrame,psf);
  tempFrame = deconvlucy(tempFrame,psf,5); % 5 iterations
  
  h5write(outfile,'/Object',uint16(tempFrame),[1 1 i 1],[XDim YDim 1 1]);
end

  