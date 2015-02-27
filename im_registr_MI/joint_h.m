function h=joint_h(image_1,image_2)
% function h=joint_h(image_1,image_2)
%
% takes a pair of images of equal size and returns the 2d joint histogram.
% used for MI calculation
% 
% written by http://www.flash.net/~strider2/matlab.htm


rows=size(image_1,1);
cols=size(image_1,2);
N=256;

h=zeros(N,N);

for i=1:rows;    %  col 
  for j=1:cols;   %   rows
    h(image_1(i,j)+1,image_2(i,j)+1)= h(image_1(i,j)+1,image_2(i,j)+1)+1;
  end
end