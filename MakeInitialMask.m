function [] = MakeInitialMask(infile)
%[] = MakeBlobMask(file)

temp = imread(infile);
figure(901);imagesc(temp);axis equal;

ToContinue = 'n';
display('draw a circle around the area with good cells');
while(strcmp(ToContinue,'y') ~= 1)
    mask = roipoly;
    figure;imagesc(mask);
    
    ToContinue = input('OK with the mask you just drew? [y/n] --->','s');
    figure(901);imagesc(temp);axis equal;
end
save Initialmask.mat mask


end

