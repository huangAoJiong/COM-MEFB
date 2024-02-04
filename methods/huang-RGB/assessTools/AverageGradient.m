%{
平均梯度（average gradient，AG）能敏感地反映
出图像对微小细节反差的表达能力，同时还能反映
出图像中纹理变换的特征。可认为平均梯度越大，
图像清晰度越好，融合质量越好。因此，平均梯度衡
量了融合图像的清晰程度.
%}
function [AG] = AverageGradient(readImage)
if(strcmp('char',class(readImage)))
    readImg=imread(readImage);
else
    readImg = readImage;
end
if(strcmp('double',class(readImg)))
    readImg=uint8(readImg*255);
end
chooseChannel = size(size(readImg));
if chooseChannel(2) == 3
    img = double(rgb2gray(readImg));   
else
    img = double(readImg);
end
[r,c,~] = size(img);
AG=0;
for i=1:r-1
    for j=1:c-1
        AG = AG + sqrt(((img(i+1,j)-img(i,j))^2+(img(i,j+1)-img(i,j))^2)/2);
    end
end

AG = AG/((r-1)*(c-1));

end