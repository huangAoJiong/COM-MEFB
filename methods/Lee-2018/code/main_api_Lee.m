function F = main_api_2018Lee(I)

%% read multi-exposed rgb image sequence (scaling to [0,1])

%% compute luminance image of rgb image sequence 计算RGB图像序列的亮度图像
imgs_lum = rgb2lum(I);

%% compute weight1 using luminance distribution
w1 = get_weight1(imgs_lum);

%% compute weight2 using luminance gradient
w2 = get_weight2(imgs_lum);

%% corporate weight1 & weight2 and refine weight with wlsFilter
p1 = 1;
p2 = 1;
w = (w1.^p1).*(w2.^p2);
w = refine_weight(w);

%% fuse images using pyramid decomposition
lev = 7;
F = fusion_pyramid(I, w, lev);
end