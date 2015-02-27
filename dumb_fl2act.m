function [spiketrains] = dumb_fl2act(FT,d1thresh,minlen)
% my SUPER dumbed-down, low brow version of oopsi

% d1thresh should eb 0.01
% minlen should be 0.5;

Flength = size(FT,2);
NumCells = size(FT,1);

Tlen = [];
Tlend1= [];

spiketrains = zeros(size(FT));

for i = 1:NumCells
  
  if (sum(FT(i,:)) == 0)
      % no fluorescence, no spiking
      continue;
  end
  
  temp = FT(i,:)/max(FT(i,:)); % normalize so max is 1
  dtemp = diff(temp); % take 1st deriviative
  
  a = NP_FindSupraThresholdEpochs(dtemp,d1thresh); % find epochs where the 1st deriv was over threshold
  
  if (isempty(a))
      continue;
  end
  
  len = (a(:,2)-a(:,1))/20; % calculate the lengths in seconds of these epochs
  
  goodlen = find(len >= minlen) % find epochs longer than the minimum length
  a = a(goodlen,:); % edit the epochs for the sufficiently long ones
  
  for j = 1:size(a,1)
      % just assign spiketrain to 1 inside each of the epochs
      spiketrains(i,a(j,1):a(j,2)) = 1;
  end
end