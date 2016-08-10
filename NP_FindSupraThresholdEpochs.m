function Epochs = NP_FindSupraThresholdEpochs(x,InThresh,omitends)
% Epochs = NP_FindSupraThresholdEpochs(x,InThresh,omitends)
%
% Finds epochs where consecutive values of x are above InThresh.
%
% INPUTS:
%   x: one-dimensional array of values you wish to evaluate
%
%   InThresh: threhold for x
%
%   omitends: if x starts or ends in an epoch, omit these as valid
%
%
% OUTPUTS:
%
%   Epochs: a num_epochs x 2 array with the start and end indices for each
%   epoch.
%
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
% 
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin < 3)
    omitends = 1;
end

OverInThresh = (x > InThresh);
% InEpoch = 0;
% NumEpochs = 0;

% ThreshEpochs= [];
% 
% for i = 1:length(x)
%   if((OverInThresh(i) == 0) && (InEpoch == 1))
%      ThreshEpochs(NumEpochs,2) = i-1;
%      InEpoch = 0;
%      continue;
%    end
% 
%   if((OverInThresh(i) == 1) && (InEpoch == 0))
%     % New Epoch
%     NumEpochs = NumEpochs + 1;
%     ThreshEpochs(NumEpochs,1) = i;
%     InEpoch = 1;
%     continue;
%   end
% end

% Simplistic and faster way to do the above. 
deltaOverInThresh = diff(OverInThresh);
onsets = find(deltaOverInThresh==1);
offsets = find(deltaOverInThresh==-1);
NumEpochs = size(onsets,2);
ThreshEpochs(:,1) = onsets + 1;
if size(offsets,2) == NumEpochs; 
    ThreshEpochs(:,2) = offsets;
else    %Handles the case for when the trace is still active when the recording cuts off. 
    ThreshEpochs(1:size(offsets,2),2) = offsets;
    ThreshEpochs(end,2) = length(x);
end

% if(OverInThresh(end) == 1)
%     ThreshEpochs(NumEpochs,2) = length(x);
% end

if (omitends == 1)
    if (OverInThresh(end))
      %Still in an epoch at the end, omit it
      NumEpochs = NumEpochs - 1;
      ThreshEpochs = ThreshEpochs(1:NumEpochs,:);
    end

    if (OverInThresh(1))
      NumEpochs = NumEpochs-1;
      ThreshEpochs = ThreshEpochs(2:NumEpochs+1,:);
    end
end

Epochs = ThreshEpochs;

end