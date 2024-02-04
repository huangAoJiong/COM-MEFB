function [F] = main_api_2019NailaDSIFTGF(I)
I = uint8(I*255);
%MAIN_API 此处显示有关此函数的摘要
%   此处显示详细说明
F=DSIFT_exposure_fusion(I,16,1);
end

