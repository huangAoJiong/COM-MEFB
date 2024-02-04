
close all
clear
clc
warning off all;

addpath('./metrics');
addpath('./util');
addpath('./methods');

path = 'D:\MatlabCode\MEFB-main\output';
fusedPath = [path '\fused_images\'];
outputPath = [path '\evaluation_metrics\'];
outputPathSingle = [path '\evaluation_metrics_single2\'];

if ~exist(outputPath,'dir')
    mkdir(outputPath);
end

if ~exist(outputPathSingle,'dir')
    mkdir(outputPathSingle);
end

imgs = configImgs;

methods = configMethods;
metrics = configMetrics;

numImgs=length(imgs);
numMethods=length(methods);
numMetrics=length(metrics);

I = load_images('D:\Papers\3\2');
% the_F_img = imread('D:\Papers\3\3\监视50m帧计数19362_曝光时间6.4ms_时标0s_register.tif');
FimgPath = 'D:\MatlabCode\SingleFusion\single_3_2_fused.bmp';
the_F_img = imread(FimgPath);

% output information
fid=fopen(strcat(path, '\information.txt'),'w');
fprintf(fid,'%15s\r\n','The image paris are:');

fprintf(fid,'%15s\r\n','');
fprintf(fid,'%15s\r\n','The methods are:');


fprintf(fid,'%15s\r\n','');
fprintf(fid,'%15s\r\n','The metrics are:');
%计算融合图像质量的算法名字
for i=1:numMetrics
    fprintf(fid,'%15s\r\n', metrics{i}.name);
end
fclose(fid);

Asualization = 0;
resultsMetrics = zeros(numImgs, numMethods, numMetrics);
%创建保存的结构体
my_assess = struct;
my_assess_list(numMetrics)=-1;
[~, FimgName, FimgExt] = fileparts(FimgPath);
my_assess.imgName = FimgName;
for idxMetrics = 1:numMetrics
    
    sMetrics = metrics{idxMetrics};
    sFused = the_F_img;
    
    disp([num2str(idxMetrics) '_' sMetrics.name])
    
    funcName = ['res = metrics' sMetrics.name '(I,sFused);'];
    disp(funcName)
    
    try
        cd(['./metrics methods/']);
        addpath(genpath('./'))
        
        eval(funcName);
        my_assess_list(idxMetrics) = res;
    catch err
        disp('error');
        rmpath(genpath('./'))
        cd('D:\MatlabCode\MEFB-main')
        continue;
    end
    my_assess.(sMetrics.name) = res;
    cd('../');
    
end

outputFile = strcat(outputPath, 'my_assess.mat');
% save(outputFile,'my_assess');

% compute the average value of each metric on all image paBs
% resultsMetricsAverageImg = nanmean(resultsMetrics,1); 
% outputFileAverage = strcat(outputPath, 'evaluationMetricsAverageImg.mat');
% save(outputFileAverage,'resultsMetricsAverageImg');
