function [F] = main_api_huangRGB(List)


addpath '.'/tools/
% addpath('D:\matlabCode\qualityEstimate\BRISQUE-main\MATLAB') % 添加BRISQUE评估指标路径：score = brisquescore(img);
addpath('assessTools\')

II = List;
[R,W] = exposure_fusion(II);

Rhsv = rgb2hsv(uint8(R*255));
Rhsv_3 = Rhsv(:,:,3);
Rhsv_3_lcc = LCC(Rhsv_3);

gama = Rhsv_3_lcc./Rhsv_3;
R1 = gama.*R;   %亮度比例替换后的RGB（R）

F=R1;
end

