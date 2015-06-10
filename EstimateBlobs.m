function [] = EstimateBlobs(file,todebug,thresh,neuronmask)
% [] = ExtractBlobs(file,todebug,thresh,mask)
% extract active cell "blobs" from movie in file
% todebug 0 or 1 depending if you want to go through frame-by-frame
% thresh is initial threshold (try BlobStats for thresh determination)
% mask is the binary mask of which areas to use and not to use
% use MakeBlobMask to make a mask

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

av = zeros(Xdim,Ydim);

if (nargin < 4)
    neuronmask = ones(Xdim,Ydim);
end
oldmask = neuronmask;

for i = 1:20:NumFrames
    tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    
    if (i <= 20)
        % Don't detect neurons on first 20 frames
        neuronmask = zeros(Xdim,Ydim);
    else
        neuronmask = oldmask;
    end
    
    [bw,cc{i}] = SegmentFrame(tempFrame,0,neuronmask,thresh);
    
    if (todebug == 1)
        subplot(1,2,1);imagesc(bw);colormap gray;cc{i}.PixelIdxList,
        subplot(1,2,2);imagesc(tempFrame);caxis([0 thresh]);pause;
    end
    
    av = av+bw;
    i
end
figure;imagesc(av);





            
