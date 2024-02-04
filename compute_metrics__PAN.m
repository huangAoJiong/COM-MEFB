
close all
clear
clc
warning off all;

addpath('./metrics');
addpath('./util');
addpath('./methods');

path = 'D:\Papers\3\大论文对比试验';
fusedPath = [path '\大论文对比方法-pan-model\'];
outputPath = [path '\大论文对比方法-pan-model-评价指标结果\'];
% outputPathSingle = [path '\evaluation_metrics_single2\'];

if ~exist(outputPath,'dir')
    mkdir(outputPath);
end

tic
% if ~exist(outputPathSingle,'dir')
%     mkdir(outputPathSingle);
% end



methods = configMethods;
metrics = working_configMetrics;

numMethods=length(methods);
numMetrics=length(metrics);


[ResImg,ResImgName] = load_images(fusedPath);
% I = load_images('D:\Papers\3\11');
I = load_images('D:\Papers\3\自拍模型\gray-pan');

% FimgPath = 'D:\Papers\3\res_2\single_2_LCC_end_fused.bmp';
% the_F_img = imread(FimgPath);the_F_img = the_F_img(:,:,1);

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
% sim
%创建保存的结构体
my_assess = struct;
try
    load([outputPath,'Assessed_save.mat'])
catch
    disp(['不存在文件：',outputPath,'Assessed_save.mat'])
end
% [~, FimgName, FimgExt] = fileparts(FimgPath);
% my_assess.imgName = FimgName;
a=0;
% 创建进度条
progressBar = waitbar(0, '计算客观评价指标...', 'Name', '进度');
% 循环每一张融合图像——
for k=1:size(ResImg,3)
    sFused = ResImg(:,:,k);
    [~, FimgName, FimgExt] = fileparts(ResImgName{1}(k).name);
    
%     if ~(exist('my_assess', 'var') && (ismember(FimgName,{my_assess.imgName})))
    if ~(exist('Assessed_save', 'var') && (ismember(FimgName,{Assessed_save.imgName}))) 
        a=a+1;
        disp(['++++++++++++++++++++++++++++++++++++++++++++++++++++++++现在第',num2str(k),'个已经测试开始'])
        my_assess(a).imgName = FimgName;
        for idxMetrics = 1:numMetrics
            % 更新进度条
            progress = idxMetrics / numMetrics;  % 计算进度
%             progress = (idxMetrics + (k - 1) * numMetrics) / (numMetrics * size(ResImg, 4));  % 计算进度
            waitbar(progress, progressBar, sprintf('正在处理第 %d/%d 张图像... (%.2f%%)', k,size(ResImg,3), progress * 100));
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
                disp(['error',err.message]);
                rmpath(genpath('./'))
                cd('D:\MatlabCode\MEFB-main')
                continue;
            end
            my_assess(a).(sMetrics.name) = res;
            cd('../');
            
        end
        
    end
    disp(['++++++++++++++++++++++++++++++++++++++++++++++++++++++++现在第',num2str(k),'个已经测试完成'])
    
end
% 关闭进度条
close(progressBar);
% % 构造输出文件路径
% outputFile = strcat(outputPath, 'my_assess.mat');
% % 保存 my_assess 到 outputFile == my_assess.mat 文件中
% save(outputFile,'my_assess');
try
    % 从 outputPath 加载 Assessed.mat 文件
    load([outputPath,'Assessed_save.mat']);
    % 如果 my_assess.imgName 不在 Assessed.imgName 中
    if a==0
        disp('所有融合图像已经测试完毕，无新的图像需要测试');
    elseif ~ismember(my_assess.imgName,{Assessed_save.imgName})
        Assessed_save(length(Assessed_save)+1) = my_assess;
        save([outputPath,'Assessed_save.mat'],'Assessed_save');
    end
catch err
    disp(['加载上一代数据文件出错，可能不存在上一代数据文件:',err.message]);
    try
        Assessed_save = my_assess;
        save([outputPath,'Assessed_save.mat'],'Assessed_save');
        disp('运行完毕、保存成功');
    catch err2
        disp(err2.message);
    end
end
% % compute the average value of each metric on all image paBs
% resultsMetricsAverageImg = nanmean(resultsMetrics,1);
% outputFileAverage = strcat(outputPath, 'evaluationMetricsAverageImg.mat');
% save(outputFileAverage,'resultsMetricsAverageImg');
%% 保存为excel
try
    % 2. 指定要保存的 Excel 文件名
    filename = [outputPath,'output.xlsx'];
    % 将结构体转换为表格
    myTable = struct2table(Assessed_save);
    % 格式化要保存的数据，保留四位小数
    myTable{:, 2:end} = round(myTable{:, 2:end}, 4);
    % 保存表格到Excel文件
    writetable(myTable, filename);
    disp(['结构体已保存到Excel文件: ' filename]);
catch err_excel
    disp(err_excel.message);
end
%%
toc
http('客观评价指标计算完成……','私聊');

