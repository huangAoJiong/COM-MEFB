% 参数：
%       I_sa：
%        I ：求显著图的图像集 
function I_sa = I_saliency(I)
% I_v = zeros(size(I,1),size(I,2),size(I,3));
seg = load_images('D:\papers\3\2_3');
[R,C,N] = size(I);
I_sa = zeros(R,C,N);

maxmap = max(I,[],3);
for i=1:N
%     temp = double(maxmap == I(:,:,i) & seg(:,:,i)>0.3);
     temp = double(maxmap == I(:,:,i));
    I_sa(:,:,i) = temp;
end

%% 显著性权重归一化
sum_temp = sum(I_sa,3); 
for i=1:N
    I_sa(:,:,i) = I_sa(:,:,i) ./ sum_temp;
end


end


