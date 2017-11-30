function [p] = PlotRegionOutline(inmat,Color)
% plot the outlines of the suprathreshold regions in the binarized matrix

if((size(inmat,1) == 1) || (size(inmat,2) == 1))
    % it's an index vector
    [Xdim,Ydim] = Get_T_Params('Xdim','Ydim');
    PixelIdx = inmat;
    inmat = zeros(Xdim,Ydim,'single');
    inmat(PixelIdx) = 1;
end

b = bwboundaries(inmat,'noholes'); % Get cluster boundary
for i = 1:length(b)
    x{i} = b{i}(:,1);
    x{i} = x{i}+(rand(size(x{i}))-0.5)/2;
    y{i} = b{i}(:,2);
    y{i} = y{i}+(rand(size(y{i}))-0.5)/2;
    if(nargin == 1)
        p{i} = plot(y{i},x{i},'LineWidth',2);hold on;
    else
        p{i} = plot(y{i},x{i},'LineWidth',2,'Color',Color);hold on;
    end
end

