function [] = AnalyzeFTraces()

close all;

load FinalTraces.mat; % load the saved traces
yOut = y;
xOut = x;

Flength = size(FT,2);
NumCells = size(FT,1);

Tlen = [];
Tlend1= [];

for i = 1:NumCells
  if (sum(FT(i,:)) == 0)
      continue;
  end
  
  temp = FT(i,:)/max(FT(i,:));
  dtemp = diff(temp);
  %plot((1:Flength-1)/20,dtemp);pause
  a = NP_FindSupraThresholdEpochs(temp,0.05);
  len = (a(:,2)-a(:,1))/20;
  Tlen = [Tlen;len];
  
  a = NP_FindSupraThresholdEpochs(dtemp,0.01);
  len = (a(:,2)-a(:,1))/20;
  Tlend1 = [Tlend1;len];
end

keyboard;