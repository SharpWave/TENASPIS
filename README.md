# TENASPIS
(updated 6/5/2015)

Technique for Extraction of Neuronal Activity from Single Photon Imaging Sequences

Synopsis: This technique is based on two key insights. 1: because of the slow decay of GCaMP, the first derivative of the movie with respect to time can disambiguate adjacent neurons that have calcium transients that are temporally separated by less than the duration of the GCaMP decay window. 2: Using the temporal derivative movie, where inactive cells have values (less than or) equal to zero, it's simultaneously more accurate and more conservative to base whether a neuron is considered be active on whether the neuron's cell body can be detected via image segmentation (and adaptive thresholding), than by taking an ROI trace and setting some fixed threshold.

master branch: newest stable

requires that you include my GeneralMatlab repository (https://github.com/SharpWave/GeneralMatlab)
requires that you include Nat's ImageCamp repository (https://github.com/nkinsky/ImageCamp)

in GeneralMatlab, there's a function called MakeMouseSessionList.m.  You must edit this function to include the locations of your data, then run it.  

top level script:
Tenaspis.m

required inputs
infile: an .h5 file from the scope that has been cropped and motion corrected and smoothed with a 3-pixel radius disc.
animal_id: your subject's name; e.g., GCaMP6f_31
sess_date: the date the session took place, e.g., '09_29_2014'
sess_num: which session for a given date to analyze





