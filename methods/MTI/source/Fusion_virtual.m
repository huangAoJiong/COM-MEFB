function [final_virtual]=Fusion_virtual(s_h,h_s,I2,I1)
s_h=double(s_h);
h_s=double(h_s);
I1=double(I1);
I2=double(I2);
w1=fusion11(I1);
w2=fusion21(I2);
Is3=(I1.*s_h).^(0.5);
Ih3=(I2.*h_s).^(0.5);
final_virtual=(w1.*Is3+w2.*Ih3)./(w1+w2);
final_virtual=uint8(final_virtual);
final_virtual=double(final_virtual);
% imwrite(uint8(final_virtual),'finalimage\final_virtual.png');
% final_virtual=double(imread('finalimage\final_virtual.png'));
