function [ output_args ] = SimpleSessionStats( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load ProcOut;
for i = 1:NumNeurons
    NumTransients(i) = size(NP_FindSupraThresholdEpochs(FT(i,:),eps),1);

end
keyboard;


