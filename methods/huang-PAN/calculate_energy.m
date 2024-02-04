function en_line = calculate_energy(I)
N = size(I,3);
en_line = zeros(256,N);
for k=1:N
   neighborhoodSize = 3;
   grayImage = I(:,:,k);
tic
% 将输入图像传输到GPU数组
% grayImageGPU = gpuArray(grayImage);
grayImageGPU = (grayImage);

% 获取图像的尺寸
[m, n] = size(grayImage);

% 初始化能量曲线为GPU数组
% energyCurve = zeros(256, 1, 'gpuArray');
energyCurve = zeros(256, 1);

% 创建进度条
progressBar = waitbar(0, '计算能量曲线...', 'Name', '进度');
% 在GPU上进行计算
for l = 0:255
%     energy = 0;
    % 计算能量项
    bMatrix = (grayImageGPU > l) * 2 - 1;
    shiftedBMatrix = -circshift(bMatrix, [0, 1]) + circshift(bMatrix, [1, 1]);
    energy = -sum(sum(bMatrix .* shiftedBMatrix));
    
    % 更新能量曲线
    energyCurve(l+1) = energy;

    % 更新进度条
    progress = l / 255;  % 计算进度
    waitbar(progress, progressBar, sprintf('计算能量曲线... (%d%%)', round(progress * 100)));
end

% 关闭进度条
close(progressBar);
en_line(:,k) = energyCurve;
en_line(:,k) = en_line(:,k)/max(en_line(:,k));
end
end