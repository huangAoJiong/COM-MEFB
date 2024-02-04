clear all;
close all
clc
dirName = ('testimage\treeunil\');
% delete ('Test_Images\house\thumbs.db');
[filenames, num_LDR] = readDir2(dirName);


temp = imread(filenames{1});
[height,width,color]=size(temp);

I = zeros(height,width,color,num_LDR);
for k = 1:num_LDR
    
    temp = double(imread(filenames{k}));
    
    for i = 1:height
        for j = 1:width
            for n = 1:color
                I(i,j,n,k)=temp(i,j,n)/255;
            end
        end
    end
    
end
for i=1:num_LDR
    a(:,:,:,i) = imread(filenames{i});
end

clear temp;clear tmp;
% 

%Generate two virtual images 
[h_s,s_h]=IMF_virtual(a);
final_virtual=Fusion_virtual(s_h,h_s,a(:,:,:,2),a(:,:,:,1));
%GGIF
 I(:,:,:,3)=final_virtual/255;
 figure,imshow(I(:,:,:,1));
 figure,imshow(I(:,:,:,2));
R = exposure_fusion(I,[1 1 1],2); %% [1,1,1] to enable the three weighting factors.
 figure;
 imshow(R);
% imwrite(R,'treeunil.png');

