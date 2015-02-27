function [c] = convtrim(a,b)
% CONVTRIM trimmed convolution
% c = convtrim(a,b) convolves vectors A and B. The resulting
% vector is length LENGTH(a)
% 
% this function is a wrapper for conv - the only difference is the trimming



if (length(a) <= length(b))
  error('convtrim: the length of vector a must be larger than vector b');
end
  
tempC = conv(a,b);
FrontTrim = floor(length(b)/2);

if (mod(length(b),2) ~= 0)
  BackTrim = floor(length(b)/2);
else
  BackTrim = floor(length(b)/2)-1;
end

c = tempC(FrontTrim+1:end-BackTrim);




