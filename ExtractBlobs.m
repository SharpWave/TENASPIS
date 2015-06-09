function [] = ExtractBlobs(file,todebug,thresh,mask)
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



if (nargin < 4)
    mask = ones(Xdim,Ydim);
end
oldmask = mask;

parfor i = 1:NumFrames
    
    tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    
    if (i <= 20)
        % Don't detect neurons on first 20 frames
        mask = zeros(Xdim,Ydim);
    else
        mask = oldmask;
    end
    
    [~,cc{i}] = SegmentFrame(tempFrame,0,mask,thresh);
    

    display(['Detecting Blobs for frame ',int2str(i)]);

end



save CC.mat cc thresh mask;



            
