% The source code is from https://github.com/zhengliu6699/imageFusionMetrics/blob/master/metricChen.m
% The interface is modified by the author of MEFB to integrate it into MEFB. 
% 
% Reference for the metric
% H. Chen and P. K. Varshney, ¡°A human perception inspired quality metric for image fusion based on regional 
% information,¡± Information fusion, vol. 8, no. 2, pp. 193¨C207, 2007.

function res=metricsQcv(I,fused)
if length(size(I))==4
    I = I_rgb2gray(I);
end
if strcmp(class(I),'double')
    I = uint8(I*255);
end
if strcmp(class(fused),'double')
    fused = uint8(fused*255);
end
    % Get the size of img 
    [m,n,b] = size(fused); 

    if b == 1
        g = Qcv(I,fused);
        res = g;
    elseif b1 == 1
        for k = 1 : b 
           g(k) = Qcv(I,fused(:,:,k)); 
        end 
        res = mean(g); 
    else
        for k = 1 : b 
            g(k) = Qcv(I,fused(:,:,k)); 
        end 
        res = mean(g); 
    end
end



function output = Qcv(I, fused)
[r,c,n]=size(I);
im1 = fused;
im2=fused;
   %% set up the constant values

    alpha_c=1;
    alpha_s=0.685;
    f_c=97.3227;
    f_s=12.1653;

    % local window size 16 x 16
    windowSize=16;

    % alpha = 1, 2, 3, 4, 5, 10, 15. This value is adjustable.;-)
    alpha=5;


    %% pre-processing
%     im1 = double(im1);
%     im2 = double(im2);
    fused = double(fused);

%     im1=normalize1(im1);
%     im2=normalize1(im2);
    I=normalize1(I);
    fused=normalize1(fused);

    %% Step 1: extract edge information

    flt1=[-1 0 1 ; -2 0 2 ; -1 0 1];
    flt2=[-1 -2 -1; 0 0 0; 1 2 1];

    % 1) get the map

    fuseX=filter2(flt1,fused,'same');
    fuseY=filter2(flt2,fused,'same');
    fuseG=sqrt(fuseX.*fuseX+fuseY.*fuseY);

    buffer=(fuseX==0);
    buffer=buffer*0.00001;
    fuseX=fuseX+buffer;
    fuseA=atan(fuseY./fuseX);


    for i=1:n
        imgX(:,:,i)=filter2(flt1,I(:,:,i),'same');
        imgY(:,:,i)=filter2(flt2,I(:,:,i),'same');
        imG(:,:,i)=sqrt(imgX(:,:,i).*imgX(:,:,i)+imgY(:,:,i).*imgY(:,:,i));
    end
    for i=1:n
        buffer(:,:,i)=(imgX(:,:,i)==0);
        buffer(:,:,i)=buffer(:,:,i)*0.00001;
        imgX(:,:,i)=imgX(:,:,i)+buffer(:,:,i);
    end


    %% calculate the local region saliency

    % seperate the image into local regions
    [hang,lie,n]=size(I);
    H=floor(hang/windowSize);
    L=floor(lie/windowSize);

    fun=@(x) sum(sum(x.^alpha)); 
    for i=1:n
        ramda(:,:,i)=blkproc(imG(:,:,i), [windowSize windowSize],[0 0],fun);
    end
    
    %% similarity measurement

    for i=1:n
        f(:,:,i) = I(:,:,i)-fused;
    end


    [u,v]=freqspace([hang,lie],'meshgrid');

    u=lie/8*u; v=hang/8*v;


    r=sqrt(u.^2+v.^2);

    % Mannos-Skarison's filter
    theta_m=2.6*(0.0192+0.144*r).*exp(-(0.144*r).^1.1);

    % Daly's filter
    % avoid being divided by zero
    index=find(r==0);
    r(index)=1;

    buff=0.008./(r.^3)+1;
    %buff(index)=0;
    buff=buff.^(-0.2);
    buff1=-0.3*r.*sqrt(1+0.06*exp(0.3*r));

    theta_d=((buff).^(-0.2)).*(1.42*r.*exp(buff1));
    theta_d(index)=0;
    clear buff;
    clear buff1;

    % Ahumada filter
    theta_a=alpha_c*exp(-(r/f_c).^2)-alpha_s*exp(-(r/f_s).^2);

    % second, filter the image in frequency domain

    ff = fft2(f);
%     for i=1:n
%         ff(:,:,i) = fft2(f(:,:,i));
%     end

    % here filter 1 is used.

    Df=ifft2(ifftshift(fftshift(ff).*theta_m));


    fun2=@(x) mean2(x.^2);
%     D = blkproc(Df, [windowSize windowSize],[0 0],fun2);
    for i=1:n
        D(:,:,i) = blkproc(Df(:,:,i), [windowSize windowSize],[0 0],fun2);
    end
    %% global quality

    % pay attention to this equation, the author might be WRONG!!!
    %Q=sum(sum(ramda1.*D1+ramda2.*D2/(ramda1+ramda2)));


    Q = sum(sum(sum(ramda.*D,3)))/sum(sum(sum(ramda,3)));
    output=real(Q);

end

function RES=normalize1(data)

    % function RES=normalize1(data)
    %
    % This function is to NORMALIZE the data. 
    % The data will be in the interval 0-255 (gray level) and pixel value has
    % been rounded to an integer.
    % 
    % See also: normalize.m 
    %
    % Z. Liu @NRCC (Aug 24, 2009)

    data=double(data);
    da=max(data(:));
    xiao=min(data(:));
    if (da==0 & xiao==0)
        RES=data;
    else
        newdata=(data-xiao)/(da-xiao);
        RES=round(newdata*255);
    end
end


