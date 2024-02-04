% 求一副灰度图像的方差
close all
clear
clc;
i=im2double( imread('D:\papers\Images\3_result\0921-LCC.bmp')); %载入真彩色图像
% i = imread('xcorr2ex.png');
i=rgb2gray(i); %转换为灰度图
i=double(i);  %将uint8型转换为double型，否则不能计算统计量
% sq1=var(i,0,1); %列向量方差，第二个参数为0，表示方差公式分子下面是n-1,如果为1则是n
% sq2=var(i,0,2); %行向量方差
avg=mean2(i);  %求图像均值
[m,n]=size(i);
s=0;
for x=1:m
    for y=1:n
    s=s+(i(x,y)-avg)^2; %求得所有像素与均值的平方和。
    end
end
%求图像的方差
a1=var(i(:)); %第一种方法：利用函数var求得。
a2=s/(m*n-1); %第二种方法：利用方差公式求得
a3=(std2(i))^2; %第三种方法：利用std2求得标准差，再平方即为方差。

for i=1:6
    imwrite(G{i},['../lenaPyramid/G-',num2str(i),'.jpg']);
    imwrite(L{i},['../lenaPyramid/L-',num2str(i),'.jpg']);
end