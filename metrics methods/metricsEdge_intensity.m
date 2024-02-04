% The source code is from the Internet
% The interface is modified by the author of MEFB to integrate it into MEFB. 
%
% Reference for the metric:
% B. Rajalingam and R. Priya, ?°„Hybrid multimodality medical image fusion technique for feature enhancement in 
% medical diagnosis,?°¿ International Journal of Engineering Science Invention, 2018.

function res= metricsEdge_intensity(I,fused)
 
    fused = double(fused); 

    w = fspecial('sobel'); 

    [r,c,k] = size(fused); 
     
    gx = imfilter(fused,w,'replicate'); 
    gy = imfilter(fused,w','replicate'); 
     
    for m = 1 : r 
        for n = 1 : c 
            for q = 1 : k 
                g(m,n,q) = sqrt(gx(m,n,q)*gx(m,n,q) + gy(m,n,q)*gy(m,n,q)); 
            end 
        end 
    end 
    res = mean(mean(mean(g))); 
end 