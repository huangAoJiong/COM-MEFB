
function [R,en_I] = exposure_fusion(I,I_origin,I_seg)
I_seg=uint8(I_seg*255);
r = size(I,1);
c = size(I,2);
N = size(I,3);
% -------------------------------------------------------------------

% -------------------------------------------------------------------
% a_ = imread('D:\MatlabCode\Test\a_fenge.bmp');
W = ones(r,c,N);
en_W = zeros(r,c,N);
I2=uint8(I*255);
for i=1:N
   I(:,:,i) = imguidedfilter(I_origin(:,:,i),I(:,:,i));
end
% en_I = calculate_energy2(I2,I_seg);
% en_I = zeros(256,N);
% for k=1:N
% for i=1:r
%     for j=1:c
%         if I_seg(i, j,k) == 0
%             continue;
%         end
%         en_W(i,j,k) = en_I(I2(i,j,k)+1,k)*I(i,j,k);
%     end
% end
% end
corr_list_W = list_correlation(I);
Well=my_well_exposedness(I);
WSa = I_saliency(I);
WC = my_contrast(I);
W = W.*Well.*WSa.*WC.*corr_list_W;

%normalize weights: make sure that weights sum to one for each pixel
W = W + 1e-12; %avoids division by zero
% W = W./(sum(W,3));
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
% R = LCC(R);
% R = im2double( uint8(R));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 图像序列前后文信息
% 
function w = list_correlation(I)
[m,n,K] = size(I);
w=zeros(m,n,K);
for i=1:m
    for j=1:n
        w(i,j,:) =  mean2(I(i,j,:))-abs(I(i,j,:)-mean2(I(i,j,:)));
    end
end
end

%% 梯度
function w = gradients(I)
sx = [1 2 1;0 0 0;-1 -2 -1];
sy=sx';
[R,C,~,N] = size(I);
w = zeros(R,C,N);
for i=1:N
    temp = rgb2gray(I(:,:,:,i));
    img2gradientX = imfilter(temp,sx);
    img2gradientY = imfilter(temp,sy);
    w(:,:,i) = sqrt(img2gradientX.^2+img2gradientY.^2);
end
w = w + 1e-12; %avoids division by zero
w = w./repmat(sum(w,3),[1 1 N]);
end



%% 
% contrast measure
% 对比度
function A = my_contrast(I)
N = size(I,3);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = I(:,:,i);
    C(:,:,i) = getLapfliter(mono);
end
A = C;
end
function img_addLapfiltered = getLapfliter(img)
lapls = [0, -1, 0;-1, 4, -1;0, -1, 0]/4;
%     lapls = [-1, -1, -1;-1, 8, -1;-1, -1, -1];
img_L = abs(imfilter(img,lapls,'replicate'));
img_addLapfiltered = img + img_L;
end
function img_filtered = getMeanfilter(img)
f=1/9*ones(3);%低通滤波器，滤除高频噪声
filtered_img_gray = imfilter(img,f);
img_filtered = filtered_img_gray;
end




%% 自适应曝光度提取
function E = my_well_exposedness(I)

N = size(I,3);
% E = zeros(size(I,1),size(I,2),Channel,N);
E = zeros(size(I,1),size(I,2),N);
for i = 1:N
    Ihsi = I(:,:,i);
    miu_mean = mean(mean(Ihsi(:,:,1)));
    sig_std2 = std2(Ihsi(:,:,1));
    E(:,:,i) = exp(-.5*(Ihsi(:,:,1) - (1-miu_mean)).^2/sig_std2.^2);

end
E = imguidedfilter(E,E);
end





%% Mertens methods
% contrast measure
function C = contrast(I)
h = [0 1 0; 1 -4 1; 0 1 0]; % laplacian filter
N = size(I,3);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = I(:,:,i);
    C(:,:,i) = abs(imfilter(mono,h,'replicate'));
end
end

% saturation measure
function C = saturation(I)
N = size(I,3);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    % saturation is computed as the standard deviation of the color channels
%     R = I(:,:,1,i);
%     G = I(:,:,2,i);
%     B = I(:,:,3,i);
%     mu = (R + G + B)/3;
%     C(:,:,i) = sqrt(((R - mu).^2 + (G - mu).^2 + (B - mu).^2)/3);
    C(:,:,i) = I(:,:,i);

end
end

% well-exposedness measure
function C = well_exposedness(I)
sig = .2;
N = size(I,3);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
%     R = exp(-.5*(I(:,:,1,i) - .6).^2/sig.^2);
%     G = exp(-.5*(I(:,:,2,i) - .6).^2/sig.^2);
    B = exp(-.5*(I(:,:,i) - .6).^2/sig.^2);
    C(:,:,i) = B;
end

end



