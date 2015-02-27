function [ pval ] = StrapIt(Trace,MovMap,Xbin,Ybin,cmperbin,goodepochs,isrunning,toplot)
% function [ pval ] = StrapIt(Trace,MovMap,Xbin,Ybin,cmperbin,goodepochs,toplot)

if (nargin < 8)
    toplot = 0;
end

NumShuffles = 1000;

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

maxplace = max(placemap(:));

runlengths = goodepochs(:,2)-goodepochs(:,1)+1;
runused = zeros(size(runlengths));

for i = 1:NumShuffles
    i
    shufftrace = zeros(size(Trace));
    for j = 1:NumAct
        % randomly pick a running epoch to assign to
        diditgood = 0;
        while (diditgood == 0)
            randrun = ceil(rand*size(goodepochs,1));
            rs = goodepochs(randrun,1);
            re = goodepochs(randrun,2);
            if (runlengths(randrun) > ActLengths(j))
                maxoffset = runlengths(randrun) - ActLengths(j);
                randoffset = ceil(rand*maxoffset);
            else
                continue;
            end
            
%             if (sum(shufftrace(rs+randoffset:rs+randoffset+ActLengths(j))) == 0)
%                 shufftrace(rs+randoffset:rs+randoffset+ActLengths(j)) = 1;
%                 diditgood = 1;
%             end
           
                shufftrace(rs+randoffset:rs+randoffset+ActLengths(j)) = 1;
                diditgood = 1;
            
        end
    end
    tempplacemap = calcmapdec(shufftrace,MovMap,Xbin,Ybin,isrunning);
    shuffmax(i) = max(tempplacemap(:));
    %figure(999);plot(Trace);hold on;plot(shufftrace,'-r');hold off;pause;
end

pval = length(find(shuffmax > maxplace))/NumShuffles;


        




    
    
    
    





