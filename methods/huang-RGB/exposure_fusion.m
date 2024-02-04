
function [R,W] = exposure_fusion(I)

r = size(I,1);
c = size(I,2);
N = size(I,4);
% -------------------------------------------------------------------

% -------------------------------------------------------------------

W = ones(r,c,N);
my_expose = my_well_exposedness(I);
% my_expose=imguidedfilter(my_expose,my_expose);
mertens_expose = well_exposedness(I);
Sw = saturation(I);
pca = my_getW_Pca(I);
my_contrastW = my_contrast(I);
mertens_contrastW = contrast(I);
sa = I_saliency(I);
%% ������Ȩ�ع�һ��
% sa_sum_temp = sum(sa,3);
for i=1:N
%     sa(:,:,i) = sa(:,:,i) ./ sa_sum_temp;
end
% W = W.*(my_expose).*my_contrastW.*sa;
W = W.*my_contrastW.*my_well_exposedness(I).*sa;
%normalize weights: make sure that weights sum to one for each pixel
W = W + 1e-12; %avoids division by zero
W = W./repmat(sum(W,3),[1 1 N]);

% create empty pyramid
pyr = gaussian_pyramid(zeros(r,c,3));
nlev = length(pyr);

% multiresolution blending
% ��ֱ��ʻ��
for i = 1:N
    % construct pyramid from each input image
    % ��ÿ������ͼ�񹹽�������
	pyrW = gaussian_pyramid(W(:,:,i));
	pyrI = laplacian_pyramid(I(:,:,:,i));
    % blend
    for l = 1:nlev
        w = repmat(pyrW{l},[1 1 3]);
%         w = pyrW{l};
        pyr{l} = pyr{l} + w.*pyrI{l};
        
    end
end

% reconstruct
R = reconstruct_laplacian_pyramid(pyr);
% R1=R+bio_J.*(1-mybio);
% imshow(R1),title('++');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% �ݶ�
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
%% gamma��ȡ
function gamma = gammaGet2(I)
r = size(I,1);
c = size(I,2);
N = size(I,4);
gamma = zeros(r,c,N);
for i = 1:N
    temp = rgb2hsv(I(:,:,:,i));
    gamma(:,:,i) = temp(:,:,3).^0.2;
%     gamma(:,:,i) = adapthisteq(temp);
%     figure,imshow(gamma(:,:,i))
end
end
%% gamma��ȡ
function gamma = gammaGet(I)
r = size(I,1);
c = size(I,2);
N = size(I,4);
gamma = zeros(r,c,N);
for i = 1:N
    temp = rgb2gray(uint8(I(:,:,:,i)*255));
    gamma(:,:,i) = double(adapthisteq(temp))/255;
%     figure,imshow(gamma(:,:,i))
end
end
% contrast measure
% �Աȶ�
function A = my_contrast(I)
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = rgb2gray(I(:,:,:,i));
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
f=1/9*ones(3);%��ͨ�˲������˳���Ƶ����
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
% Mertens���Ͷ�+++++++++++++++++++++++++++++++++++++++
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
% Mertens�ع��+++++++++++++++++++++++++++++++++++++++
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
%% ����Ӧ�ع����ȡ
function E = my_well_exposedness(I)

N = size(I,4);
E = zeros(size(I,1),size(I,2),N);
for i = 1:N
    Ihsi = rgb2hsv(I(:,:,:,i));
    miu_mean = mean2(Ihsi(:,:,1));
    sig_std2 = std2(Ihsi(:,:,1));
    E(:,:,i) = exp(-.5*(Ihsi(:,:,1) - (1-miu_mean)).^2/sig_std2.^2);
end
E = imguidedfilter(E,E);
end













%% ���ɷַ�����ȡ��PCA��
function W_Pca_single = my_getW_Pca(I)
%% �ж�ͼ��I�ǻҶ�ͼ����RGBͼ
if(size(I,4) == 1) 
    [R,C,N] = size(I);
else
    [R,C,~,N] = size(I);
end
%% 
line = zeros(R*C,N);
for n=1:N
    if(size(I,4) ~= 1) %�ж�ͼ��I�ǻҶ�ͼ����RGBͼ
        I_gray = rgb2gray(I(:,:,:,n));
    else
        I_gray = I(:,:,n);
    end
%     line(:,n)=getLine(I_gray); %����άͼ��ת��Ϊһά
    temp = reshape(I_gray, 1, numel(I_gray));
    line(:,n) = temp';
%     line(:,n) = line(:,n)./sum(line(:,n));
end

% W_Pca_single=zeros(R,C,Channel,N);
W_Pca_single=zeros(R,C,N);

