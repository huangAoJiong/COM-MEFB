% img = R2;
clear;close all;
I = load_images('D:\papers\Images\3');
img = imread('D:\papers\Images\3_result\0921-LCC.bmp');
img = im2double(img);
% img =double(img);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
img_T = rgb2hsi(img);
% L = img_T(:,:,3);
L = rgb2gray(img);
beita_r = zeros(size(img,1),size(img,2));
beita_g = zeros(size(img,1),size(img,2));
beita_b = zeros(size(img,1),size(img,2));
count1=0;
count2=0;
count3=0;
for i=1:size(img,1)
    for j=1:size(img,2)
        if R(i,j)>200/255 && R(i,j)<230/255
            beita_r(i,j)=(200/255-L(i,j))./(R(i,j)-L(i,j));
        else
            beita_r(i,j)=1;
        end
        if G(i,j)>200/255 && G(i,j)<230/255
            beita_g(i,j)=(200/255-L(i,j))./(G(i,j)-L(i,j));
        else
            beita_g(i,j)=1;
        end
        if B(i,j)>200/255 && B(i,j)<230/255
            beita_b(i,j)=(200/255-L(i,j))./(B(i,j)-L(i,j));
        else
            beita_b(i,j)=1;
        end
    end
end
beita = max(max(beita_b,beita_g),beita_r);
img2 = beita.*img+(1-beita).*L;
R2 = beita_r.*R+(1-beita_r).*L;
G2 = beita_g.*G+(1-beita_g).*L;
B2 = beita_b.*B+(1-beita_b).*L;


figure,imshow([img cat(3,R2,G2,B2) img2])
figure,imshow([R G B;R2 G2 B2])
img3 = cat(3,R2,G2,B2);


% a1=[1 2 3;4 5 6];
% a2=[2 1 4;3 6 5];
% if(a1>3) 
%     t=a1+10;
% end
% imgssim = SSIMscore(I,uint8(img2*255))
img3ssim = SSIMscore(I,uint8(img3*255))