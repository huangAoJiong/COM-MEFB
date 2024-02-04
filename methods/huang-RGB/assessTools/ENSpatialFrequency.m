% 空间频率（spatial frequency，SF）反映的是空间域内图像的总体活跃程度，即图像灰度的变化率。
function [ENSF] = ENSpatialFrequency(readImage)
% read clean image
if(strcmp('char',class(readImage)))
    readImg=imread(readImage);
else
    readImg = readImage;
end
if(strcmp('double',class(readImg)))
    readImg=uint8(readImg*255);
end
% readImg = imread(readImage);
chooseChannel = size(size(readImg));
if chooseChannel(2) == 3
    img = double(rgb2gray(readImg));
else
    img = double(readImg);
end
[r,c] = size(img);
RF = 0;
CF = 0;
MDF = 0;
SDF = 0;
rc = r * c;
Wb=1/sqrt(2);
for i=1:1:r
    for j = 2:1:c
        RF = RF + (img(i,j)-img(i,j-1))^2;
    end
end

for i=2:r
    for j = 1:1:c
        CF = CF + (img(i,j)-img(i-1,j))^2;
    end
end


for m=2:r
    for n = 2:1:c
        MDF = MDF + (img(m,n)-img(m-1,n-1))^2;
    end
end

for i=2:1:r
    for j = 1:1:c-1
        SDF = SDF + (img(i,j)-img(i-1,j+1))^2;
    end
end
RF = sqrt(RF/(rc));
CF = sqrt(CF/(rc));
MDF = sqrt(MDF*Wb/rc);
SDF = sqrt(SDF*Wb/rc);
ENSF=sqrt(RF^2+CF^2+MDF^2+SDF^2);
end