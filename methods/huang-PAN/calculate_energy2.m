function energyCurveEd = calculate_energy2(I,I_seg)
I_seg=uint8(I_seg*255);
% a_ = imread('D:\MatlabCode\Test\a_fenge.bmp');
neighborhoodSize = 1;

[m, n,N] = size(I);
energyCurveEd = zeros(256, N);
waitBar = waitbar(0,'绘制序列能量曲线','name','ploting');
for k=1:N
    grayImage = I(:,:,k);
    energyCurve = zeros(256, 1);
    spmd
        % 获取当前工作进程的索引
        labIndex = labindex();
        numWorkers = numlabs();
        
        % 计算每个工作进程负责处理的灰度级别范围
        numIterations = 256;
        localRange = labIndex:numWorkers:numIterations;
        
        localEnergyCurve = zeros(numIterations, 1);
        
        % 并行遍历灰度级别范围
        for l = localRange
            energy = 0;
            % 遍历图像中的每个像素
            for i = 1:m
                for j = 1:n
                    if I_seg(i, j,k) ==0
                        continue;
                    end                  
                    neighborhoodRange = max(1, i-neighborhoodSize):min(m, i+neighborhoodSize);
                    neighborhoodDomain = max(1, j-neighborhoodSize):min(n, j+neighborhoodSize);
                    
                    bMatrix = (grayImage(neighborhoodRange, neighborhoodDomain) > l) * 2 - 1;
                    
                    energy = energy - sum(sum(bMatrix .* circshift(bMatrix, [0, 1]))) + sum(sum(bMatrix .* circshift(bMatrix, [1, 1])));
                end
            end
            
            % 存储局部能量曲线
            localEnergyCurve(l) = energy;
        end
    end
    % 将能量曲线从主进程广播到各个工作进程
    for lab = 1:numel(localEnergyCurve)
        energyCurve=energyCurve + localEnergyCurve{lab};
    end
    % energyCurve = gop(@plus, energyCurve, 1);
    % 绘制能量曲线
    energyCurve = energyCurve/sum(energyCurve);
    waitbar(k/N, waitBar, sprintf('计算能量曲线... (%d%%)', round(k/N * 100)));
    energyCurveEd(:,k) = energyCurve;
   figure;
xlabel('灰度级别');
ylabel('能量');
title('能量曲线——不跳过非目标区域');
    plot(energyCurveEd(:,k));
end
close(waitBar);
close all;
% eval('add_energy_img');
end