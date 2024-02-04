function [F] = main_api_huangSingleF(I)
%MAIN_API_MYSINGLEF 此处显示有关此函数的摘要
%   此处显示详细说明
addpath('AWGIF')
I = load_images('D:\Papers\3\自拍模型\gray-pan');
% [I_seg,~] = load_images('D:\Papers\3\11_3');
% I2 = I.*I_seg;
% F= double_scale_exposure_fusion(I2,I_seg);
F= double_scale_exposure_fusion(I);
end

