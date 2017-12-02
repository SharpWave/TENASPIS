function Set_T_Params(moviefile)
% function Set_T_Params(moviefile)
%
% Sets Tenaspis parameters.  Must be called at beginning of run
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
%
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear T_PARAMS;
global T_PARAMS;

%% The dimensions of the movie - load from .mat file if possible, to save time when this function is called by parfor workers
if (~exist('MovieDims.mat','file'))
    info = h5info(moviefile,'/Object');
    [T_PARAMS.Xdim,Xdim] = deal(info.Dataspace.Size(1));
    [T_PARAMS.Ydim,Ydim] = deal(info.Dataspace.Size(2));
    [T_PARAMS.NumFrames,NumFrames] = deal(info.Dataspace.Size(3));
    save MovieDims.mat Xdim Ydim NumFrames
else
    load('MovieDims.mat','Xdim','Ydim','NumFrames');
    T_PARAMS.Xdim = Xdim;
    T_PARAMS.Ydim = Ydim;
    T_PARAMS.NumFrames = NumFrames;
end

%% Implementation parameters (i.e. no effect on results)
T_PARAMS.FrameChunkSize = 1250; % Number of frames to load at once for various functions.  Setting this too high will crash due to RAM
T_PARAMS.ROICircleWindowRadius = 35; % If this is too small the program crashes; higher values use more RAM and increase run time. Default is overkill

%% General parameters used by multiple scripts
T_PARAMS.SampleRate = 10; % Sample rate of the movie to be processed.  

%% MakeFilteredMovies
T_PARAMS.HighPassRadius = 20; % Smoothing radius for high pass disk-kernel filtering. EDIT:SPACE
T_PARAMS.LowPassRadius = 1; % Smoothing radius for low pass disk-kernel filtering. EDIT:SPACE

%% ExtractBlobs / SegmentFrame params
T_PARAMS.threshold = 0.01; % Pixel intensity baseline threshold for detecting blobs. Lower means more blobs but more noise and longer runs

T_PARAMS.threshsteps = 50; % number of threshold increments to try in order to find criterion region within non-criterion blob and check for multiple peaks in criterion blobs
                           % higher values mean slightly bigger ROIs at the cost of multiplying run time - edit this with care.
                      
T_PARAMS.MaxBlobRadius = 12; % Maximum radius for a circular shaped blob to be included. 
                             % trade off between not including multiple neurons and missing pixels that reliably
                             % participate and can be used to differentiate ROIs in subsequent steps
                             % EDIT:SPACE
                             
T_PARAMS.MinBlobRadius = 4; % Minimum radius for circular shaped blob to be included. 
                            % Increasing this eliminates noise at the cost
                            % of losing low-intensity blobs. EDIT:SPACE

T_PARAMS.MaxAxisRatio = 50; % Maximum ratio of major to minor axis length for blobs. Lower means more circular. 
                           % Keeps overly slivery blobs and some juxtaposition artifacts out of the data
                           
T_PARAMS.MinSolidity = 0.975; % Minimum blob 'solidity', which is the ratio of the perimeter of the convex hull to the actual perimeter. 
                             % Prevents jagged and strange shaped blobs; noise blobs picked up at low thresholds

%% LinkBlobs params

T_PARAMS.BlobLinkThresholdCoeff = 1; % multiplier for the blob minor axis length to determine whether to link blobs across frames
                                     % the higher this is, the more the blob is permitted to move on successive frames
                                     % The linkblobs procedure has almost no pitfalls; I wouldn't bother messing with this

%% RejectBadTransients params
T_PARAMS.MaxCentroidTravelDistance = 4; % maximum net distance that the centroid of a transient can travel. 
                                        % Eliminates spurious blobs from overlapping transients.
                                        % EDIT:SPACE
                                        
T_PARAMS.MinNumFrames = ceil(12/(20/T_PARAMS.SampleRate)); % minimum number of frames for transient to be included. EDIT:TIME

%% MakeTransientROIs params
T_PARAMS.MinPixelPresence = 0.5; %0.6321; % minimum fraction of frames in the transient for a pixel to be counted as part of an ROI. 
% Setting to 1 means the pixels in the smallest blob in the transient (often right before fadeout) will be chosen. 
% Setting to 0 means the maximum blob extent will be used. 


%% MergeTransientROIs paramsload
T_PARAMS.DistanceThresholdList = [20]; % list of progressively increasing distance thresholds to try. EDIT:SPACE
%                                              With the correlation test being pretty robust I'm not sure that small increments are necessary
T_PARAMS.MaxTransientMergeCorrP = 0.01;      % maximum correlation p value for a transient merge
T_PARAMS.MinTransientMergeCorrR = 0.2;       % minimum correlation r value for a transient merge. 
%                                              I played with higher values and they don't help us avoid bad merges, but cause some under-merging

T_PARAMS.ROIBoundaryCoeff = 0.5;             % ROI boundaries are determined by setting a threshold at some fraction of the peak mean intensity
                                             % lower values mean bigger ROIs
                                             
T_PARAMS.SmoothSize = ceil(5/(20/T_PARAMS.SampleRate));                     % length of window for temporal smoothing of traces.  EDIT:SPACE
T_PARAMS.MinNumTransients = 1;               % ROIs with fewer transients than this are cut after segmentation. recommend setting to 1, meaning no cut

%% DetectTracePSA
T_PARAMS.AmplitudeThresholdCoeff = 2/3; % Determines amplitude threshold for finding new transients. 
                                        % setting to 0 means new transient threshold is minimum intensity of segmentation-detected transients
                                        % setting to 1 means threshold is zero -  Higher values mean lower threshold.
                                        
T_PARAMS.CorrPthresh = 0.00001; % p value threshold for correlation between ROI average and ROI on a single frame

T_PARAMS.SlopeThresh = 0.5; % minimum slope (z-score) for a new PSA epoch (i.e., positive slope) to begin
                            % use a lower value if detected slopes aren't
                            % starting early enough.  Use a higher value if
                            % 

T_PARAMS.MinPSALen = ceil(4/(20/T_PARAMS.SampleRate));     % minimum duration of PSA epochs, enforced right after detection. Helps to eliminate noise; 250ms is awfully short for a spiking epoch
                            % EDIT:TIME
                            
%% MergeSuspiciousNeighors
T_PARAMS.MinBinSimRank = 0.94; % minimum rank normalized Binary Similarity between two ROI actvity vectors for a merge (similarity must be this percentile of non-adjacent similarities)
T_PARAMS.ROIoverlapthresh = 0.5; % minimum normalized overlap (% of area of smallest ROI) between ROIs for a merge 

T_PARAMS.MaxGapFillLen = ceil(4/(20/T_PARAMS.SampleRate)); % After detecting rising slopes, if the gaps between PSA epochs are this # of samples or smaller, fill them in.
                            % smooths the skippyness in some borderline
                            % cases. % EDIT:TIME 
                            
%% FinalizeData
T_PARAMS.MinNumPSAepochs = 4; % minimum number of PSA epochs for inclusion in final ROI set. i.e., we delete the ones with less than this
                              % if there are some "straggler" under-merged ROIs this can help to remove them. 
                              % Higher values will yield a "cleaner" data set at the cost of omitting potentially valid but low firing neurons
                              % EDIT:TIME? (questionable)
end

