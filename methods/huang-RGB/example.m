
clc
% close all;
clear;
addpath '.'/tools/
% addpath('D:\matlabCode\qualityEstimate\BRISQUE-main\MATLAB') % ���BRISQUE����ָ��·����score = brisquescore(img);
addpath('assessTools\')
output_path = './output2/';
% �ںϵ�ͨ���Ҷ�ͼ��ͼ�����
% I=load_images_all('D:\papers\3\2');
% [RR,WW] = Copy_of_exposure_fusion(I);
% figure,imshow([RR,LCC(RR)]);title('�ںϵ�ͨ��ͼ�����ǿ���չʾ')
% I=load_images('./3_hsv_v_enhance');

% II = load_images('D:\papers\Images\MultipleExposure\5');
II = load_images('D:\Papers\3\����ģ��\RGB');
[R,W] = exposure_fusion(II);
% imwrite(R,[output_path,'111.bmp']);
figure('Name','init_Result'); 
imshow(R);title('�ںϵĳ�ʼ���ͼ') ;
% Assess. = struct('Lmeans','EN','AG','SF','M','ssims','niqe','ilniqe','Var','Std');

Rhsv = rgb2hsv(uint8(R*255));
Rhsv_3 = Rhsv(:,:,3);
Rhsv_3_lcc = LCC(Rhsv_3);
% te = im2double( imread('D:\3_LCC.bmp'));
% Rhsv_3_lcc = te(:,:,1);
gama = Rhsv_3_lcc./Rhsv_3;
R1 = gama.*R;   %���ȱ����滻���RGB��R��
figure('Name','LLC_Result'); 
imshow(R1);
% imwrite(R1,'./output2/R1_LCC-gausi_11.3.bmp');
% R1 = im2double( imread('./output2/R1.bmp'));
% R = R1;
% temp = rgb2hsv(R);
% Assess.Lmeans = mean2(temp(:,:,3));
% R = uint8(R*255);
% Assess.EN = entropy(rgb2gray(R));
% Assess.SF = ENSpatialFrequency(R);
% Assess.AG = AverageGradient(R);
% Assess.M = mean2(R);
% Assess.ssims = SSIMscore(II,R);
% Assess.niqe = niqe(R);
% Assess.ilniqe = getILNIQE(R);
% i=double(rgb2gray(R));
% Assess.Var = var(i(:));
% Assess.Std = std2(R);
% Assess
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R1=R;
% Rhsv = rgb2hsv(uint8(R*255));
% Rhsv_3 = Rhsv(:,:,3);
% Rhsv_3_lcc = LCC(Rhsv_3);
% Rhsv(:,:,3) = Rhsv_3_lcc;
% R2 = hsv2rgb(Rhsv);
% figure,imshow(R2),title('����������ͼ')


% gama = Rhsv_3_lcc./Rhsv_3;
% R1 = gama.*R;   %���ȱ����滻���RGB��R��

%% ��ʱ�ر�-����modelRGB
%{
imwrite(R1,'./output2/tempR1.bmp');
R1 = im2double( imread('./output2/tempR1.bmp'));
temp = rgb2hsv(R1);
Lmeans = mean2(temp(:,:,3))     %���Ⱦ�ֵ
EN = entropy(rgb2gray(R1))      %��Ϣ��
SF = ENSpatialFrequency(R1)     %�ռ�Ƶ��
AG = AverageGradient(R1)        %ƽ���ݶ�
R = uint8(R*255);
R1 = uint8(R1*255);
R2 = R1;
fprintf('��Ϣ�� = %f\t\t%f\t%f\n',entropy(rgb2gray(R)),entropy(rgb2gray(R2)),entropy(rgb2gray(R1))');
fprintf('NIQE = %f\t\t%f\t%f\n',niqe(R),niqe(R2),niqe(R1));
fprintf('ILNIQE = %f\t\t%f\t%f\n',getILNIQE(R),getILNIQE(R2),getILNIQE(R1));
fprintf('��ֵ = %f\t\t%f\t%f\n',mean2(R),mean2(R2),mean2(R1));
fprintf('��׼�� = %f\t\t%f\t%f\n',std2(R),std2(R2),std2(R1));
fprintf('corr2���ϵ�� = %f\t\t%f\t%f\n',my_corr2_score(II,R),my_corr2_score(II,R2),my_corr2_score(II,R1));
%}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imwrite(real(R),'D:\papers\Images\3_result\my2.bmp');
% {
%}
R2 = R1;
fprintf('SSIM = %f\t\t%f\t%f\n',my_ssim_score(II,R),my_ssim_score(II,R2),my_ssim_score(II,R1));
R = uint8(R*255);
R1 = uint8(R1*255);

R2 = uint8(R2*255);
fprintf('��Ϣ�� = %f\t\t%f\t%f\n',entropy(rgb2gray(R)),entropy(rgb2gray(R2)),entropy(rgb2gray(R1)));
fprintf('NIQE = %f\t\t%f\t%f\n',niqe(R),niqe(R2),niqe(R1));
fprintf('ILNIQE = %f\t\t%f\t%f\n',getILNIQE(R),getILNIQE(R2),getILNIQE(R1));
fprintf('��ֵ = %f\t\t%f\t%f\n',mean2(R),mean2(R2),mean2(R1));
fprintf('��׼�� = %f\t\t%f\t%f\n',std2(R),std2(R2),std2(R1));
fprintf('corr2���ϵ�� = %f\t\t%f\t%f\n',my_corr2_score(II,R),my_corr2_score(II,R2),my_corr2_score(II,R1));




