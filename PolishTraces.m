function [PT] = PolishTraces(ST,NT )
%[PT] = PolishTraces(ST,NT )
% Subtracts noise from signal, zeros out everything less than zero, smooths

NumTraces = size(ST,1);

for i = 1:NumTraces
    ST(i,:) = convtrim(ST(i,:),ones(20,1))./20; % smooth signal
    NT(i,:) = convtrim(NT(i,:),ones(20,1))./20; % smooth noise
    
    PT(i,:) = ST(i,:)-NT(i,:); % subtract noise from signal
    
    PT(i,find(PT(i,:) <= 0)) = 0; % zero out everything less than zero
end

% correct short gaps
PT = UnfuckTraces(PT,100);

% final smoothing
for i = 1:NumTraces
    PT(i,:) = convtrim(PT(i,:),ones(20,1))./20;
end





