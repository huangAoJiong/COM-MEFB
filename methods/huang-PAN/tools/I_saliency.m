% 参数：
%       I_sa：
%        I ：求显著图的图像集 
function I_sa = I_saliency(I)
I_v = zeros(size(I,1),size(I,2),size(I,3));
for n=1:size(I,3)
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

%% 显著性权重归一化
sum_temp = sum(I_sa,3);
for i=1:N
    I_sa(:,:,i) = I_sa(:,:,i) ./ sum_temp;
end


end


