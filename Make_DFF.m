function [ output_args ] = Make_DFF(moviefile,outfile)

[~,XDim,YDim,NumFrames] = loadframe(moviefile,1);
info = h5info(moviefile,'/Object');
h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','single');

display('determining averages');

% get averages.
avgframe = zeros(XDim,YDim);

for i = 1:NumFrames
   [frame,Xdim,Ydim,NumFrames] = loadframe(moviefile,i); 
   avgframe = avgframe+single(frame);
end
avgframe = avgframe./NumFrames;

% make DFF
display('calculating and saving DFF');
for i = 1:NumFrames
    [frame,Xdim,Ydim,NumFrames] = loadframe(moviefile,i); 
    newframe = (single(frame)-avgframe)./avgframe;
    h5write(outfile,'/Object',newframe,[1 1 i 1],[XDim YDim 1 1]);
end



