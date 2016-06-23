function [] = MakeHighpassDFF(inmovie,outmovie)
% SpatialDiscSmooth(inmovie,outmovie,radius)

info = h5info(inmovie,'/Object');
[~,Xdim,Ydim,NumFrames] = loadframe(inmovie,1);
h5create('temp.h5','/Object',info.Dataspace.Size,'ChunkSize',[Xdim Ydim 1 1],'Datatype','single');


% make filter
LPfilter = fspecial('disk',20);


display('smoothing');
for i = 1:NumFrames
    frame = single(loadframe(inmovie,i));
    smframe = imfilter(frame,LPfilter,'same','replicate');
    h5write('temp.h5','/Object',frame./smframe,[1 1 i 1],[Xdim Ydim 1 1]);
end
display('calculating DFF');
Make_DFF('temp.h5',outmovie);
!del temp.h5

    
end