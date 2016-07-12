function Make_DFF(moviefile,outfile)

info = h5info(moviefile,'/Object');
[~,XDim,YDim,NumFrames] = loadframe(moviefile,1,info);
h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','single');

%% Get averages.
display('determining averages');
avgframe = zeros(XDim,YDim); % Initialize variable

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
for i = 1:NumFrames
   [frame] = loadframe(moviefile,i,info); 
   avgframe = avgframe+single(frame);
   
   if round(i/update_inc) == (i/update_inc) % Update progress bar
       p.progress;
   end
   
end
avgframe = avgframe./NumFrames;
p.stop;

%% Make DFF
display('calculating and saving DFF');

% Initialize ProgressBar
resol = 1; % Percent resolution for progress bar
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
for i = 1:NumFrames
    [frame,~,~,~] = loadframe(moviefile,i,info); 
    newframe = (single(frame)-avgframe)./avgframe;
    h5write(outfile,'/Object',newframe,[1 1 i 1],[XDim YDim 1 1]);
    
    if round(i/update_inc) == (i/update_inc) % Update progress bar
       p.progress;
    end
   
end
p.stop;

end
