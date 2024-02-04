% DARK IMAGE ENHANCEMENT BASED ON PAIRWISE TARGET CONTRAST AND MULTI-SCALE DETAIL BOOSTING
function enhanced_img = MultiScaleDetailBoosting(src_img, radius)
% mertinx
% src_img: 输入图像,最好是uint8
% radius: 滤波器半径
if(~exist('radius', 'var'))
    radius = 1;
end
if isa(src_img,'double')
    src_img=uint8(src_img*255);
end
src_img=double(src_img);
% 分别对输入图像进行不同的高斯滤波，获取三组不同尺度的图像
% B1 = imgaussfilt(src_img, 1, 'FilterSize', 2 * radius + 1);
% B2 = imgaussfilt(src_img, 2, 'FilterSize', 4 * radius + 1);
% B3 = imgaussfilt(src_img, 4, 'FilterSize', 8 * radius + 1);
B1 = imgaussfilt(src_img, 1);
B2 = imgaussfilt(src_img, 2);
B3 = imgaussfilt(src_img, 4);


% 定义权重系数
w1 = 0.6;
w2 = 0.3;
w3 = 0.1;

% 对每个像素进行增强
enhanced_img = zeros(size(src_img));
% for i = 1:size(src_img, 1)
%     for j = 1:size(src_img, 2)
%         % 对RGB三个通道分别处理,如果是单通道也可以
%         for k = 1:size(src_img,3)
%             % 计算三组高斯滤波结果与原图像之间的差值
%             D1 = double(src_img(i, j, k)) - double(B1(i, j, k));
%             D2 = double(B1(i, j, k)) - double(B2(i, j, k));
%             D3 = double(B2(i, j, k)) - double(B3(i, j, k));
%             signn = sign(D1);
%             % 计算增强后的像素值
% %             enhanced_img(i, j, k) = max(min(255, (1 - w1 * signn) * D1 - w2 * D2 + w3 * D3 ), 0);
%             enhanced_img(i, j, k) = (1 - w1 * signn) * D1 - w2 * D2 + w3 * D3 ;
%         end
%     end
% end

for k = 1:size(src_img,3)
    % 计算三组高斯滤波结果与原图像之间的差值
    D1 = double(src_img) - double(B1);
    D2 = max(min(255,double(B1) - double(B2)),0);
    D3 = max(min(255,double(B2) - double(B3)),0);
    signn = sign(D1);
    % 计算增强后的像素值
    %             enhanced_img(i, j, k) = max(min(255, (1 - w1 * signn) * D1 - w2 * D2 + w3 * D3 ), 0);
%     enhanced_img = (1 - w1 .* signn) .* D1 - w2 .* D2 + w3 .* D3 + double(src_img);
enhanced_img = w1  .* D1 - w2 .* D2 + w3 .* D3 ;
end
enhanced_img = max(min(255,enhanced_img + double(src_img)),0);
enhanced_img = uint8(enhanced_img);
enhanced_img = im2double(enhanced_img);
