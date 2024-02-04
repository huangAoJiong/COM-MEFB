% The source code is from the authors of the metric
% The interface is modified by the author of MEFB to integrate it into MEFB. 
% 
% Reference for the metric:
% D. M. Bulanon, T. Burks, and V. Alchanatis, ?°Image fusion of visible and thermal images for fruit detection,?±
% Biosystems Engineering, vol. 103, no. 1, pp. 12¨C22, 2009.

function res=metricsCross_entropy(I,fused)

if strcmp(class(I),'double')
    I = uint8(I*255);
end
if strcmp(class(fused),'double')
    fused = uint8(fused*255);
end

    if length(size(I)) == 4
        I=I_rgb2gray(I);
    end
    % Get the size of img 
    [m,n,b] = size(fused); 
    
    if b == 1
        g = cross_entropy_single(I,fused);
        res = g;
    else
        for k = 1 : b 
            g(k) = cross_entropy_single(I,fused(:,:,k)); 
        end 
        res = mean(g); 
    end

end

function output = cross_entropy_single(I,fused)

    [r,c,n] = size(I);

    cross_entropyR =0;
    for i=1:n
        cross_entropyR = cross_entropyR+cross_entropy(I(:,:,i),fused);
    end
    output = cross_entropyR./double(n);

end

function res0 = cross_entropy(img1,fused)
    s=size(size(img1));
    if s(2)==3 
        f1=rgb2gray(img1);
    else
        f1=img1;
    end 

    s1=size(size(fused));
    if s1(2)==3
        f2=rgb2gray(fused);
    else
        f2=fused;
    end 

    G1=double(f1);
    G2=double(f2);
    [m1,n1]=size(G1);
    [m2,n2]=size(G2);
    m2=m1;
    n2=n1;
    X1=zeros(1,256);
    X2=zeros(1,256);
    result=0;

    for i=1:m1
        for j=1:n1
            X1(G1(i,j)+1)=X1(G1(i,j)+1)+1;
            X2(G2(i,j)+1)=X2(G2(i,j)+1)+1;
        end
    end

    for k=1:256
        P1(k)=X1(k)/(m1*n1);
        P2(k)=X2(k)/(m1*n1);
        if((P1(k)~=0)&(P2(k)~=0))
            result=P1(k)*log2(P1(k)/P2(k))+result;
        end
    end
    res0=result;
end

