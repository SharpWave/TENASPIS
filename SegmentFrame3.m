function [frame,cc,thresh,realthresh,smf] = SegmentFrame3(frame,toplot,pthresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    toplot = 0;
end
radius = 10;

psf = fspecial('gaussian',radius,radius);

minpixels = 9;

inframe = frame;

x = 3;
if (toplot) figure;subplot(1,x,1);imagesc(frame); title ('raw input');colormap(gray);end

%frame = imopen(frame,strel('disk',2));
%frame = edgetaper(frame,psf);
%frame = deconvlucy(frame,psf,5);
smf = frame;

if (toplot) subplot(1,x,2);imagesc(frame); title ('smoothed input');colormap(gray);end

thresh = 5*std(frame(:))+mean(frame(:));
realthresh = 0.2*thresh+0.8*pthresh;

frame = frame > 4;

frame = bwareaopen(frame,minpixels,4);

if (toplot) subplot(1,x,3);imagesc(frame); title('small guys removed');
subplot(1,x,3);
end

cc = bwconncomp(frame,4);
labeled = labelmatrix(cc);
rgb_label = label2rgb(labeled,@spring,'c','shuffle');

colormap gray;
if (toplot)
    figure;
    hist(smf(:),100);title(num2str(thresh));
end

if (toplot)
    figure;imshow(rgb_label);
end

