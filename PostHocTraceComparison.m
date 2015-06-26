function [ output_args ] = PostHocTraceComparison(h5file)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% load the stuff

% for each neuron:
% add up all frames for the FT
% both for blob traces and reg traces, for D1 and reg movie
% make a copy and divide by number of frames
%
% determine the "virtual threshold"
% determine the additional frames that would be included under the virtual
% threshold, add those, divide by total

% Compare the two average frames
load PlaceMaps.mat; % lazy, for getting the outlines
load ProcOut.mat;
load DumbTraces.mat;

for i = 1:NumNeurons
    activeframes = find(FT(i,:) == 1);
    display([int2str(length(activeframes)),' base active frames']);
    avgframe{i} = zeros(size(NeuronImage{1}));
    for j = activeframes
        avgframe{i} = avgframe{i} + double(loadframe(h5file,j));
    end
    avgframe{i} = avgframe{i}./length(activeframes);

    % normalize Traces
    Dtrace(i,:) = zscore(Dtrace(i,:));
    Rawtrace(i,:) = zscore(Rawtrace(i,:));
    
    ae = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    
    % calculate virtual threshold
    tr_start_values = Dtrace(i,ae(:,1));
    virt_d1_thresh = mean(tr_start_values);
    
    threshframes = find(Dtrace(i,:) > virt_d1_thresh);
    threshframes = union(threshframes,activeframes);
    display([int2str(length(threshframes)),' expanded active frames']);
    t_avgframe{i} = zeros(size(NeuronImage{1}));
    
    for j = threshframes
        t_avgframe{i} = t_avgframe{i} + double(loadframe(h5file,j));
    end    
    t_avgframe{i} = t_avgframe{i}./length(threshframes);
    
    subplot(1,3,1);
    imagesc(avgframe{i});title([int2str(length(activeframes)),' base active frames, # CT = ',int2str(NumTransients(i))]);
    hold on;plot(xOutline{i},yOutline{i},'-r');hold off;
    
    subplot(1,3,2);
    imagesc(t_avgframe{i});title([int2str(length(threshframes)),' expanded active frames']);
    hold on;plot(xOutline{i},yOutline{i},'-r');hold off;
    
    subplot(1,3,3);
    imagesc(avgframe{i}-t_avgframe{i});colorbar;title('base minus expanded');
    hold on;plot(xOutline{i},yOutline{i},'-r');hold off;pause;
   
end

    
    


end

