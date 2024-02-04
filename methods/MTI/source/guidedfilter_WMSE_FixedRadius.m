function [q, mean_a, mean_b] = guidedfilter_WMSE_FixedRadius(I, p, r, eps)
%   GUIDEDFILTER   O(1) time implementation of guided filter.
%
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps


[hei, wid] = size(I);
N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.
mean_I = boxfilter(I, r)./N;
mean_p = boxfilter(p, r)./N;
mean_Ip = boxfilter(I.*p, r)./N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.
clear mean_Ip;
mean_II = boxfilter(I.*I, r)./N;
var_I = mean_II - mean_I .* mean_I;
W = var_I.*var_I;
W_mean = mean(mean(W));
clear mean_II;
a = cov_Ip.*W./(var_I.*W+eps*W_mean);
clear cov_Ip;
clear var_I;
%a = cov_Ip./(var_I+N.*eps);
b = mean_p-a.*mean_I;
clear mean_p;
clear mean_I;
mean_a = boxfilter(a, r)./N;
clear a;
mean_b = boxfilter(b, r)./N;
clear b;
q = mean_a .* I + mean_b;
clear mean_a;
clear mean_b;
clear N;
end
