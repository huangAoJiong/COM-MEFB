load('../Assess.mat')
addpath('../assessTools/')
addpath('..')
[resI,Name] = load_images('../output2/');
addpath('../assessTools')
I = load_images('D:\papers\Images\3');
N = size(resI,4);
for i=1:N
    R = uint8(resI(:,:,:,i)*255);
    temp = Lmean(R);
    Assess(i).Lmeans=temp;
end
save '../Assess.mat' Assess
% tic
% for i=1:N
%     
%     temp_Assess.name = Name(i);
%     R= resI(:,:,:,i);
%     temp = rgb2hsv(R);
%     temp_Assess.Lmeans = mean2(temp(:,:,3));
%     R = uint8(R*255);
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
%     Assess(i) = temp_Assess;
%     i
% end
% toc