function [bw,cc] = SegmentFrame(frame,toplot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    toplot = 0;
end

inframe = frame;

x = 3;

frame = imopen(frame,strel('disk',5));

if (toplot) figure;subplot(x,x,1);imagesc(frame); title ('input');end

bg = imopen(frame,strel('disk',15,8));

if (toplot) subplot(x,x,2);imagesc(bg); title('background');end

frame = frame-bg;

if (toplot) subplot(x,x,3);imagesc(frame); title('background sub');end

frame = imadjust(frame);

if (toplot) subplot(x,x,4);imagesc(frame); title('imadjust');end

level = graythresh(frame)
bw = im2bw(frame,level);


if (toplot) subplot(x,x,5);imagesc(bw); title('im2bw');end


bw = bwareaopen(bw,100,8);

if (toplot) subplot(x,x,6);imagesc(bw); title('small guys removed');end

cc = bwconncomp(bw,8);
labeled = labelmatrix(cc);
rgb_label = label2rgb(labeled,@spring,'c','shuffle');

colormap gray;

if (toplot)
    figure;imshow(rgb_label);
end

