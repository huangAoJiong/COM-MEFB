close all
I= load_images('D:\papers\Images\3');
N = size(I,4);
target = I(284:714,450:880,:,:);%中心区域
r = target(:,:,1,:);
g = target(:,:,2,:);
b = target(:,:,3,:);

% for i=1:3
%     plotHistogray(res1(:,:,i));
% end

imshow(target(:,:,:,5).^.6)
