function [spiketrain] = run_oopsi(F,V,P)
% this function runs our various oopsi filters, saves the results, and
% plots the inferred spike trains.  make sure that fast-oopsi and
% smc-oopsi repository are in your path if you intend to use them.
%
% to use the code, simply provide F, a vector of fluorescence observations,
% for each cell.  the fast-oopsi code can handle a matrix input,
% corresponding to a set of pixels, for each time bin. smc-oopsi expects a
% 1D fluorescence trace.
%
% see documentation for fast-oopsi and smc-oopsi to determine how to set
% variables
%
% input
%   F: fluorescence from a single neuron
%   V: Variables necessary to define for code to function properly (optional)
%   P: Parameters of the model (optional)
%
% possible outputs
%   fast:   fast-oopsi MAP estimate of spike train, argmax_{n\geq 0} P[n|F], (fast.n),  parameter estimate (fast.P), and structure of  variables for algorithm (fast.V)
%   smc:    smc-oopsi estimate of {P[X_t|F]}_{t<T}, where X={n,C} or {n,C,h}, (smc.E), parameter estimates (smc.P), and structure of variables for algorithm (fast.V)

%% set code Variables

F=F-min(F); F=F/max(F); F=F+eps;

%% infer spikes and estimate parameters

                                             % infer spikes using fast-oopsi
    
    [fast.n fast.P fast.V]= fast_oopsi(F,V,P);
fast.P
spiketrain = fast.n;
