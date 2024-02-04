%%%
% F=FMMR(I,n,r,eps)
% n=1 refers to dynamic fusion
% r and eps control the sharpness of the weight maps. A smaller r and eps is
% better for fusion of low resolution images. A bigger r and eps is
% prefered for fusion of very high resolution images.
% the default parameter setting is r=100 and eps=4 in the TCE paper


clc,clear
% dynamic fusion
I=load_images('.\sourceimages\ForrestSequence\',1);% the folder of source imageflag =0;
F=FMMR(I,1,100,4);
figure,imshow(F);
% colour multispectral fusion
I=load_images('.\sourceimages\colourset\',1);% the folder of source image
F=FMMR(I,1,100,4);
figure,imshow(F);
% gray image fusion
I=load_images('.\sourceimages\grayset\',1);% the folder of source image
F=FMMR(I,1,20,1);
figure,imshow(F);
%
I=load_images('D:\Papers\3\2_2',1);% the folder of source image
F=FMMR(I,1,20,1);
figure,imshow(F);
% imwrite(F(:,:,1),'D:\Papers\3\2_Res\FMMR_median_and_recursive_filter_2012.bmp')