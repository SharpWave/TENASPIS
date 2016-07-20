function [ output_args ] = MakeMaskSingleSession()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all;
[~,Xdim,Ydim,NumFrames] = loadframe('DFF.h5',1);

% step 1 build up a maximum projection, using every 5th frame
newmax = zeros(Xdim,Ydim);

for i = 1:5:NumFrames
    temp = loadframe('DFF.h5',i);
    newmax(temp > newmax) = temp(temp > newmax);
end

h = figure;
%imagesc(newmax);colormap gray;axis equal;


ToContinue = 'n';
display('draw a circle around the area with good cells');
while(strcmp(ToContinue,'y') ~= 1)
    neuronmask = roipoly(newmax);
    figure;imagesc(neuronmask);
    
    ToContinue = input('OK with the mask you just drew? [y/n] --->','s');
end
save singlesessionmask.mat neuronmask;



end

