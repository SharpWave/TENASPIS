function [] = ExtractCaEvents2(file,todebug)

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

av = zeros(Xdim,Ydim);
oldthresh = 4;
load mask.mat;
for i = 1:NumFrames
    tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    [bw,cc{i},thresh(i),pthresh(i),outframe] = SegmentFrame3(tempFrame,0,oldthresh,mask);
    if(todebug == 1)
    subplot(1,4,1);imagesc(bw);colormap gray;cc{i}.PixelIdxList,
    subplot(1,4,2);imagesc(tempFrame);caxis([0 pthresh(i)]);
    subplot(1,4,3);imagesc(outframe);caxis([0 pthresh(i)]);
    subplot(1,4,4);hist((outframe(:)),50);pause;
    end
    oldthresh = pthresh(i);
    av = av+bw;
    i
end
figure;imagesc(av);
% Iterate through the file and identify unambiguous segments that appear on
% consecutive frames



save CC.mat cc thresh;



            
