%{
ƽ���ݶȣ�average gradient��AG�������еط�ӳ
��ͼ���΢Сϸ�ڷ���ı��������ͬʱ���ܷ�ӳ
��ͼ��������任������������Ϊƽ���ݶ�Խ��
ͼ��������Խ�ã��ں�����Խ�á���ˣ�ƽ���ݶȺ�
�����ں�ͼ��������̶�.
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