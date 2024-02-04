
function [R,W] = Copy_of_exposure_fusion(I)

r = size(I,1);
c = size(I,2);
N = size(I,3);
% -------------------------------------------------------------------

% -------------------------------------------------------------------

W = ones(r,c,N);
expose = my_well_exposedness(I);
% pca = my_getW_Pca(I);
expose=imguidedfilter(expose,expose);
% sa = I_saliency(I);
W = W.*(expose).*contrast(I).*my_well_exposedness(I);%.*(bio_J).*(pca)

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
	pyrI = laplacian_pyramid(I(:,:,i));
    % blend
    for l = 1:nlev
        w = pyrW{l};
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
function A = contrast(I)
N = size(I,3);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    C(:,:,i) = getMeanfilter(I(:,:,i));
    
    C(:,:,i) = getLapfliter(C(:,:,i));
    
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
if(length(size(img)) == 2)
    filtered_img_gray = imfilter(img,f);
    img_filtered = filtered_img_gray;
end
end

% saturation measure
% ���Ͷ�
function S = saturation(I)
N = size(I,3);
S = zeros(size(I,1),size(I,2),N);
for i = 1:N
    % saturation is computed as the standard deviation of the color channels
    mu = I(:,:,i);
    S(:,:,i) = sqrt(((R - mu).^2 + (G - mu).^2 + (B - mu).^2)/3);
    
    S(:,:,i) = getLapfliter(S(:,:,i));
    
end
end

% own well-exposedness measure
% �ع��
function E = well_exposedness(I)
sig = .2;
N = size(I,3);
E = zeros(size(I,1),size(I,2),N);
aerf = 0.1;
beit = 0.9;
for i = 1:N
    R = aerf + beit .* exp(-.5*(I(:,:,1,i) - .6).^2/sig.^2);
    E(:,:,i) = R;
    E(:,:,i) = getLapfliter(E(:,:,i));
    
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ����Ӧ�ع����ȡ
function E = my_well_exposedness(I)

N = size(I,3);
Channel = size(I,3);
% E = zeros(size(I,1),size(I,2),Channel,N);
E = zeros(size(I,1),size(I,2),N);
for i = 1:N
    Ihsi = I(:,:,i);
    miu_mean = mean(mean(Ihsi(:,:,1)));
    sig_std2 = std2(Ihsi(:,:,1));
    E(:,:,i) = exp(-.5*(Ihsi(:,:,1) - (1-miu_mean)).^2/sig_std2.^2);

end
end
%% ���ɷַ�����ȡ��PCA��
function W_Pca_single = my_getW_Pca(I)
%% �ж�ͼ��I�ǻҶ�ͼ����RGBͼ
if(size(I,4) == 1) 
    [R,C,N] = size(I);
else
    [R,C,Channel,N] = size(I);
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

