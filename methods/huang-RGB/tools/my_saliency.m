% 参数：
%       Isa：需要求显著图的图像
%        I ：求显著图的图像集 
function sa = my_saliency(Isa,I)
I_v = zeros(size(I,1),size(I,2),size(I,4));
for n=1:size(I,4)
    temp = rgb2hsv(I(:,:,:,n));
    I_v(:,:,n) = temp(:,:,3);
end
% I_v_gammer = I_v .^.4;
Isa = rgb2hsv(Isa);
Isa_temp(:,:) = Isa(:,:,3);
[R,C] = size(I_v);
sa = zeros(R,C);
maxmap = max(I_v,[],3);
temp = double(maxmap == Isa_temp);
sa(:,:) = temp;
end


