function [ traces ] = LoadMoviePixels(filename,pixel_idx)
%LoadMoviePixels.m
%   Detailed explanation goes here
info = h5info(filename,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

traces = zeros(length(pixel_idx),NumFrames);



for i = 1:NumFrames
 
  tempFrame = h5read('FLmovie.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
  for j = 1:length(pixel_idx)
      traces(j,i) = tempFrame(pixel_idx(j));
  end

end

end

