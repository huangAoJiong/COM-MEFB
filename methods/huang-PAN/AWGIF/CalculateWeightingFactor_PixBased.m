function [C]=CalculateWeightingFactor_PixBased(inY)
% inY: guidance image, must be a gray-scale image
[height, width] = size(inY);
rho = 1;
N = boxfilter(ones(height, width), rho);
mean_I = boxfilter(inY, rho) ./ N;
mean_II = boxfilter(inY.*inY, rho) ./ N;
clear N;
C = mean_II -mean_I.*mean_I+1;
temp = mean(mean(1.0./C));
C = C.*temp;
clear mean_I;
clear mean_II;



