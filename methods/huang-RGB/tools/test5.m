clear;
I=load_images('D:\papers\Images\3');
img=imread('D:\papers\Images\3_result\0906.bmp');
img=im2double(img);
im = entropy(img);
sum =0;
for i=1:size(I,4)
%     entropy(I(:,:,:,i))
    sum = sum+entropy(I(:,:,:,i));
end

im/sum
