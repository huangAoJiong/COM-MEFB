function [outputArg1] = I_rgb2gray(I)
%I_RGB2GRAY 此处显示有关此函数的摘要
[r,c,~,n] = size(I);
outputArg1 = zeros(r,c,n);
for i=1:n
    outputArg1(:,:,i) = rgb2gray(I(:,:,:,i));
end

