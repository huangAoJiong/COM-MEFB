%%
I = load_images('D:/Papers/3/2/',3);
for i =1:5
    imwrite(I(:,:,:,i),['D:\zzzShare\image\2\',int2str(i),'.jpg']);
end
%%
close all
clear
clc
warning off all;

addpath('./metrics');
addpath('./util');
addpath('./methods');

path = 'D:\Papers\3\大论文对比试验';
fusedPath = [path '\大论文对比方法-3-Model\'];
outputPath = [path '\大论文对比方法-3-Model-评价指标结果\'];
outputPathSingle = [path '\evaluation_metrics_single2\'];

if ~exist(outputPath,'dir')
    mkdir(outputPath);
end

% if ~exist(outputPathSingle,'dir')
%     mkdir(outputPathSingle);
% end



methods = configMethods;
metrics = working_configMetrics;

numMethods=length(methods);
numMetrics=length(metrics);

% resultsMetrics = zeros(numImgs, numMethods, numMetrics);


[ResImg,ResImgName] = load_images(fusedPath);
I = load_images('D:\Papers\3\自拍模型\RGB');
% I = load_images('D:\Papers\3\3');

% FimgPath = 'D:\Papers\3\res_2\single_2_LCC_end_fused.bmp';
% the_F_img = imread(FimgPath);the_F_img = the_F_img(:,:,1);

% output information
fid=fopen(strcat(path, '\working-information.txt'),'w');
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
for k=1:size(ResImg,4)
    sFused = ResImg(:,:,:,k);
    [~, FimgName, FimgExt] = fileparts(ResImgName{1}(k).name);
    
    %     if ~(exist('my_assess', 'var') && (ismember(FimgName,{my_assess.imgName})))
    if ~(exist('Assessed_save', 'var') && (ismember(FimgName,{Assessed_save.imgName})))
        a=a+1;
        my_assess(a).imgName = FimgName;
        % 循环计算每一种指标
        for idxMetrics = 1:numMetrics
            % 更新进度条
            progress = idxMetrics / numMetrics;  % 计算进度
            %             progress = (idxMetrics + (k - 1) * numMetrics) / (numMetrics * size(ResImg, 4));  % 计算进度
            waitbar(progress, progressBar, sprintf('正在处理第 %d/%d 张图像... (%.2f%%)', k,size(ResImg,4), progress * 100));
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
%         Assessed_save(length(Assessed_save)+1) = my_assess(a);
    else
        disp(['跳过图像',FimgName,'的客观评价计算']);
    end
end
% 关闭进度条
close(progressBar);
% % 构造输出文件路径
% outputFile = strcat(outputPath, 'my_assess.mat');
% % 保存 my_assess 到 outputFile == my_assess.mat 文件中
% save(outputFile,'my_assess');
try
    if a == 0
        disp('无新的融合图像需要计算保存客观评价指标');
    else
       for i=1:length(my_assess)
           Assessed_save(length(Assessed_save)+1) = my_assess(i);
       end
       save([outputPath,'Assessed_save.mat'],'Assessed_save');
    end
catch err
    disp(['加载上一代数据文件出错，可能不存在上一代数据文件:',err.message,'\n现在另存']);
    if ~exist('Assessed_save', 'var')
        Assessed_save = my_assess;
        save([outputPath,'Assessed_save.mat'],'Assessed_save');
    end
end


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
http('客观评价指标计算完成……','私聊');

