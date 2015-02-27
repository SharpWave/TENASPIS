function [] = AutoSegMovie(infile,outfile);


info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','uint16');

for i = 1:NumFrames
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  temp = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]);
  temp1 = temp;
  bg = imopen(temp,strel('disk',15));
  temp = temp-bg;
  temp = imadjust(temp);
  level = graythresh(temp);
  bw = im2bw(temp,level);
  bw = bwareaopen(bw,50);
  %imshow(bw);
  h5write(outfile,'/Object',uint16(round(bw.*temp1*(2^15))),[1 1 i 1],[XDim YDim 1 1]);
end

  