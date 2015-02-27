function [ output_args ] = SegmentCheck(SignalTrace,t,RawIC,x,y,num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i = num:num
   while(1 == 1)
   s = subplot(2,2,1:2),plot(t,SignalTrace(i,:));i,
   [a,b] = getpts(s)
   idx = round(a(1))*20;
   temp = h5read('FLmovie.h5','/Object',[1 1 idx 1],[508 569 1 1]);
   subplot(2,2,3);imagesc(temp);caxis([0 0.2]);hold on;plot(x{i},y{i});hold off;
   subplot(2,2,4);imagesc(RawIC{i});
   
   
   pause;
   end
end
   
end

