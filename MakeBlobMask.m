function [] = MakeBlobMask()
%[] = MakeBlobMask(file)
% creates an image of all naively detected blobs, asks the user to draw the
% good stuff, then saves the mask to disk

ToContinue = 'n';
display('draw a circle around the area with good cells');
while(strcmp(ToContinue,'y') ~= 1)
    neuronmask = roipoly;
    figure;imagesc(neuronmask);
    ToContinue = input('OK with the mask you just drew? [y/n] --->','s');
end
save manualmask.mat neuronmask
close all;

end

