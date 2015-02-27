function h=MI2(image_1,image_2,method)
% function h=MI2(image_1,image_2,method)
%
% Takes a pair of images and returns the mutual information Ixy using joint entropy function JOINT_H.m
% 
% written by http://www.flash.net/~strider2/matlab.htm


a=joint_h(image_1,image_2); % calculating joint histogram for two images
[r,c] = size(a);
b= a./(r*c); % normalized joint histogram
y_marg=sum(b); %sum of the rows of normalized joint histogram
x_marg=sum(b');%sum of columns of normalized joint histogran

Hy=0;
for i=1:c;    %  col
      if( y_marg(i)==0 )
         %do nothing
      else
         Hy = Hy + -(y_marg(i)*(log2(y_marg(i)))); %marginal entropy for image 1
      end
   end
   
Hx=0;
for i=1:r;    %rows
   if( x_marg(i)==0 )
         %do nothing
      else
         Hx = Hx + -(x_marg(i)*(log2(x_marg(i)))); %marginal entropy for image 2
      end   
   end
h_xy = -sum(sum(b.*(log2(b+(b==0))))); % joint entropy

if method=='Normalized';
h = (Hx + Hy)/h_xy;% Mutual information
else
h = Hx + Hy - h_xy;% Mutual information
end

