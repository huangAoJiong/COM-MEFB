% The source code is from the authors of the metric (https://kedema.org/Publications.html)
% The interface is modified by the author of MEFB to integrate it into MEFB. 
% 
% Reference for the metric:
% K. Ma, K. Zeng, Z. Wang, Perceptual quality assessment for multi-exposure image fusion, IEEE Trans. Image 
% Process. 24 (11) (2015) 3345–3356.

function res= metricsMEF_SSIM(I,fused)
if strcmp(class(I), 'double')
    I = uint8(I*255);
end
if strcmp(class(fused), 'double')
    fused = uint8(fused*255);
end
% if ~(strcmp(class(I), class(fused)) && strcmp(class(fused), 'uint8'))
%     error('输入的两个参数不是uint8类型');
% end
    flag_plat = length(size(I));
    imgSeqColor = I;
    if flag_plat == 4
        [s1, s2, s3, s4] = size(imgSeqColor);
        imgSeq = zeros(s1, s2, s4);
        for i = 1:s4
            imgSeq(:, :, i) =  rgb2gray( squeeze( imgSeqColor(:,:,:,i) ) ); % color to gray conversion
        end
        fI1 = fused; 
        fI1 = double(rgb2gray(fI1));
        [Q(1), Qs1, QMap1] = mef_ms_ssim(imgSeq, fI1);
        res = Q;
    
    elseif flag_plat == 3

        [s1, s2, s4] = size(imgSeqColor);
        imgSeq = zeros(s1, s2, s4);
        for i = 1:s4
            imgSeq(:, :, i) =   squeeze( imgSeqColor(:,:,i) ); % color to gray conversion
        end
        fI1 = fused; 
        fI1 = double(fI1);
        [Q(1), Qs1, QMap1] = mef_ms_ssim(imgSeq, fI1);
        res = Q;
    end
end