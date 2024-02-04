% 参数：
%       I_sa：需要求显著图的图像
%        I ：求显著图的图像集 
% 根据输入图像序列的亮度图层，计算输入图像序列显著性
function I_sa = I_saliency(I)
I_v = zeros(size(I,1),size(I,2),size(I,4));
for n=1:size(I,4)
    temp = rgb2hsv(I(:,:,:,n));
    I_v(:,:,n) = temp(:,:,3);
end

[R,C,N] = size(I_v);
I_sa = zeros(R,C,N);

maxmap = max(I_v,[],3);
for i=1:N
    
    temp = double(maxmap == I_v(:,:,i));
    I_sa(:,:,i) = temp;
end

% 显著性权重归一化
sum_temp = sum(I_sa,3);
for i=1:N
    I_sa(:,:,i) = I_sa(:,:,i) ./ sum_temp;
end
end


