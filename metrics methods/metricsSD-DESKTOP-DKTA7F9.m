% The source code is from the Internet
% The interface is modified by the author of MEFB to integrate it into MEFB. 
%
% Reference for the metric:
% Y.-J. Rao, ?¡ãIn-fibre bragg grating sensors,?¡À Measurement science and technology, vol. 8, no. 4, p. 355, 1997.

function res  = metricsSD(I,fused)
    
if strcmp(class(fused),'double')
    fused = uint8(fused*255);
end
    [m,n,b] = size(fused); 
    if b == 1
        [a,g] = Variance(I,fused);
        img_var = g;

    else
        for k = 1 : b 
           [a,g(k)] = Variance(I,fused(:,:,k)); 
        end 
        img_var = mean(g); 
    end
    res = img_var;
end

function [img_mean,img_var] = Variance(I,fused)
    if size(fused,3) > 1 
        fused=rgb2gray(fused);  
    end
    fused = double(fused); 
    [r, c] = size(fused); 

    % Mean value 
    img_mean = mean(mean(fused)); 

    % Variance  ·½²î
    img_var = sqrt(sum(sum((fused - img_mean).^2)) / (r * c ));
end