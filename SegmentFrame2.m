function [frame,cc,thresh] = SegmentFrame(frame,toplot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    toplot = 0;
end

minpixels = 40;

inframe = frame;

x = 3;
if (toplot) figure;subplot(1,x,1);imagesc(frame); title ('raw input');colormap(gray);end

frame = imopen(frame,strel('disk',2));
smf = frame;

if (toplot) subplot(1,x,2);imagesc(frame); title ('smoothed input');colormap(gray);end

thresh = 4*std(frame(:))
frame = frame > thresh;

frame = bwareaopen(frame,minpixels,8);

if (toplot) subplot(1,x,3);imagesc(frame); title('small guys removed');
subplot(1,x,3);
end

cc = bwconncomp(frame,8);
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

