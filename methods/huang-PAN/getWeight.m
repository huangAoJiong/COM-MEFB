function W = getWeight(I)
%I = load_images('F:\Image Fusion\遥感影像集\house');
r = size(I,1);
c = size(I,2);
N = size(I,4);
W = ones(r,c,N);

W = W .* contrast(I) .* saturation(I) .* well_exposedness(I);

%normalize weights: make sure that weights sum to one for each pixel
W = W + 1e-12; %avoids division by zero
W = W./repmat(sum(W,3),[1 1 N]);
%imshow(W);
end
function A = contrast(I)
    N = size(I,4);
    C = zeros(size(I,1),size(I,2),N);
    for i = 1:N
        mono = rgb2gray(I(:,:,:,i));
        C(:,:,i) = getMeanfilter(mono);
    end
    A = C;
end
function img_filtered = getMeanfilter(img)
 	f=1/9*ones(3);%低通滤波器，滤除高频噪声
    if(length(size(img)) == 3)
        fR=img(:,:,1);%R分量
        fG=img(:,:,2);%G分量
        fB=img(:,:,3);%B分量
        filtered_fR=imfilter(fR,f);
        filtered_fG=imfilter(fG,f);
        filtered_fB=imfilter(fB,f);
        img_filtered=cat(3,filtered_fR,filtered_fG,filtered_fB);
    end
    if(length(size(img)) == 2)
        filtered_img_gray = imfilter(img,f);
        img_filtered = filtered_img_gray;
    end
end

% saturation measure
function S = saturation(I)
N = size(I,4);
S = zeros(size(I,1),size(I,2),N);
for i = 1:N
    % saturation is computed as the standard deviation of the color channels
    R = I(:,:,1,i);
    G = I(:,:,2,i);
    B = I(:,:,3,i);
    mu = (R + G + B)/3;
    S(:,:,i) = sqrt(((R - mu).^2 + (G - mu).^2 + (B - mu).^2)/3);
end
end

% well-exposedness measure
function E = well_exposedness(I)
sig = .2;
N = size(I,4);
E = zeros(size(I,1),size(I,2),N);
aerf = 0.1;
beit = 0.9;
for i = 1:N
    R = aerf + beit .* exp(-.5*(I(:,:,1,i) - .6).^2/sig.^2);
    G = aerf + beit .*exp(-.5*(I(:,:,2,i) - .6).^2/sig.^2);
    B = aerf + beit .*exp(-.5*(I(:,:,3,i) - .6).^2/sig.^2);
    E(:,:,i) = R.*G.*B;
end
end



