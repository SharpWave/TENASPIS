function [ ] = tiff2h5( filename )
% tiff2h5( filename )
%   Takes a tiff stack and saves it in h5 format with the same filename.
%   Filename must be in path\file.tif format.

[p,f ] = fileparts(filename);
h5name = fullfile(p,[f '.h5']);

% temp = imread(filename,1);
% info = imfinfo(filename);
try
    tiff_import = imread_big(filename);
    [Ydim, Xdim, nframes] = size(tiff_import);
catch
    disp('imread_big failed to import TIFF file - using alternate procedure')
    info1 = imfinfo(filename);
    nframes = length(info1);
    Ydim = info1.Height;
    Xdim = info1.Width;
    tiff_import = nan(Ydim, Xdim, nframes);
    for j = 1:nframes
       tiff_import(:,:,j) = imread(filename,j,'Info',info1);
    end
end


h5create(h5name,'/Object',[Ydim Xdim nframes 1],'Datatype','single');

h = waitbar(nframes, 'Converting TIFF to H5');
for j = 1:nframes
    h5write(h5name,'/Object', squeeze(tiff_import(:,:,j)), [1 1 j 1],...
        [Ydim Xdim 1 1]);
    waitbar(j/nframes,h);
end
close(h)

end

