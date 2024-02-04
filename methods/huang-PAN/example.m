
% clc
close all;
clear;
% [I2,Na]=load_images('D:\Papers\3\2_2');
% for i=1:5
%     temp = I2(:,:,i);
% %     temp = temp>0.2;
%     temp(temp>0)=1;
% % %     figure,mesh(temp);
%     imwrite(temp,['D:\Papers\3\2_3\',Na{1}(i).name])
% end
addpath('AWGIF')
output_path = 'D:\Papers\3\最后整理最好结果\1\';
% wls_para = [0.2,.6,.9,1.2,1.5,1.8,2.0,2.4,2.6,2.8,3,3.2,3.5,3.8,4];
wls_para = [2.4];
I=load_images('D:\Papers\3\11');
[I_seg,Na] = load_images('D:\Papers\3\11_3');
% I = I_rgb2gray(I);
% I_seg = I_rgb2gray(I_seg);
I2 = I.*I_seg;
% I = I_rgb2gray(I);
tic
%[R,W] = exposure_fusion(I);
R = double_scale_exposure_fusion(I2);
figure('Name','init_Result'); 
imshow(R);title('融合的初始结果图') ;
R2 = double_scale_exposure_fusion(I2,I_seg);
toc
% imwrite(R,[output_path,'111.bmp']);
figure('Name','init_Result'); 
imshow(R2);title('融合的初始结果图') ;
imwrite(R,[output_path,'分割后图-1234-wls滤波.tif']);
imwrite(R2,[output_path,'分割后图-1234-金字塔部分加入了引导滤波-wls滤波.tif']);

%{
Rhsv = rgb2hsv(uint8(R*255));
Rhsv_3 = Rhsv(:,:,3);
Rhsv_3_lcc = LCC(Rhsv_3);
% te = im2double( imread('D:\3_LCC.bmp'));
% Rhsv_3_lcc = te(:,:,1);
gama = Rhsv_3_lcc./Rhsv_3;
R1 = gama.*R;   %亮度比例替换后的RGB（R）
figure('Name','LLC_Result'); 
imshow(R);
% imwrite(R1,'./output2/R1_LCC-gausi_11.3.bmp');



R2 = uint8(R2*255);
fprintf('信息熵 = %f\t\t%f\t%f\n',entropy(rgb2gray(R)),entropy(rgb2gray(R2)),entropy(rgb2gray(R1)));
fprintf('NIQE = %f\t\t%f\t%f\n',niqe(R),niqe(R2),niqe(R1));
fprintf('ILNIQE = %f\t\t%f\t%f\n',getILNIQE(R),getILNIQE(R2),getILNIQE(R1));
fprintf('均值 = %f\t\t%f\t%f\n',mean2(R),mean2(R2),mean2(R1));
fprintf('标准差 = %f\t\t%f\t%f\n',std2(R),std2(R2),std2(R1));
fprintf('corr2相关系数 = %f\t\t%f\t%f\n',my_corr2_score(II,R),my_corr2_score(II,R2),my_corr2_score(II,R1));

%}

