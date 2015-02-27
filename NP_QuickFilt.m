function[FiltSig] = NP_QuickFilt(sig,low,high,sr)
% [FiltSig] = NP_QuickFilt(sig,low,high,sr)

forder = 4000;  % filter order has to be even; .. the longer the more
               % selective, but the operation will be linearly slower
    	       % to the filter order

forder = ceil(forder/2)*2;           %make sure filter order is even

firfiltb = fir1(forder,[low/sr*2,high/sr*2]);
FiltSig = filtfilt(firfiltb,1,sig);