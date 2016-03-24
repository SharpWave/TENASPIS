function MakeT2Movies(MotCorrh5)
%
%
%

%%
    folder = fileparts(fileparts(MotCorrh5));
    SLPDFname = fullfile(folder,'SLPDF.h5');
    DFFname = fullfile(folder,'DFF.h5'); 
    threePixName = fullfile(folder,'threePixSmooth.h5');
    tempName = fullfile(folder,'temp.h5');
    
    info = h5info(MotCorrh5,'/Object'); 
    [~,Xdim,Ydim,nFrames] = loadframe(MotCorrh5,1);
    h5create(tempName,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single');
    h5create(threePixName,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single'); 
    
    LPfilter = fspecial('disk',20);
    threePixfilter = fspecial('disk',3);
    
    p=ProgressBar(nFrames);
    for i=1:nFrames
        frame = single(loadframe(MotCorrh5,i));
        
        LPframe = imfilter(frame,LPfilter,'same','replicate'); 
        threePixFrame = imfilter(frame,threePixfilter,'same','replicate'); 
       
        h5write(threePixName,'/Object',threePixFrame,[1 1 i 1],...
            [Xdim Ydim 1 1]); 
        h5write(tempName,'/Object',threePixFrame./LPframe,[1 1 i 1],...
            [Xdim Ydim 1 1]); 
        
        p.progress;
    end
    p.stop;
    
    disp('Making SLPDF.h5...');
    Make_DFF(tempName,SLPDFname);
    
    disp('Making DFF.h5...');
    Make_DFF(threePixname,DFFname);
    
    !del tempName
end