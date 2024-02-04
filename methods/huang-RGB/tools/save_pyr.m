for i=1:size(W,3)
%     figure,imshow(A(1).pyrW{i});
%     imwrite(A(1).pyr{i},['../算法框架/pyr-',num2str(i),'-',num2str(size(A(1).pyr{i},1)),'.bmp']);
    imwrite(W(:,:,i),['../算法框架/W-',num2str(i),'.bmp']);
end