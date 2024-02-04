% ����ֱ��ͼ
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
    title('��Ӧֱ��ͼ');
   %{
    figure
    subplot(121)
	imshow(imgGray);
    title('ԭ�Ҷ�ͼ');
    subplot(122)
    plot(t1,sz);
    title('��Ӧֱ��ͼ');
    %}