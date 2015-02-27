% Author: Michael J. Bommarito II
% Contact: michael.bommarito@gmail.com
% Date: Oct 3, 2010
% Provided as-is, informational purposes only, public domain.
%
% Inputs:
%   1. dataMatrix: variables (X1,X2,...,X_M) in the columns
%   2. windowSize: number of samples to include in the moving window
%   3. indexColumn: the variable X_i against which correlations should be 
% returned
%
% Output:
%   1. correlationTS: correlation between X_{indexColumn} and X_j for j !=
% indexColumn from windowSize+1 to the number of observations.  The first
% windowSize rows are NaN.
 
function correlationTS = movingCorrelation(dataMatrix, windowSize, indexColumn)
 
[N,M] = size(dataMatrix);
correlationTS = nan(N, M-1);
 
for t = windowSize+1:N
    C = corrcoef(dataMatrix(t-windowSize:t, :));
    idx = setdiff(1:M, [indexColumn]);
    correlationTS(t, :) = C(indexColumn, idx);
end