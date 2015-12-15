function [] = TenaspisVsPCAICA(moviefile)

load ProcOut.mat;
load ICoutput.mat;

for i = 1:length(NeuronImage)
    Tprops{i} = regionprops(NeuronImage{i});
    Tcent(i,1:2) = Tprops{i}.Centroid;
end

for i = 1:length(ICprops)
    Icent(i,1:2) = ICprops{i}.Centroid;
end

% compute all pairwise distances between neuron centroids
CluDist = pdist([Tcent;Icent],'euclidean');
CluDist = squareform(CluDist);

for i = 1:length(NeuronImage)
    for j = 1:length(ICprops)
        Cdist(i,j) = CluDist(i,j+length(NeuronImage));
    end
end

for i = 1:length(NeuronImage)
    % average frame
    display(['Calculating Mean Image for Neuron ',int2str(i)]);
    ActiveF = find(FT(i,:));
    MeanT{i} = zeros(size(NeuronImage{1}));
    for j = 1:length(ActiveF)
        MeanT{i} = MeanT{i}+single(loadframe(moviefile,ActiveF(j)));
    end
    nAFT(i) = length(ActiveF);
    if (nAFT(i) > 0)
    MeanT{i} = MeanT{i}./nAFT(i);
    end
end

    
    

keyboard;
% for each Tneuron, determine if it has a match (min distance < x)
% if match present, compare activity

% for each Ineuron, determine if it has a match