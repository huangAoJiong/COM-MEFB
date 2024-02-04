% The source code is from https://github.com/zhengliu6699/imageFusionMetrics/blob/master/metricChen.m
% The interface is modified by the author of MEFB to integrate it into MEFB. 
% 
% Reference for the metric
% H. Chen and P. K. Varshney, ¡°A human perception inspired quality metric for image fusion based on regional 
% information,¡± Information fusion, vol. 8, no. 2, pp. 193¨C207, 2007.

function res=metricsSpatial_frequency(I, fused)

if strcmp(class(fused),'double')
    fused = uint8(fused*255);
end
    % Get the size of img 
    [m,n,b] = size(fused); 
    
    if b == 1
        g = Spatial_frequency(fused);
        res = g;
    else
        for k = 1 : b 
            g(k) = Spatial_frequency(fused(:,:,k)); 
        end 
        res = mean(g); 
    end


end
 
function output = Spatial_frequency( fused)

    fused=double(fused);
    [m,n]=size(fused);
    RF=0;
    CF=0;

    for fi=1:m
        for fj=2:n
            RF=RF+(fused(fi,fj)-fused(fi,fj-1)).^2;
        end
    end

    RF=RF/(m*n);

    for fj=1:n
        for fi=2:m
            CF=CF+(fused(fi,fj)-fused(fi-1,fj)).^2;
        end
    end

    CF=CF/(m*n);

    output=sqrt(RF+CF);
end
