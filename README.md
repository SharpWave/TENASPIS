# TENASPIS
(updated 5/15/2017)

compatible with MATLAB 2016B (and later) only!!!!

How to get started:

1. Your movie file needs to be motion-corrected, and currently, in the .h5 format used by Inscopix. Scripts for converting .mov and .avi files to .h5 are in the pipeline.

2. Examine the parameters in Set_T_Params.m and edit them if needed, then run Set_T_Params.

3. Run MakeFilteredMovies.m

4. Run Tenaspis4singlesession.m

outputs are saved in FinalOutput.mat.  Important outputs:

PSAbool: Basically the rastergram for the recording session. N x T, where N is # of neurons and T is # of samples in the session

NeuronTraces: a struct containing calcium traces for every neuron. Filtered, raw, and first derivative are available.

NeuronImage: a binary matrix (same size as a movie frame) showing the ROI for each neuron

NeuronPixelIdxList: same information as NeuronImage but just the list of pixels indices belonging to each ROI






