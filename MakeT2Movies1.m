function MakeT2Movies1(MotCorrh5)
%MakeT2Movies(MotCorrh5)
%
%   Takes cropped motion-corrected movie and smooths it with a 3-pixel disc
%   and then a 20-pixel disc. Then divides the 3-pixel smoothed movie by
%   the 20-pixel smoothed movie (SLPDF.h5). Then computes DFF.h5 with the
%   3-pixel smoothed movie. 
%

%%
    folder = fileparts(fileparts(MotCorrh5));
    SLPDFname = fullfile(folder,'SLPDF.h5');
    threePixName = fullfile(folder,'threePixSmooth.h5');
    DFFname = fullfile(folder,'DFF.h5');
    
    info = h5info(MotCorrh5,'/Object');
    [~,Xdim,Ydim,nFrames] = loadframe(MotCorrh5,1); 
    h5create(SLPDFname,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single');
    h5create(threePixName,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single'); 
    
    LPfilter = fspecial('disk',20);
    threePixfilter = fspecial('disk',3); 
    
    disp('Making SLPDF.h5...');
    p=ProgressBar(nFrames);
    for i=1:nFrames
        frame = single(loadframe(MotCorrh5,i));
        
        LPframe = imfilter(frame,LPfilter,'same','replicate'); 
        threePixFrame = imfilter(frame,threePixfilter,'same','replicate'); 
        
        h5write(threePixName,'/Object',threePixFrame,[1 1 i 1],...
            [Xdim Ydim 1 1]); 
        h5write(SLPDFname,'/Object',threePixFrame./LPframe,[1 1 i 1],...
            [Xdim Ydim 1 1]); 
        p.progress;
    end
    p.stop;
    
    Make_DFF(threePixName,DFFname);
end