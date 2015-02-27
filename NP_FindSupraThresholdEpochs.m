function[Epochs] = NP_FindSupraThresholdEpochs(x,InThresh,omitends)
% NP_FindSupraThresholdEpochs(x,InThresh,minsamples)

if (nargin < 3)
    omitends = 1;
end

OverInThresh = (x > InThresh);
InEpoch = 0;
NumEpochs = 0;

ThreshEpochs = [];

for i = 1:length(x)
  if((OverInThresh(i) == 0) && (InEpoch == 1))
     ThreshEpochs(NumEpochs,2) = i-1;
     InEpoch = 0;
     continue;
   end

  if((OverInThresh(i) == 1) && (InEpoch == 0))
    % New Epoch
    NumEpochs = NumEpochs + 1;
    ThreshEpochs(NumEpochs,1) = i;
    InEpoch = 1;
    continue;
  end
end

if(OverInThresh(end) == 1)
    ThreshEpochs(NumEpochs,2) = length(x);
end

if (omitends == 1)
    if (OverInThresh(end) == 1)
      %Still in an epoch at the end, omit it
      NumEpochs = NumEpochs - 1;
      ThreshEpochs = ThreshEpochs(1:NumEpochs,:);
    end

    if (OverInThresh(1) == 1)
      NumEpochs = NumEpochs-1;
      ThreshEpochs = ThreshEpochs(2:NumEpochs+1,:);
    end
end

Epochs = ThreshEpochs;




    


    
    
    