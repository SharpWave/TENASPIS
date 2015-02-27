function [] = DebugSegmentation(NumICA)

[ICThresh,IC,NumICA,x,y] = EditICA(NumICA,60); % 

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

info = h5info('FLmovie.h5','/Object');
NumFrames = info.Dataspace.Size(3);

for i = 1:NumFrames
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  tempFrame = h5read('FLmovie.h5','/Object',[1 1 i 1],[Xdim Ydim 1 1]);
  [frame,cc] = SegmentFrame(tempFrame);
  NumObj(i) = cc.NumObjects;
  keyboard;
end

keyboard;