function [ pval ] = StrapIt2(Trace,MovMap,Xbin,Ybin,cmperbin,goodepochs,isrunning,toplot)
% function [ pval ] = StrapIt(Trace,MovMap,Xbin,Ybin,cmperbin,goodepochs,toplot)

if (nargin < 8)
    toplot = 0;
end

NumShuffles = 500;

% count the number of cell activations and their sizes

NumAct = 0;
ActLengths = [];

for i = 1:size(goodepochs,1)
    estart = goodepochs(i,1);
    eend = goodepochs(i,2);
    tempact = NP_FindSupraThresholdEpochs(Trace(estart:eend),0.01,0);
    if(isempty(tempact) ~= 1)
        NumAct = NumAct + size(tempact,1);
        ActLengths = [ActLengths;((tempact(:,2)-tempact(:,1))+1)];
    end
end

placemap = calcmapdec(Trace,MovMap,Xbin,Ybin,isrunning);
ExperimentalH = DaveEntropy(placemap)

runlengths = goodepochs(:,2)-goodepochs(:,1)+1;
runused = zeros(size(runlengths));

parfor i = 1:NumShuffles
    
    shufftrace = zeros(size(Trace));
    for j = 1:NumAct
        % randomly pick a running epoch to assign to
        diditgood = 0;
        while (diditgood == 0)
            randrun = ceil(rand*size(goodepochs,1));
            rs = goodepochs(randrun,1);
            re = goodepochs(randrun,2);
            
            if (runlengths(randrun) > ActLengths(j))
                % this Activation *might* fit 
                maxoffset = runlengths(randrun) - ActLengths(j);
                % pick a place within the run to put the activation
                randoffset = floor(rand*(maxoffset+1));
                temp = shufftrace(rs:re);
                temp(1+randoffset:1+randoffset+ActLengths(j)-1) = temp(1+randoffset:1+randoffset+ActLengths(j)-1)+1;
                if (max(temp) < 2)
                    % this Activation doesn't overlap with another we've
                    % laid down
                    diditgood = 1;
                    shufftrace(rs+randoffset:rs+randoffset+ActLengths(j)-1) = 1;
                end
            end

            
        end
    end
    
    tempplacemap = calcmapdec(shufftrace,MovMap,Xbin,Ybin,isrunning);
    ShuffH(i) = DaveEntropy(tempplacemap);
    %figure(999);plot(Trace);hold on;plot(shufftrace,'-r');hold off;pause;
end

pval = length(find(ShuffH > ExperimentalH))./NumShuffles;


        




    
    
    
    





