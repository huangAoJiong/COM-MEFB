% function out = saliency(i1,i2)
% %权重映射
% %对于输入的两张RGB图,返回图1的三通道权重图
% [w, h, d] = size(i1);
% out = zeros(w, h, d);
% for i=1:d
%     maxmap = max(cat(3, i1(:,:,i), i2(:,:,i)), [], 3); %求显著值图
%     temp = double(maxmap==i1(:,:,i)); % 求解权重图
%     out(:,:,i) = temp;
% end

function sa = saliency(I1,I)
[R,C,D,~] = size(I);
sa = zeros(R,C,D);
for d = 1:D
    II(:,:,:) = I(:,:,d,:);
    maxmap = max(II,[],3);
    temp = double(maxmap == I1(:,:,d));%无法执行赋值，因为左侧的大小为 340×512，右侧的大小为 340×512×1×2。
    sa(:,:,d) = temp;
end
