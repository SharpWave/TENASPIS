function [ refpoints ] = get_closestCOM( xyvec,COM )
%get_closestCOM Get closest COMs of cells to use
% INPUTS
% xyvec:    n x 2 vector of points with xvalues in column 1 and y values in column 2
% COM:      1 x k cell of 1 x 2 vectors , NOTE: [ yCOM xCOM] because MATLAB
%           is dumb like that
% OUTPUTS
% refpoints: centers of mass of selected cells, NOTE: [xCOM yCOM}

xvec_use = [xyvec(:,2) xyvec(:,1)]; % Swap x and y input values to make up for MATLAB bug
refpoints = zeros(size(xvec_use));
for j = 1: size(xvec_use,1)
    temp = cellfun(@(a) sqrt((xvec_use(j,:)-a)*(xvec_use(j,:)-a)'), COM);
    refpoints(j,1) = COM{find(min(temp) == temp)}(2);
    refpoints(j,2) = COM{find(min(temp) == temp)}(1);
end

end

