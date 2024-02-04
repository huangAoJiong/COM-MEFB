function F_img = run_DEM(sA,sB,outputPath,m,visualization)
%%为MEFB写的接口函数，修改了main

II(:,:,:,1) = im2double(imread(sA.img));
II(:,:,:,2) = im2double(imread(sB.img));
%%%resort
[h,w,c]= size(sA);
for ii = 1:2
    meann(ii) = mean(mean(mean(II(:,:,:,ii))));
end
[mean2, index] = sort(meann);

for jj=1:2
    I(:,:,:,jj) = II(:,:,:,index(jj));
end

dst(:,:,1,:) = 0.299*I(:,:,1,:) + 0.587*I(:,:,2,:) + 0.114*I(:,:,3,:);
dst(:,:,2,:) = -0.147*I(:,:,1,:) - 0.289*I(:,:,2,:) + 0.436*I(:,:,3,:);
dst(:,:,3,:) = 0.615*I(:,:,1,:) - 0.515*I(:,:,2,:)- 0.100*I(:,:,3,:);
[height,width,channel]=size(I(:,:,:,1));
clear temp;

tic
R=code_for_CSVT20191(dst,[1 1 1]);
runtime = toc;
FR(:,:,1)= R(:,:,1) + 1.14*R(:,:,3);  
FR(:,:,2)= R(:,:,1) - 0.39*R(:,:,2) - 0.58*R(:,:,3);   
FR(:,:,3)= R(:,:,1) + 2.03*R(:,:,2);

fprintf('the running time is %f\n', runtime);
% imshow(FR);
% write_path_root = 'your_save_dir/code_test/';
% write_path = [write_path_root,files(i).name,'.png'];
% 
% imwrite(FR,write_path);
F_img = FR;
end