close all
clear
I= load_images('D:\papers\Images\3');
[R,C,~,N] = size(I);
I_v = zeros(size(I,1),size(I,2),size(I,4));
lapls_soble = [0, -1, 0;-1, 4, -1;0, -1, 0];
% L_space = imfilter(space,lapls_soble);
for n=1:size(I,4)
    temp = rgb2hsv(I(:,:,:,n));
    I_v(:,:,n) = temp(:,:,3);
end
I_v_gammer = zeros(R,C,N);
I_v_temp = I_v;
keySet=(0.02:0.01:0.5);
len=length(keySet);
keySet2=cell(1,len);
for i=1:len
    keySet2(i)=cellstr(num2str(keySet(i)));
end
valueSet=maptorange(0.02:0.01:0.5,[0.02,0.5],[0.35,1.5]);
M = containers.Map(keySet2,valueSet);
I_v_lcc = zeros(R,C,N);
for  s=1:5
    for i =1:R
        for j=1:C
%             I_v(i,j,s) = I_v(i,j,s) .^M(I_v(i,j,s));
            if(I_v(i,j,s)>=0.02 && I_v(i,j,s)<=0.5)
                t = I_v(i,j,s); 
                t=roundn(t,-2);
                I_v(i,j,s) = I_v(i,j,s) .^M(num2str(t));
%                 I_v(i,j,s) = I_v(i,j,s) .^.45;
            end
        end
    end
    gray = I_v(:,:,s);
    gray_inv = 1 - gray;
    mask = fspecial('average',[50 50]);
    m = imfilter(gray_inv,mask);
    I_v_lcc(:,:,s) = 1 * ((gray / 1) .^ (2 .^((0.5 - m) / 0.5)));
end

figure,imshow([I_v_temp(:,:,1) I_v_temp(:,:,2) I_v_temp(:,:,3) I_v_temp(:,:,4) I_v_temp(:,:,5) ]),title('原图亮度'),impixelinfo
figure,imshow([I_v(:,:,1) I_v(:,:,2) I_v(:,:,3) I_v(:,:,4) I_v(:,:,5)]),title('自适应伽马增强亮度'),impixelinfo;
figure,imshow([I_v_lcc(:,:,1) I_v_lcc(:,:,2) I_v_lcc(:,:,3) I_v_lcc(:,:,4) I_v_lcc(:,:,5)]),title('自适应2.0伽马增强亮度'),impixelinfo;
% figure,imshow([pca_t(:,:,1) pca_t(:,:,2) pca_t(:,:,3) pca_t(:,:,4) pca_t(:,:,5)]),title('pca后-亮度'),impixelinfo;

sa = I_saliency(I);
% sa = abs(sa-1);
% figure,imshow([sa(:,:,1) sa(:,:,2) sa(:,:,3) sa(:,:,4) sa(:,:,5)]),title('显著权重'),impixelinfo;
my_saliency_v = sa.*I_v_lcc;
% my_saliency_v = I_v;
my_saliency_v_sum = sum(my_saliency_v,3);

%➗5
% a = double(my_saliency_v_sum<=1);
% a1 = 4*a+1;
% my_saliency_v_sum = (a1.*my_saliency_v_sum)/5;

res = imread('D:\papers\Images\3_result\saliency_result.bmp');
res1 = imread('D:\papers\Images\3_result\addPca_0_5_bio.bmp');
 


res_temp = rgb2hsv(res);
figure,imshow([res_temp(:,:,3) my_saliency_v_sum]),impixelinfo,title('亮度替换前后对比')
res_temp(:,:,3) = my_saliency_v_sum;
% res_temp(:,:,3) = (sum(I_v_temp,3)/5).^.45;
res2 = hsv2rgb(res_temp);
result = imread('D:\papers\Images\3_result\result.bmp');
res2 = uint8(res2*255);
% for r=1:R
%     for c=1:C
%         if (res2(r,c,3) == 0) && (res2(r,c,2) == 0)
%             res2(r,c,1)=0;   
%         end
%     end
% end
figure,imshow([res res1 res2 result]),title('propose1——bio0.5——propose2——edd');impixelinfo
value_test2(I,res2);








