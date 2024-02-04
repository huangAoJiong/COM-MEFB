% The source code is from https://github.com/zhengliu6699/imageFusionMetrics/blob/master/metricChen.m
% The interface is modified by the author of MEFB to integrate it into MEFB. 
% 
% Reference for the metric
% H. Chen and P. K. Varshney, “A human perception inspired quality metric for image fusion based on regional 
% information,” Information fusion, vol. 8, no. 2, pp. 193–207, 2007.

function res=metricsSpatial_frequency(I, fused)

    % Get the size of img 
    [m,n,b] = size(fused); 
    [m1,n1,~,b1] = size(I);

    %如果加载的图像序列是单通道，但是加载的融合图像是三通道的，那马改变融合图像为单通道
    if (b1 == 1)  && (b == 3)
        fused_new = zeros(m,n);
        fused_new = fused(:,:,1);
        fused = fused_new;
    end
% 如果加载的融合图像是单通道
    if b == 1
        g = Spatial_frequency(fused);
        res = g;
    elseif b1 == 1
        for k = 1 : b 
           g(k) = Spatial_frequency(fused(:,:,k)); 
        end 
        res = mean(g); 
    else
        for k = 1 : b 
            g(k) = Spatial_frequency(fused(:,:,k)); 
        end 
        res = mean(g); 
    end


end
 
function output = Spatial_frequency(fused)

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
