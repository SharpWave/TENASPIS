function [] = ExtractNeurons2015()
% [] = ExtractNeurons2015()
% Make sure that ICmovie.h5 (motion corrected and cropped with one round of
% 2-pixel disc smoothing) and Pos.mat (manually corrected mouse positions)
% are in the directory

SR = 20;

tic
% Step 1: Smooth the movie
TempSmoothMovie('smIC.h5','SMovie.h5',20);

% Step 2: Take the first derivative
ChangeMovie('SMovie.h5','D1Movie.h5');
!del SMovie.h5 

% Step 3: Extract Ca2+ Events
ExtractCaEvents2('D1Movie.h5',0,thresh);return;

% Step 4: Make Segments
MakeSegments('D1Movie.h5',cc);
load Segments.mat;

% Step 5: Combine the segments by neuron
ProcessSegs(NumSegments, SegChain, SegList, cc, NumFrames, Xdim, Ydim)

TotalTime = toc


% Step 6: Make Placefields
