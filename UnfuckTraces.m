function [ Traces] = UnfuckTraces(Traces,maxskip,nominval)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 3)
    nominval = 0;
end

for i = 1:size(Traces,1)
    % remove periods of zeros up to maxskip in length and interpolate
    Activity = 0;
    NumSince = 9999999;
    LastActive = 0;
    Curr = 1;
    
    while (Curr <= size(Traces,2))
        if (Traces(i,Curr) > 0)
            if (Activity == 1)
                % was active, still active
                LastActive = Curr;
            else
                
                % wasn't active, now active
                if (NumSince <= maxskip)
                  Activity = 1;
                  
                  %do interpolation thing
                  interpinc = (Traces(i,Curr)-Traces(i,LastActive))/(Curr-LastActive);
                  for j = LastActive+1:Curr-1
                      Traces(i,j) = Traces(i,j-1)+interpinc;
                  end
                  LastActive = Curr;
                  
                else
                  Activity = 1;
                  LastActive = Curr;
                end
            end
        end
        
        if (Traces(i,Curr) == 0)
            if (Activity == 1)
                % was active, not anymore
                Activity = 0;
                NumSince = 1;
            else
                % wasn't active, still not
                NumSince = NumSince + 1;
            end
        end
        Curr = Curr + 1;
    end
                
nonzeros = find(Traces(i,:) > 0);
minval = min(Traces(i,nonzeros));
if (~isempty(minval))
    if (nominval ~= 1)
Traces(i,:) = Traces(i,:)-minval;
    end
unnonzeros = find(Traces(i,:) < 0);
Traces(i,unnonzeros) = 0;


end
end

