% The source code is from the Internet
% The interface is modified by the author of MEFB to integrate it into MEFB. 
%
% Reference for the metric:
% P. Jagalingam and A. V. Hegde, ?¡ãA review of quality metrics for fused image,?¡À Aquatic Procedia, vol. 4, 
% no. Icwrcoe, pp. 133¡§C142, 2015.

function res = metricsPsnr(I0,fused)
   if length(size(I0)) == 4
       I=I_rgb2gray(I0);
   else
       I=I0;
   end
   if length(size(fused)) == 3
       fused = rgb2gray(fused);
   end
   
   g = Psnr(I,fused);
   res = g;

end


function PSNR = Psnr(I,fused)

    N = size(I,3);
    fused = double(fused);

    B=8;                
    MAX=2^B-1;   
    MES = 0;
    for n=1:N
        MES = MES + mse(I(:,:,n), fused);
    end
    MES = MES/double(N);
    PSNR=20*log10(MAX/sqrt(MES));
end

function res0 = mse(a, b)
    if size(a,3) > 1
        a = rgb2gray(a);  
    end

    if size(b,3) > 1
        b = rgb2gray(b); 
    end

    [m, n]=size(a);
    temp=sqrt(sum(sum((a-b).^2)));
    res0=temp/(m*n);
end