[coeff, score, latent, tsquared, explained, mu] = pca(line);
for n=1:N
    for c=1:C
        singleLine = score(((c-1)*R+1):c*R,n);%��PCA������Ե÷�ȡ������ÿ��ͼ�����Ե÷֣�
        newImg(:,c)=abs(singleLine);
%         newImg(:,c)=(singleLine);
    end
    W_Pca_single(:,:,n) = newImg;%�õ�N��ͼ������
%     for ch=1:Channel
%         W_Pca_single(:,:,Channel,n) = newImg;%�õ�N��ͼ������
%     end
end
% W_Pca_single = W_Pca_single./repmat(sum(W_Pca_single,3),[1 1 N]);
% ���ÿһ�������������������Թ�һ����ʹ�䷶Χ��[0 1]֮�䣬Ȼ���ع���һ��rxc����
% �����һ���򵥵�ƽ����˹�˲����������ÿ���ռ�λ��Ӧ�úͶ�һ�Ĺ�һ�����õ�N��PCAȨ��ӳ��
% W_Pca_single = W_Pca_single./repmat(sum(W_Pca_single,3),[1 1 N]);
    %getLine()����άͼ��ת��Ϊһά
    function getLine=getLine(imgGray)
        %    [R,C] = size(imgGray);
        initR = imgGray(:,1);
        for c=2:C
            initR = [initR;imgGray(:,c)];
        end
        getLine =initR';
    end
end
%% �Ż���ͼ����ǿ
function [W_bio_enhance,W_bio_J]=my_bio_enhanece(I)
%% �ж�ͼ��I�ǻҶ�ͼ����RGBͼ
if(size(I,4) == 1)
    [R,C,N] = size(I);
else
    [R,C,~,N] = size(I);
end
% W_bio_enhance = zeros(R,C,size(I,3),N);
W_bio_enhance = zeros(R,C,N);
W_bio_J = zeros(R,C,N);
for n=1:N
    [W_bio_enhance(:,:,n),~,W_bio_J(:,:,n)] = my_bio_MEF(I(:,:,:,n));
%     [W_bio_enhance(:,:,:,n),~,W_J] = my_bio_MEF(I(:,:,:,n));
%     W_bio_enhance(:,:,:,n) = real(W_bio_enhance(:,:,:,n));
end
W_bio_enhance=real(W_bio_enhance);
end
function [returnW,fused,returnJ] = my_bio_MEF(I, mu, k, a, b)
%%
% @article{ying2017bio,
%   title={A Bio-Inspired Multi-Exposure Fusion Framework for Low-light Image Enhancement},
%   author={Ying, Zhenqiang and Li, Ge and Gao, Wen},
%   journal={arXiv preprint arXiv:1711.00591},
%   year={2017}
% }
% % @inproceedings{ying2017new,
% %   title={A New Image Contrast Enhancement Algorithm Using Exposure Fusion Framework},
%   author={Ying, Zhenqiang and Li, Ge and Ren, Yurui and Wang, Ronggang and Wang, Wenmin},
%   booktitle={International Conference on Computer Analysis of Images and Patterns},
%   pages={36--46},
%   year={2017},
%   organization={Springer}
% }
%USAGE
% I = imread('yellowlily.jpg');
% J = BIMEF(I); 
% subplot 121; imshow(I); title('Original Image');
% subplot 122; imshow(J); title('Enhanced Result');
%
%INPUTS
% I: 	image data (of an RGB or grayscale image)
% mu: 	enhancement ratio
% k:    exposure ratio
% a, b: camera response model params
%
%OUTPUTS
% fused: enhanced result
%
% Please feel free to contact me (yingzhenqiang-at-gmail-dot-com) if you
% have any questions or concerns.

if  ~exist( 'mu', 'var' )
    mu = 0.5;
end

if ~exist( 'a', 'var' )
    a = -0.3293;
end

if ~exist( 'b', 'var' )
    b = 1.1258;
end

if ~isfloat(I)
    I = im2double( I );
end

lambda = 0.5;
sigma = 5;

%% t: scene illumination map
t_b = max( I, [], 3 ); % also work for single-channel image
S = tsmooth( imresize( t_b, 0.5 ), lambda, sigma );
t_our =  imresize(S , size( t_b ) );
returnW = t_our.^mu;
%% k: exposure ratio
if  ~exist( 'k', 'var' ) || isempty(k)
    isBad = t_our < 0.5;
    J = maxEntropyEnhance(I, isBad);
else
    J = applyK(I, k, a, b); %k
    J = min(J, 1); % fix overflow
