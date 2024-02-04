function L = Lmean(R2)
%R2 最好是uint8整型类型
r=R2(:,:,1);g=R2(:,:,2);b=R2(:,:,3);
l = r*0.299+g* 0.587 +b* 0.114;
L = sum(sum(l))/(1024*1024);
end