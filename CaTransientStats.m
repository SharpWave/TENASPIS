function [ output_args ] = CaTransientStats( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load InitClu.mat; %c Xdim Ydim seg Xcent Ycent frames MeanNeuron meanareas meanX meanY NumEvents Invalid overlap

CluDist = pdist([meanX',meanY'],'euclidean');
CluDist = squareform(CluDist);

keyboard;


end