end
returnJ=rgb2gray(J);
%% W: Weight Matrix 
t = repmat(t_our, [1 1 size(I,3)]);%t���Ż���õ����ն�ͼ
W = t.^mu;%W�Ǹ����ն�ͼ�õ����ں�Ȩ��

I2 = I.*W;
J2 = J.*(1-W);

fused = I2 + J2;

    function J = maxEntropyEnhance(I, isBad)
        Y = rgb2gm(real(max(imresize(I, [50 50]), 0))); % max - avoid complex number
        
        if exist('isBad', 'var')
            isBad = (imresize(isBad, [50 50]));
            Y = Y(isBad);
        end
        
        if isempty(Y)
            J = I; % no enhancement k = 1
            return;
        end
        %MATLAB��������һά�Ż������е�Ӧ�á���fminbnd
        opt_k = fminbnd(@(k) ( -entropy(applyK(Y, k)) ),1, 7);
        J = applyK(I, opt_k, a, b) - 0.01;
        
    end
end

function I = rgb2gm(I)
if size(I,3) == 3
    I = im2double(max(0,I)); % negative double --> complex double
    I = ( I(:,:,1).*I(:,:,2).*I(:,:,3) ).^(1/3);
end
end

function J = applyK(I, k, a, b)

if ~exist( 'a', 'var' )
    a = -0.3293;
end

if ~exist( 'b', 'var' )
    b = 1.1258;
end

f = @(x)exp((1-x.^a)*b);
beta = f(k);
gamma = k.^a;
J = I.^gamma.*beta;
end

function S = tsmooth( I, lambda, sigma, sharpness)
if ( ~exist( 'lambda', 'var' ) )
    lambda = 0.01;
end
if ( ~exist( 'sigma', 'var' ) )
    sigma = 3.0;
end
if ( ~exist( 'sharpness', 'var' ) )
    sharpness = 0.001;
end
I = im2double( I );
x = I;
[ wx, wy ] = computeTextureWeights( x, sigma, sharpness);
S = solveLinearEquation( I, wx, wy, lambda );%S�����Ż��������ն�ͼT
end

% compute texture weight ����ṹ���� 
% min �OT??L�O 2 +�˨OM????T�O 
%M_d(x)= 1/���O��?? d,h?? L(x)�O+??��  d�ʣ�h��v��
%����Ǹ�ʽ�ӵ�M ,MΪȨֵ����
%M��Ȩ�أ�����ƶ��ڹ���ͼ��ϸ���ǳ���Ҫ���ֲ����ڵ�����Ե�ȴ��и���ͼ����������и����Ƶķ����ݶȡ�
%��ˣ�����������ıߵĴ��ڵ�Ȩ��Ӧ�ñ�ֻ��������Ĵ��ڵ�Ȩ��С��
function [ W_h, W_v ] = computeTextureWeights( fin, sigma, sharpness)

dt0_v = [diff(fin,1,1);fin(1,:)-fin(end,:)];
dt0_h = [diff(fin,1,2)';fin(:,1)'-fin(:,end)']';

gauker_h = filter2(ones(1,sigma),dt0_h);
gauker_v = filter2(ones(sigma,1),dt0_v);
W_h = 1./(abs(gauker_h).*abs(dt0_h)+sharpness);
W_v = 1./(abs(gauker_v).*abs(dt0_v)+sharpness);

end
% solve Linear Equation :�����Է���
%�õ�-->�Ż�������ϸ��T
function OUT = solveLinearEquation( IN, wx, wy, lambda )
[ r, c, ch ] = size( IN );
k = r * c;
dx =  -lambda * wx( : );
dy =  -lambda * wy( : );
tempx = [wx(:,end),wx(:,1:end-1)];
tempy = [wy(end,:);wy(1:end-1,:)];
dxa = -lambda *tempx(:);
dya = -lambda *tempy(:);
tempx = [wx(:,end),zeros(r,c-1)];
tempy = [wy(end,:);zeros(r-1,c)];
dxd1 = -lambda * tempx(:);
dyd1 = -lambda * tempy(:);
wx(:,end) = 0;
wy(end,:) = 0;
dxd2 = -lambda * wx(:);
dyd2 = -lambda * wy(:);

Ax = spdiags( [dxd1,dxd2], [-k+r,-r], k, k );
Ay = spdiags( [dyd1,dyd2], [-r+1,-1], k, k );

D = 1 - ( dx + dy + dxa + dya);
A = (Ax+Ay) + (Ax+Ay)' + spdiags( D, 0, k, k );

if exist( 'ichol', 'builtin' )
    L = ichol( A, struct( 'michol', 'on' ) );
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        [ tout, ~ ] = pcg( A, tin( : ), 0.1, 50, L, L' );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
else
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        tout = A\tin( : );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
end
end

