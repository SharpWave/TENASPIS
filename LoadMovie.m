function LoadMovie(moviefile)
% loads the movie from the file into a global variable in RAM

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

global T_MOVIE;
T_MOVIE = LoadFrames(moviefile,1:NumFrames);

end

