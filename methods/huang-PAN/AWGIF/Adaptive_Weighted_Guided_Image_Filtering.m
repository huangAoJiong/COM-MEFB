function [q,phi] = Adaptive_Weighted_Guided_Image_Filtering(I, p, r, eps, C)
    %   GUIDEDFILTER   O(1) time implementation of guided filter.
    %
    %   - guidance image: I (should be a gray-scale/single channel image)
    %   - filtering input image: p (should be a gray-scale/single channel image)
    %   - local window radius: r
    %   - regularization parameter: eps

    eta =1/6; 
    [hei, wid] = size(I);
    N = boxfilter(ones(hei, wid), r); % the size of each local patch.

    mean_I = boxfilter(I, r) ./ N;
    mean_p = boxfilter(p, r) ./ N;
    mean_Ip = boxfilter(I.*p, r) ./ N;
    cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

    clear mean_Ip;

    mean_II = boxfilter(I.*I, r) ./ N;
    var_II = mean_II - mean_I .* mean_I;

    clear mean_II;

    a = cov_Ip./(var_II+eps.*(mean2(var_II).^0.5)./C);
    b = mean_p-a.*mean_I;

    clear mean_I;

    mean_pp = boxfilter(p.*p, r) ./ N;

    var_pp = mean_pp-mean_p.*mean_p;

    clear mean_p;
    clear mean_pp;

    e = a.^2.*var_II-2.*a.*cov_Ip+var_pp;

    clear var_pp;
    clear cov_Ip;
    clear var_I;

    gamma = exp(-e./(256.* eta))+ 0.001; 

    sum_a = boxfilter(a.*gamma, r);
    sum_gamma = boxfilter(gamma, r);
    clear a;
    sum_b = boxfilter(b.*gamma, r);
    clear b;
    clear gamma;
    
    mean_a = sum_a./sum_gamma;
    phi = mean_a;
    q = (sum_a .* I + sum_b)./sum_gamma; 

    clear sum_a;
    clear sum_b;
    clear sum_gamma;
end



