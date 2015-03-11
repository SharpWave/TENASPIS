function [] = ExtractBlobs(file,todebug,thresh,mask)
% [] = ExtractBlobs(file,todebug,thresh,mask)
% extract active cell "blobs" from movie in file
% todebug 0 or 1 depending if you want to go through frame-by-frame
% thresh is initial threshold (try BlobStats for thresh determination)


info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

av = zeros(Xdim,Ydim);

if (nargin < 4)
    mask = ones(Xdim,Ydim);
end
oldmask = mask;

for i = 1:NumFrames
    tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    if (i <=20)
        
        mask = zeros(Xdim,Ydim);
    else
        mask = oldmask;
    end
    [bw,cc{i}] = SegmentFrame(tempFrame,0,mask,thresh);
    if(todebug == 1)
        subplot(1,2,1);imagesc(bw);colormap gray;cc{i}.PixelIdxList,
        subplot(1,2,2);imagesc(tempFrame);caxis([0 thresh]);pause;
        %subplot(1,4,3);imagesc(outframe);caxis([3 4]);
        %subplot(1,4,4);hist((outframe(:)),50);pause;
    end
    
    av = av+bw;
    i
end
figure;imagesc(av);
% Iterate through the file and identify unambiguous segments that appear on
% consecutive frames



save CC.mat cc av thresh;
%keyboard;


            
