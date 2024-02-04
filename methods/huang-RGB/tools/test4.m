% clear;
close all
gray = imread('D:\papers\Images\3\3.bmp');

% gray = rgb2gray(gray);
gray = R;
gray = im2double(gray);
gray = rgb2hsv(gray);
gray_inv = 1 - gray(:,:,3);
mask = fspecial('average',[15 15]);
m = imfilter(gray_inv,mask);
lcc = 1 * ((gray(:,:,3) / 1) .^ (2 .^((0.5 - m) / 0.5)));         


imshow([gray(:,:,3) m lcc]);impixelinfo
gray(:,:,3) = lcc;
figure,imshow(hsv2rgb(gray))

%{

A1=imread('car.png');
w=str2double(inputdlg('请输入滤波窗口大小', 'INPUT scale factor', 1, {'2'}));
z=(2*w+1)*(2*w+1);
%A2=imnoise(A1,'salt & pepper',0.01);
%A2=rgb2gray(A2);
[nrows,ncols,ncoms]=size(A1);
OUT = uint8(zeros(nrows,ncols,ncoms));%输出图像
if(ncoms==1)
    S=zeros(nrows,ncols);
    S(1,1)=A1(1,1);
    for u=2:nrows
        S(u,1)=S(1,1)+A1(u,1);
    end    
    for u=1:nrows
       for v=2:ncols
         S(u,v)=S(u,v-1)+sum(A1(1:u,v));          
       end
    end
    t=S(3,2)/6;
  for v=1:ncols-w
      for i=1:w+1
        for j=0:w
            OUT(i,v+j)=S(i,v+j)/(i*(v+j));            
        end        
      end    
  end
for v=1:ncols-w+1
    for i=nrows-w+1:nrows
        for j=0:w-1
           OUT(i,v+j)=S(i,v+j)/(i*(v+j));            
        end        
    end    
end
for u=w+2:nrows-w-w
    for i=0:w
        for j=1:w+1
            OUT(u+i,j)=S(u+i,j)/((u+i)*j);            
        end
    end
end
for u=w+2:nrows-w-w+1
    for i=0:w-1
        for j=ncols-w+1:ncols
            OUT(u+i,j)=S(u+i,j)/((u+i)*j);            
        end
    end
end
for u=w+2:nrows-w
    for v=w+2:ncols-w
        OUT(u,v)=(1/z)*(S(u+w,v+w)+S(u-w-1,v-w-1)-S(u+w,v-w-1)-S(u-w-1,v+w));        
    end
end
end
 
 
if(ncoms==3)
R = A1(:,:,1);
G = A1(:,:,2);
B = A1(:,:,3);
%输出图像的RGB分量
RR = uint8(zeros(nrows,ncols));
GG = uint8(zeros(nrows,ncols));
BB = uint8(zeros(nrows,ncols));
%各分量上的积分量
Sr =zeros(nrows,ncols);
Sg =zeros(nrows,ncols);
Sb =zeros(nrows,ncols);
Sr(1,1)=R(1,1);
Sg(1,1)=G(1,1);
Sb(1,1)=B(1,1);
for u=2:nrows
    Sr(u,1)=Sr(u-1,1)+R(u,1);
    Sg(u,1)=Sg(u-1,1)+G(u,1);
    Sb(u,1)=Sb(u-1,1)+B(u,1);
end
for u=1:nrows
    for v=2:ncols
        Sr(u,v)=Sr(u,v-1)+sum(R(1:u,v));
        Sg(u,v)=Sg(u,v-1)+sum(G(1:u,v));
        Sb(u,v)=Sb(u,v-1)+sum(B(1:u,v));        
    end
end
%边界处理
for v=1:ncols-w
    for i=1:w+1
        for j=0:w
            RR(i,v+j)=Sr(i,v+j)/(i*(v+j));
            GG(i,v+j)=Sg(i,v+j)/(i*(v+j));
            BB(i,v+j)=Sb(i,v+j)/(i*(v+j));            
        end        
    end    
end
for v=1:ncols-w+1
    for i=nrows-w+1:nrows
        for j=0:w-1
            RR(i,v+j)=Sr(i,v+j)/(i*(v+j));
            GG(i,v+j)=Sg(i,v+j)/(i*(v+j));
            BB(i,v+j)=Sb(i,v+j)/(i*(v+j));
        end        
    end    
end
for u=w+2:nrows-w-w
    for i=0:w
        for j=1:w+1
            RR(u+i,j)=Sr(u+i,j)/((u+i)*j);
            GG(u+i,j)=Sg(u+i,j)/((u+i)*j);
            BB(u+i,j)=Sb(u+i,j)/((u+i)*j);
        end
    end
end
for u=w+2:nrows-w-w+1
    for i=0:w-1
        for j=ncols-w+1:ncols
            RR(u+i,j)=Sr(u+i,j)/((u+i)*j);
            GG(u+i,j)=Sg(u+i,j)/((u+i)*j);
            BB(u+i,j)=Sb(u+i,j)/((u+i)*j);
        end
    end
end
for u=w+2:nrows-w
    for v=w+2:ncols-w
        RR(u,v)=(1/z)*(Sr(u+w,v+w)+Sr(u-w-1,v-w-1)-Sr(u+w,v-w-1)-Sr(u-w-1,v+w));
        GG(u,v)=(1/z)*(Sg(u+w,v+w)+Sg(u-w-1,v-w-1)-Sg(u+w,v-w-1)-Sg(u-w-1,v+w));
        BB(u,v)=(1/z)*(Sb(u+w,v+w)+Sb(u-w-1,v-w-1)-Sb(u+w,v-w-1)-Sb(u-w-1,v+w));
    end
end
OUT(:,:,1) = RR;
OUT(:,:,2) = GG;
OUT(:,:,3) = BB;
end
imshow(A1),title('原图');
figure;
%imshow(A1),title('加噪声后的图片');
%figure;
imshow(OUT),title('均值滤波后的图片');
%}