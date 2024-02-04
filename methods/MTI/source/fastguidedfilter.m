function [q, mean_a, mean_b] = fastguidedfilter(I, p, r, eps, s)
%   GUIDEDFILTER   O(1) time implementation of guided filter.
%
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps
%   - subsampling ratio: s

I1 = imresize(I, 1/s);
p1 = imresize(p, 1/s);
r1 = floor(r/s);

[hei, wid] = size(I1);
N = boxfilter(ones(hei, wid), r1); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = boxfilter(I1, r1) ./ N;
mean_p = boxfilter(p1, r1) ./ N;
mean_Ip = boxfilter(I1.*p1, r1) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I1, p1) in each local patch.

mean_II = boxfilter(I1.*I1, r1) ./ N;
var_I = mean_II - mean_I .* mean_I;

a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a1 = boxfilter(a, r1) ./ N;
mean_b1 = boxfilter(b, r1) ./ N;

mean_a = imresize(mean_a1, size(I), 'bilinear');
mean_b = imresize(mean_b1, size(I), 'bilinear');

q = mean_a .* I + mean_b; % Eqn. (8) in the paper;
end