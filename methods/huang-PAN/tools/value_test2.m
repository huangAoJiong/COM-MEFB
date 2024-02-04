function value_test2(I,res2)
fprintf("信息熵 = %f\n",entropy(rgb2gray(res2)));
fprintf("NIQE = %f\n",niqe(res2));
fprintf("均值 = %f\n",mean2(res2));
fprintf("标准差 = %f\n",std2(res2));
fprintf("corr2相关系数 = %f\n",my_corr2_score(I,res2));
fprintf("SSIM相关系数 = %f\n",my_ssim_score(I,double(res2)/255));
end
