% 初始化图像序列变量I，包含4张256x256的RGB彩色图像
I = load_images('D:\Papers\house');

% 初始化一个空的图像序列变量R，用于存储每个图像的红色通道
R = zeros(size(I,1),size(I,2),size(I,4));

% 循环遍历每个图像，提取红色通道并存储在R中
for i = 1:4
    R(:, :, i) = I(:, :, 1, i);
end
