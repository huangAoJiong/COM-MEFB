function display_w(w)
[~,~,N] = size(w);
figure
for i=1:N
    subplot(1,N,i),imshow(w(:,:,i))
%     imwrite(w(:,:,i),['./signifienceImage/',num2str(i),'_signMy.bmp']);
end
end