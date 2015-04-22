function [] = ExtractNeurons(mask)
% [] = ExtractNeurons2015()
% Make sure that ICmovie.h5 (motion corrected and cropped with one round of
% 3-pixel disc smoothing) and Pos.mat (manually corrected mouse positions)
% are in the directory

%% Step 1: Smooth the movie
TempSmoothMovie(infile,'SMovie.h5',20);

%% Step 2: Take the first derivative
ChangeMovie('SMovie.h5','D1Movie.h5');
!del SMovie.h5

%% Step 3: Determine the threshold
[meanframe,stdframe] = moviestats('D1movie.h5');
thresh = 4*mean(stdframe);
save Blobthresh.mat thresh;

%% Step 4 (optional): Create the mask
if (nargin == 0)
    EstimateBlobs('D1Movie.h5',0,thresh);
    beep;
    MakeBlobMask();
    load mask.mat;
end

% Step 5: Extract Blobs
ExtractBlobs('D1Movie.h5',0,thresh,mask);

%% Step 6: String Blobs into calcium transients
load CC.mat
MakeTransients('D1Movie.h5',cc);

%% Step 7: Decide which transients (segments) belong to the same neuron
load Segments.mat;
ProcessSegs(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim);

% Step 8: Calculate Placefields
CalculatePlacefields();

% Step 9: Calculate Placefield stats


