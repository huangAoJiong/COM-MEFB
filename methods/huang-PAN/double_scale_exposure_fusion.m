function F = double_scale_exposure_fusion(I,I_seg,wls_para)
if(~exist('wls_para', 'var'))
    wls_para = 1;
end
[r,c,n] = size(I);
I_D = zeros(r,c,n);
I_B = zeros(r,c,n);
for i=1:n
%     I_B(:,:,i) = wlsFilter(I(:,:,i), wls_para);
    I_B(:,:,i)=Adaptive_Weighted_Guided_Image_Filtering(I(:,:,i),I(:,:,i),11,400,CalculateWeightingFactor_PixBased(I(:,:,i)));
end
I_D = I-I_B;
I_D_temp = I_D >0;
I_D(I_D_temp==0) = 0;
if(~exist('I_seg', 'var'))
    I_B_f = exposure_fusion_My(I);
else
    I_B_f = exposure_fusion(I_B,I,I_seg);
end
I_D_f = fusion_detail(I_D);
% I_D_f=LCC(I_D_f);
% F = max(min(0,I_B_f+I_D_f),1);
F=I_B_f+I_D_f;
end

function [D_f, D] = fusion_detail(I)
[r,c,n] = size(I);
D = zeros(r,c,n);
D_f=zeros(r,c);
for i=1:n
    D(:,:,i) = MultiScaleDetailBoosting(I(:,:,i));
    D_f=max(D_f,D(:,:,i));
end
end