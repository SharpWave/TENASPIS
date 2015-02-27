function [ output_args ] = RealityCheck()
% interactive function for visually determining whether FLmovie's IC's are cells or
% not.  Outputs a .mat file that contains 3 binary vectors for the status
% of the cell: bingo, sketchy, garbage


load FinalTraces.mat; % FT NumICA IC ICnz x y t c NumFrames

Xdim = size(IC{1},1);
Ydim = size(IC{1},2);
SP = poopsi(FT,0.01,0.5);

datafig = 555;
moviescratch = 666;
bingo = zeros(NumICA,1);
garbage = zeros(NumICA,1);
sketchy = zeros(NumICA,1);

for i = 1:NumICA
    laplist{i} = [];
    for j = 1:NumICA
        temp = intersect(ICnz{i},ICnz{j});
        if (i~=j && length(temp) > 0)
            laplist{i} = [laplist{i},j];
        end
    end
end

for i = 1:NumICA
  activations = NP_FindSupraThresholdEpochs(SP(i,:),0.01,0);
  NumActs(i) = size(activations,1);
end

hist(NumActs);keyboard;

for i = 1:NumICA
    close all
    i
    figure(datafig);
    subplot(3,2,1);imagesc(IC{i});title(num2str(length(ICnz{i}(:))));
    temp = zeros(size(IC{1}));
    temp(ICnz{i}) = 1;
    subplot(3,2,2);imagesc(temp);
    subplot(3,2,3:4);plot(t,FT(i,:));axis tight;
    subplot(3,2,5:6);plot(t,SP(i,:));axis tight
    
    activations = NP_FindSupraThresholdEpochs(SP(i,:),0.01,0);
    if (isempty(activations) == 0)
        curr = 1;
        figure(moviescratch);
        if (exist('F','var'))
            clear F;
        end
        %vidObj = VideoWriter('temp.avi');open(vidObj);
        for j = 1:size(activations,1)
            frames = activations(j,1):2:(activations(j,2)+60);
            for k = frames
                if (k <= size(FT,2))
                    tempFrame = h5read('Cmovie.h5','/Object',[1 1 k 1],[Xdim Ydim 1 1]);
                end
                imagesc(tempFrame);set(gca,'YDir','normal');hold on;plot(x{i},y{i},'-r');colormap(gray);title(int2str(j));caxis([-4 4]);max(tempFrame(:));
                for m = 1:length(laplist{i})
                    plot(x{laplist{i}(m)},y{laplist{i}(m)},'g');
                end
                pause(0.01);
                F(curr) = getframe(gcf);curr = curr+1;hold off;
            end
            for k = 1:10
                tempFrame = zeros(size(IC{1}));
                imagesc(tempFrame);set(gca,'YDir','normal');hold on;plot(x{i},y{i},'-r');
                pause(0.01);
                F(curr) = getframe(gcf);curr = curr+1;hold off;%writeVideo(vidObj,getframe(gcf));  
            end
        end
    end
    if (exist('F','var'))
      implay(F,10);close(666);
    end
    ratestring = [];
    while(strcmp(ratestring,'b') ~= 1 && strcmp(ratestring,'s') ~= 1 && strcmp(ratestring,'g') ~= 1)
      ratestring = input('[b]ingo, [s]ketchy, or [g]arbage? --->','s');
    end
    if strcmp(ratestring,'b')
        bingo(i) = 1;
    end
    if strcmp(ratestring,'g')
        garbage(i) = 1;
    end
    if strcmp(ratestring,'s')
        sketchy(i) = 1;
    end
    

end
save RC.mat bingo garbage sketchy
keyboard;

