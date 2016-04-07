function MakeT2Movies(MotCorrh5)
% MakeT2Movies(MotCorrh5)
%
%   Takes cropped, motion-corrected movie and makes two movies from it. 
%
%   SLPDF.h5: Takes a 3-pixel smoothed version of the input movie and
%   divides it by the 20-pixel smoothed version of the same movie. Then,
%   take the DF/F of the quotient. 
%
%   DFF.h5: DF/F of the 3-pixel smoothed movie. 
%

%% File names.
    folder = fileparts(fileparts(MotCorrh5));
    SLPDFname = fullfile(folder,'SLPDF.h5');
    DFFname = fullfile(folder,'DFF.h5'); 
    threePixName = fullfile(folder,'threePixSmooth.h5');
    tempfilename = fullfile(folder,'temp.h5');

%% Set up.
    info = h5info(MotCorrh5,'/Object'); 
    [~,Xdim,Ydim,nFrames] = loadframe(MotCorrh5,1);
    h5create(tempfilename,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single');
    h5create(threePixName,'/Object',info.Dataspace.Size,'ChunkSize',...
        [Xdim Ydim 1 1],'Datatype','single'); 
    
    %Filters. 
    LPfilter = fspecial('disk',20);
    threePixfilter = fspecial('disk',3);

%% Writing. 

profile off
profile on
    disp('Making Movies')
    info = h5info(MotCorrh5,'/Object');
    
    % Initialized ProgressBar
    resol = 1; % Percent resolution for progress bar
    p = ProgressBar(100/resol);
    update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
    
    for i=1:nFrames
        frame = single(loadframe(MotCorrh5,i,info));
        
        LPframe = imfilter(frame,LPfilter,'same','replicate');              %20-pixel filter.
        threePixFrame = imfilter(frame,threePixfilter,'same','replicate');  %3-pixel filter.
       
        h5write(threePixName,'/Object',threePixFrame,[1 1 i 1],...          %Write 3-pixel smoothed.
            [Xdim Ydim 1 1]); 
        h5write(tempfilename,'/Object',threePixFrame./LPframe,[1 1 i 1],...     %Write LP divide.
            [Xdim Ydim 1 1]); 
        
        if round(i/update_inc) == (i/update_inc) % Update progress bar
            p.progress;
        end
        
    end
    p.stop;
    
    disp('Making SLPDF.h5...');         %DF/F of LP divide. 
    Make_DFF(tempfilename,SLPDFname);
    
    disp('Making DFF.h5...');           %DF/F of 3-pixel smoothed. 
    Make_DFF(threePixName,DFFname);
    
    delete(tempfilename);
    delete(threePixName);
%     delete(SLPDFname);

profile viewer

end