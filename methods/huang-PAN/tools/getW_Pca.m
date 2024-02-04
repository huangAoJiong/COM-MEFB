function pca_turn = getW_Pca(I)
%% 判断图像集I是灰度图还是RGB图
if(size(I,4) == 1) 
    [R,C,N] = size(I);
else
    [R,C,Channel,N] = size(I);
end
%% 
line = zeros(R*C,N);
for n=1:N
    if(size(I,4) ~= 1) %判断图像集I是灰度图还是RGB图
        I_gray = rgb2gray(I(:,:,:,n));
    else
        I_gray = I(:,:,n);
    end
    temp = reshape(I_gray, 1, numel(I_gray));
    line(:,n) = temp';
%     line(:,n) = line(:,n)./sum(line(:,n));
end

% W_Pca_single=zeros(R,C,Channel,N);
pca_turn=zeros(R,C,N);

[coeff, score, latent, tsquared, explained, mu] = pca(line);
for n=1:N
    for c=1:C
        singleLine = score(((c-1)*R+1):c*R,n);%把PCA后的线性得分取出来（每幅图的线性得分）
        newImg(:,c)=abs(singleLine);
%         newImg(:,c)=(singleLine);
    end
    pca_turn(:,:,n) = newImg;%得到N副图个线性
end
% W_Pca_single = W_Pca_single./repmat(sum(W_Pca_single,3),[1 1 N]);
% 随后，每一个变量分数向量被线性归一化，使其范围在[0 1]之间，然后重构回一个rxc矩阵，
% 随后是一个简单的平滑高斯滤波器。最后，在每个空间位置应用和对一的归一化，得到N个PCA权重映射
% W_Pca_single = W_Pca_single./repmat(sum(W_Pca_single,3),[1 1 N]);
    %getLine()将二维图像转换为一维
end