function [ output_args ] = BrowseNeuronCorr(moviefile,NeuronID,cx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load NeuronCorrProc;
load ProcOut;
load NormTraces;
close all;
for i = 1:length(NeuronImage)
    b = bwconncomp(NeuronImage{i});
    r = regionprops(b,'Centroid');
    Cents(i,1:2) = r.Centroid;
end

temp = pdist(Cents);
CentDist = squareform(temp);

display('checking buddies');

buddies = [];
for i = 1:NumNeurons
    if (i == NeuronID)
        continue;
    end
    if (CentDist(i,NeuronID) <= 15)
        buddies = [buddies,i];
    end
    
end

buddies
[b] = bwboundaries(NeuronImage{NeuronID});
nb = b{1};

figure(1);
subplot(2,2,1);
corrimg = (rval{NeuronID}).*(pval{NeuronID} < 0.05);
corrimg = corrimg > 0.85;

imagesc(corrimg);caxis([0 1]);hold on;
plot(nb(:,2)-Cents(NeuronID,1)+51,nb(:,1)-Cents(NeuronID,2)+51,'g');hold off;
subplot(2,2,2);imagesc(AvgN{NeuronID});hold on;plot(nb(:,2)-Cents(NeuronID,1)+51,nb(:,1)-Cents(NeuronID,2)+51,'g');hold off;
subplot(2,2,3:4);plot(trace(NeuronID,:));hold on;plot(FT(NeuronID,:));hold off;axis tight;

while(1)
    pause;
    display('pick a time to see the frame')
    [mx,my] = ginput(1);
    f = loadframe(moviefile,mx);
    figure(2);set(gcf,'Position',[1130         337         773         600]);
    
    
    
    %imagesc(f);caxis(cx);
    contour(f,100);
    hold on
    [b] = bwboundaries(NeuronImage{NeuronID});
    b = b{1};
    plot(b(:,2),b(:,1),'g');
    for j = 1:length(buddies)
        [b] = bwboundaries(NeuronImage{buddies(j)});%colormap gray;
        b = b{1};
        plot(b(:,2),b(:,1),'r');
    end
    hold off;
    
end
end


