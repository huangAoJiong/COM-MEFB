
close all
clear
clc
warning off all;

addpath('./metrics');
addpath('./util');
addpath('./methods');

path = 'D:\Papers\3\大论文对比试验';
fusedPath = [path '\大论文对比方法-3\test\'];
outputPath = [path '\大论文对比方法-3-评价指标结果\'];
outputPathSingle = [path '\evaluation_metrics_single2\'];

if ~exist(outputPath,'dir')
    mkdir(outputPath);
end

if ~exist(outputPathSingle,'dir')
    mkdir(outputPathSingle);
end



methods = configMethods;
metrics = configMetrics;

numMethods=length(methods);
numMetrics=length(metrics);

res_dir = 'D:\Papers\3\大论文对比试验\大论文对比方法-3';
[ResImg,ResImgName] = load_images(res_dir);
I = load_images('D:\Papers\3\3');

FimgPath = 'D:\Papers\3\res_2\single_2_LCC_end_fused.bmp';
the_F_img = imread(FimgPath);the_F_img = the_F_img(:,:,1);

% output information
fid=fopen(strcat(path, '\information.txt'),'w');
fprintf(fid,'%15s\r\n','The image paris are:');

fprintf(fid,'%15s\r\n','');
fprintf(fid,'%15s\r\n','The methods are:');
% FeatureSIM
fprintf(fid,'%15s\r\n','');
fprintf(fid,'%15s\r\n','The metrics are:');
%计算融合图像质量的算法名字
for i=1:numMetrics
    fprintf(fid,'%15s\r\n', metrics{i}.name);
end
fclose(fid);
sim
%创建保存的结构体
my_assess = struct;
try
    load([outputPath,'Assessed__2_2.mat'])
catch
    disp(['不存在文件：',outputPath,'Assessed__2_2.mat'])
end
% [~, FimgName, FimgExt] = fileparts(FimgPath);
% my_assess.imgName = FimgName;
a=1;
% 创建进度条
progressBar = waitbar(0, '计算客观评价指标...', 'Name', '进度');
for k=1:size(ResImg,3)
    sFused = ResImg(:,:,k);
    [~, FimgName, FimgExt] = fileparts(ResImgName{1}(k).name);
    
    if ~(exist('Assessed__2_2', 'var') && (ismember(FimgName,{Assessed__2_2.imgName})))
        disp(['++++++++++++++++++++++++++++++++++++++++++++++++++++++++现在第',num2str(k),'个已经测试开始'])
        my_assess(a).imgName = FimgName;
        tic
        for idxMetrics = 1:numMetrics
            % 更新进度条
            progress = (idxMetrics +(k-1)*numMetrics)/ (numMetrics*size(ResImg,3));  % 计算进度
            waitbar(progress, progressBar, sprintf('计算客观评价指标... (%d%%)', round(progress * 100)));
            %拿到一个指标名称
            sMetrics = metrics{idxMetrics};
            disp([num2str(idxMetrics) '_' sMetrics.name])
            %使用该指标计算的命令
            funcName = ['res = metrics' sMetrics.name '(I,sFused);'];
            disp(funcName)
            try
                cd(['./metrics methods/']);
                addpath(genpath('./'))
                %执行该指标的计算命令
                eval(funcName);
            catch err
                disp('error');
                rmpath(genpath('./'))
                cd('D:\MatlabCode\MEFB-main')
                continue;
            end
            my_assess(a).(sMetrics.name) = res;
            cd('../');
            
        end
        a=a+1;
    end
    disp(['++++++++++++++++++++++++++++++++++++++++++++++++++++++++现在第',num2str(k),'个已经测试完成'])
    toc
    
end
% 关闭进度条
close(progressBar);
% 构造输出文件路径
outputFile = strcat(outputPath, 'my_assess.mat');
% 保存 my_assess 到 outputFile == my_assess.mat 文件中
save(outputFile,'my_assess');
try
    % 从 outputPath 加载 Assessed.mat 文件
    load(outputPath,'Assessed.mat');
    % 如果 my_assess.imgName 不在 Assessed.imgName 中
    if ~ismember(my_assess.imgName,{Assessed.imgName})
        Assessed(length(Assessed)+1) = my_assess;
        save('D:\MatlabCode\MEFB-main\output\evaluation_metrics\Assessed.mat','Assessed');
    end
catch
    disp('加载上一代数据文件出错，可能不存在上一代数据文件');
end
% compute the average value of each metric on all image paBs
resultsMetricsAverageImg = nanmean(resultsMetrics,1);
outputFileAverage = strcat(outputPath, 'evaluationMetricsAverageImg.mat');
save(outputFileAverage,'resultsMetricsAverageImg');
