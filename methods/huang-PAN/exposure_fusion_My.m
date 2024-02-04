
function [R,W] = exposure_fusion_My(I)

r = size(I,1);
c = size(I,2);
N = size(I,3);
% -------------------------------------------------------------------

% -------------------------------------------------------------------

W = ones(r,c,N);
my_expose = my_well_exposedness(I);
% my_expose=imguidedfilter(my_expose,my_expose);
% mertens_expose = well_exposedness(I);
% Sw = saturation(I);
% pca = my_getW_Pca(I);
my_contrastW = my_contrast(I);
% mertens_contrastW = contrast(I);
sa = I_saliency(I);
lc = list_correlation(I);
% W = W.*(my_expose).*my_contrastW.*sa;
W = W.*my_expose.*my_contrastW.*sa.*lc;
%normalize weights: make sure that weights sum to one for each pixel
W = W + 1e-12; %avoids division by zero
W = W./repmat(sum(W,3),[1 1 N]);

% create empty pyramid
pyr = gaussian_pyramid(zeros(r,c));
nlev = length(pyr);

% multiresolution blending
% 多分辨率混合
for i = 1:N
    % construct pyramid from each input image
    % 从每个输入图像构建金字塔
	pyrW = gaussian_pyramid(W(:,:,i));
	pyrI = laplacian_pyramid(I(:,:,i));
    % blend
    for l = 1:nlev
%         w = repmat(pyrW{l},[1 1 3]);
        w = pyrW{l};
        pyr{l} = pyr{l} + w.*pyrI{l};
    end
end
% reconstruct
R = reconstruct_laplacian_pyramid(pyr);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 图像序列前后文信息
function w = list_correlation(I)
[m,n,K] = size(I);
w=zeros(m,n,K);
for i=1:m
    for j=1:n
        w(i,j,:) =  mean2(I(i,j,:))-abs(I(i,j,:)-mean2(I(i,j,:)));
    end
end
end

%% contrast measure
% 对比度
function A = my_contrast(I)
N = size(I,3);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = (I(:,:,i));
    C(:,:,i) = getLapfliter(mono);
end
A = C;
end
function img_addLapfiltered = getLapfliter(img)
lapls = [0, -1, 0;-1, 4, -1;0, -1, 0];
%     lapls = [-1, -1, -1;-1, 8, -1;-1, -1, -1];
img_L = imfilter(img,lapls);
img_addLapfiltered = img + img_L;
end
function img_filtered = getMeanfilter(img)
f=1/9*ones(3);%低通滤波器，滤除高频噪声
filtered_img_gray = imfilter(img,f);
img_filtered = filtered_img_gray;
end


% contrast measure
function C = contrast(I)
h = [0 1 0; 1 -4 1; 0 1 0]; % laplacian filter
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = rgb2gray(I(:,:,:,i));
    C(:,:,i) = abs(imfilter(mono,h,'replicate'));
end
end
% saturation measure
% Mertens饱和度+++++++++++++++++++++++++++++++++++++++
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

% own well-exposedness measure
% Mertens曝光度+++++++++++++++++++++++++++++++++++++++
function E = well_exposedness(I)
sig = .2;
N = size(I,4);
E = zeros(size(I,1),size(I,2),N);
for i = 1:N
    R = exp(-.5*(I(:,:,1,i) - .6).^2/sig.^2);
    G = exp(-.5*(I(:,:,2,i) - .6).^2/sig.^2);
    B = exp(-.5*(I(:,:,3,i) - .6).^2/sig.^2);
    E(:,:,i) = R.*G.*B;    
%     E(:,:,i) = getLapfliter(E(:,:,i));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 自适应曝光度提取
function E = my_well_exposedness(I)

N = size(I,3);
E = zeros(size(I,1),size(I,2),N);
for i = 1:N
    Ihsi = (I(:,:,i));
    miu_mean = mean2(Ihsi(:,:,1));
    sig_std2 = std2(Ihsi(:,:,1));
    E(:,:,i) = exp(-.5*(Ihsi(:,:,1) - (1-miu_mean)).^2/sig_std2.^2);
end
E = imguidedfilter(E,E);
end









