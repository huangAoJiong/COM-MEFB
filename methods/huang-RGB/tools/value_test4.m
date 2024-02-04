load('../Assess_Contrasts.mat');
addpath('../assessTools/')
addpath('D:\matlabCode\qualityEstimate\BRISQUE-main\MATLAB')
img1 = 'D:\papers\Images\3_result\Mertens.bmp';
img2 = 'D:\papers\Images\3_result\result.bmp';
img3 = 'D:\papers\Images\3_result\0927.bmp';
img4 = 'D:\papers\Images\3_result\2018-ICIP-MEF.bmp';
img5 = 'D:\papers\Images\3_result\2022-PAS-ICASSP-MEF.bmp';
img6 = 'D:\papers\Images\3_result\2019-YuvSpace.bmp';
img7 = 'D:\papers\Images\3_result\0921.bmp';
img8 = 'D:\papers\Images\3_result\0921-LCC.bmp';
[I,Name]  = load_images('D:\papers\Images\3');
img = {img1;img4;img5;img6;img7;img8;img3};
N = size(img,1);
% begin = size('D:\papers\Images\3_result\',2);
for i=1:N
%     ends = strfind(img{i},'.')-1;
%     temp = img{i};
%     temp = temp(begin+1:ends);
%     Assess_Contrast(i).name = temp;
    R = imread(img{i});
    tt = brisquescore(R)
    Assess_Contrast(i).BRISQUE = tt;
%     temp_Assess.name = img{i};
%     temp_Assess.EN = entropy(rgb2gray(R));
%     temp_Assess.SF = ENSpatialFrequency(R);
%     temp_Assess.AG = AverageGradient(R);
%     temp_Assess.M = mean2(R);
%     temp_Assess.ssims = SSIMscore(I,R);
%     temp_Assess.niqe = niqe(R);
%     temp_Assess.ilniqe = getILNIQE(R);
%     it=double(rgb2gray(R));
%     temp_Assess.Var = var(it(:));
%     temp_Assess.Std = std2(R);
%     temp_Assess.MI = MI(I,im2double(R));
%     temp_Assess.Lmean = Lmean(R);
%     Assess_Contrast(i) = temp_Assess;
%     i
end
save '../Assess_Contrasts.mat' Assess_Contrast;