% 绘制直方图
function plotHistogray(imgGray)
    [r,c]=size(imgGray);
    imgGray = double(imgGray)/255;
    N = r*c;
    t1 = 0:1/N :(N-1)/N;
    for i = 1 : N
        sz(i) = imgGray(i)*255;
    end
    figure
    plot(t1,sz);
    title('对应直方图');
   %{
    figure
    subplot(121)
	imshow(imgGray);
    title('原灰度图');
    subplot(122)
    plot(t1,sz);
    title('对应直方图');
    %}