function [h,im_matched, theta,I,J]=image_registr_MI(image1, image2, angle, step,crop);
% function [h,im_matched, theta,I,J]=image_registr_MI(image1, image2, angle, step,crop);
%
% Function for registering image 1 and image 2 using Mutual Information
% Image processing toolbox is required for functions IMROTATE and IMCROP
% For users without IP toolbox download file im_reg_mi.m without
% cropping option and with different rotation function
%
% Mutual Information files are taken from:
% http://www.flash.net/~strider2/matlab.htm
%
% Rigid registration - only translation and rotation are corrected
% For each angle of rotation set of translation is checked
% Can use only for translation by setting angle=0
%
% INPUT:
% Larger IMAGE2 is registered to smaller IMAGE1
%
% angle - vector of angles to check, for example 
% angle=[-30:2:30] or 
% angle=15;
%
% step - how many pixels to shift in x and y directions for translation check
%
% crop = 0 to eliminate cropping image
% crop=1 to crop the image and save computational time 
% You'll be asked to crop an area out of the original IMAGE2 
% If you have the kowledge of where approximately the matching area is the
% cropping allows you to limit the search to this area and to save
% calculation time.  Otherwise, select crop=0 
%
% OUTPUT:
% im_matched - matched part of image 2
% h - MI for the best theta
% theta - best angle of rotation
% I and J - coordinates of left top corner of matched area within large IMAGE2
%
% MIGHT BE REALLY SLOW FOR A LOT OF ANGLES AND SMALL STEPS!
% TOO LARGE STEPS CAN CAUSE FALSE REGISTRATION
% I RUN IT OVERNIGHT WITH SMALL STEPS TO GET THE BEST POSSIBLE MATCH
% 
% example:
%
% [h,im_matched, theta,I,J]=image_registr_MI(image1, image2, [-10:5:10], 5, 0);
%
% just translation:
% [h,im_matched, theta,I,J]=image_registr_MI(image1, image2, 0, 1, 1);
%
% written by K.Artyushkova
% 10_2003

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 


a=isa(image1,'uint16');
if a==1
     image1=double(image1)/65535*255;  
 else
     image1=double(image1);
end

a=isa(image2,'uint16');
if a==1
    image2=double(image2)/65535*255;
else
    image2=double(image2);    
end

[m,n]=size(image1);
[p,q]=size(image2); 
[a,b]=size(angle);
im1=round(image1); 
method=questdlg('Which method to use?', 'Type','Normalized','Standard  ','Normalized');

if crop==0
    sub_image2=image2;
else
    % can crop large image to specify the search area
    h = msgbox('Please crop the part of image where to search for the best match');
    uiwait(h)
    figure
    [sub_J,rect_J] = imcrop(uint8(image2));
    sub_image2=double(sub_J); % cropped large IMAGE2
end
   

for k=1:b
    J = imrotate(sub_image2, angle(k),'bilinear'); %rotated cropped IMAGE2
    image21=round(J);
    [m1,n1]=size(image21);
    for i=1:step:(m1-m)
        for j=1:step:(n1-n)
                im2=image21(i:(i+m-1),j:(j+n-1)); % selecting part of IMAGE2 matching the size of IMAHE1
                im2=round(im2); 
                h(k,i,j)=mi2(im1,im2,method); % calculating MI
            end
        end
    end
  

[a, b] = max(h(:));% finding the max of MI and indecises
[K,I,J] = ind2sub(size(h),b);

if crop==0
    I=I;
    J=J;
else
     X=rect_J(1:2);
    I=I+X(2);
    J=J+X(1);

end
  

theta=angle(K);
im_rot = imrotate(image2, theta,'bilinear');
im_matched=im_rot(I:(I+m-1),J:(J+n-1));
H.Position=[232 258 259 402];
figure(H)
subplot(2,1,1)
imagesc(image2)
title('Original image 2')
subplot(2,1,2)
imagesc(im_rot)
title('Rotated image 2')
colormap (gray)
H.Position=[502 258 259 402];
figure(H)
subplot(2,1,1)
imagesc(image1)
title('Original image 1')
subplot(2,1,2)
imagesc(im_matched)
title('Matched image 2')
colormap (gray)