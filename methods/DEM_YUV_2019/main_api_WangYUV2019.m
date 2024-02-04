function [F] = main_api_2019WangYUV(List)
%MAIN_API 此处显示有关此函数的摘要
%   此处显示详细说明
II=List;
%%%resort
[h,w,c,n]= size(II);
for ii = 1:n
    meann(ii) = mean(mean(mean(II(:,:,:,ii))));
end
[mean2, index] = sort(meann);

for jj=1:n
    I(:,:,:,jj) = II(:,:,:,index(jj));
end

dst(:,:,1,:) = 0.299*I(:,:,1,:) + 0.587*I(:,:,2,:) + 0.114*I(:,:,3,:);
dst(:,:,2,:) = -0.147*I(:,:,1,:) - 0.289*I(:,:,2,:) + 0.436*I(:,:,3,:);
dst(:,:,3,:) = 0.615*I(:,:,1,:) - 0.515*I(:,:,2,:)- 0.100*I(:,:,3,:);
[height,width,channel]=size(I(:,:,:,1));
clear temp;

% tic
R=code_for_CSVT20191(dst,[1 1 1]);
% runtime = toc;
FR(:,:,1)= R(:,:,1) + 1.14*R(:,:,3);  
FR(:,:,2)= R(:,:,1) - 0.39*R(:,:,2) - 0.58*R(:,:,3);   
FR(:,:,3)= R(:,:,1) + 2.03*R(:,:,2);

% fprintf('the running time is %f\n', runtime);
% imshow(FR);

F=FR;
end

