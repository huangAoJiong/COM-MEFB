% function out = saliency(i1,i2)
% %Ȩ��ӳ��
% %�������������RGBͼ,����ͼ1����ͨ��Ȩ��ͼ
% [w, h, d] = size(i1);
% out = zeros(w, h, d);
% for i=1:d
%     maxmap = max(cat(3, i1(:,:,i), i2(:,:,i)), [], 3); %������ֵͼ
%     temp = double(maxmap==i1(:,:,i)); % ���Ȩ��ͼ
%     out(:,:,i) = temp;
% end

function sa = saliency(I1,I)
[R,C,D,~] = size(I);
sa = zeros(R,C,D);
for d = 1:D
    II(:,:,:) = I(:,:,d,:);
    maxmap = max(II,[],3);
    temp = double(maxmap == I1(:,:,d));%�޷�ִ�и�ֵ����Ϊ���Ĵ�СΪ 340��512���Ҳ�Ĵ�СΪ 340��512��1��2��
    sa(:,:,d) = temp;
end
