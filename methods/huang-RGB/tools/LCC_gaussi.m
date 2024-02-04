clear,clc,close all
img = imread('D:\papers\Images\house\B.png');
[R,C,ch] = size(img);
I = (zeros(R,C));
out_img = img;
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);
for i=1:R
    for j=1:C
        I(i,j) = (r(i,j) +g(i,j)+b(i,j))/3;
    end
end
figure,imshow(I)
% I=uint8(I*255);
% figure,imshow(I)
Revert_I = (ones(R,C)*255);
Mask = (Revert_I - I);figure(),imshow(Mask),title('Mask');
Mask = uint8(Mask);
Mask_core = fspecial('gaussian',[41 41]);
M = imfilter(Mask,Mask_core,'replicate');

lump = 2.^((128-double(M))/128.0);
lump_3 = repmat(lump,[1 1 3]);
value = uint8((255*(double(I)/255.0)).^lump_3);
figure,imshow([img value])
% lcc = real(255 * ((I / 255) .^ (2 .^((128 - M) / 128))));  


% T = cat(3,lcc,lcc,lcc);
% imshow([img T])