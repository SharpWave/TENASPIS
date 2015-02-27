function [ICThresh,IC,NumICA,x,y] = EditICA(NumICA,MinThreshPixels)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if (nargin == 1)
  MinThreshPixels = 60;
end

try
    % Don't do this if we've done it before
    load ICAoutlines.mat
catch
    
    % load the ICs
    for i = 1:NumICA % load the ICA .mat file, put it in a data structure
        filename = ['Obj_',int2str(i),'_1 - IC filter ',int2str(i),'.mat'];
        load(filename); % loads two things, Index and Object
        IC{i} = Object(1).Data;
    end
    
    OG_IC = IC;
    
    toContinue = 1;
    GoodICAbin = ones(1,NumICA);
    while (toContinue ~= 0)
        % plot all the ICs
        close all;
        Curr = 1;
        WinCurr = 1;
        while (Curr <= NumICA)
            if (mod(Curr,49) == 1)
                figure;
                WinCurr = 1;
            end
            
            subplot(7,7,WinCurr);imagesc(IC{Curr});title(int2str(Curr));
            Curr = Curr+1;
            WinCurr = WinCurr +1;
        end
        
        % ask the user if any are screwy
        toEdit = input('Do any of these IC look like non-cells? [y/n]','s');
        if (strcmp(toEdit,'y') == 1)
            toDelete = '0';
            while (strcmp(toDelete,'n') == 0)
                toDelete = input('Gimme the # of the one to delete, or n to redraw -->','s');
                if (strcmp(toDelete,'n') == 0)
                    DeleteNum = str2num(toDelete);
                    GoodICAbin(DeleteNum) = 0;
                   
                end
            end
            IC = IC(find(GoodICAbin == 1));
            NumICA = length(IC);
            GoodICAbin = ones(1,NumICA);
        else
            % none are screwy
            toContinue = 0;
        end
    end
    
    
    
    for i = 1:NumICA
        [ICThresh(i),x{i},y{i}] = NumContourPeaks(IC{i},100);
    end
    
    for i = 1:NumICA
        l(i) = length(find(IC{i} > ICThresh(i)));
    end
    figure;hist(l,40);xlabel('# pixels in IC');ylabel('# ICs');
    LengthGoodidx = find(l > MinThreshPixels);
    
    IC = IC(LengthGoodidx);
    x = x(LengthGoodidx);
    y = y(LengthGoodidx);
    ICThresh = ICThresh(LengthGoodidx);
    
    NumICA = length(IC);
    
    
    save ICAoutlines.mat IC ICThresh x y NumICA OG_IC;
end



end

