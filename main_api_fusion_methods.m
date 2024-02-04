% fileID = fopen('D:\MatlabCode\main_api.txt', 'r');
% tline = fgetl(fileID);
% while ischar(tline)
% %     disp(tline);
% %     eval(tline);
%     tline = fgetl(fileID);
% end
% fclose(fileID);
close all;
clear all;
clc;

% 假设你已经将文件内容读取到一个单元格数组中
Paths = {
    'D:\MatlabCode\MEFB-main/methods/DEM_YUV_2019/main_api_WangYUV2019(I)';
    'D:\MatlabCode\MEFB-main/methods/FMMEF-TIP-2020/main_api_LiHuiFMMEF2020(I)';
    'D:\MatlabCode\MEFB-main/methods/FMMR/main_api_LiFast2012(I)';
    'D:\MatlabCode\MEFB-main/methods/DSIFT_EF/main_api_LiuYuDSIFT2015(I)';
    'D:\MatlabCode\MEFB-main/methods/Ghost-Free-MEF-using-DSIFT-and-GF/main_api_NailaDSIFTGF2019(I)';
    'D:\MatlabCode\MEFB-main/methods/Mertens-MEF/main_api_Mertens(I)';
    'D:\MatlabCode\MEFB-main/methods/MESPD_TCSVT-2021/main_api_MESPDLiHui2021(I)';
    'D:\MatlabCode\MEFB-main/methods/PMEF-GFF/code/main_api_LiuPMEF2019(I)';
    'D:\MatlabCode\MEFB-main/methods/Lee-2018/code/main_api_Lee(I)';
    'D:\MatlabCode\MEFB-main/methods/PAS-MEF/main_api_KaraPAS2021(I)';
%     'D:\MatlabCode\MEFB-main/methods/huang-RGB/main_api_huangRGB(I)';
        'D:\MatlabCode\MEFB-main/methods/huang-PAN/main_api_huangSingleF(I)';
    };
close all;
%% 正则表达式规则
pattern = 'main_api_(.*?)\(I\)';

%% 融合图像序列加载
I = load_images('D:\Papers\3\自拍模型\gray-pan',3);

% I = load_images('D:\Papers\3\2',3);
mainPath = 'D:\MatlabCode\MEFB-main';
savePath = 'D:\Papers\3\大论文对比试验\大论文对比方法-pan-model\';
if ~exist(savePath,'dir')
    mkdir(savePath);
end
try
    [I_Res,I_Res_Name] = load_images(savePath);
    flag =1;
catch err
    disp(['该路径没有任何融合方法的结果:',err.message]);
    flag =0;
end
try 
    load('D:\Papers\3\大论文对比试验\Name_Method_Set.mat');
catch err_Set
    disp(err_Set.message);
end
%% 提取融合方法api
% 提取每行中最后一个斜杠（/）之前的内容
fileNames = cell(size(Paths));
filePath = cell(size(Paths));
% 创建进度条
progressBar = waitbar(0, '多曝光融合中......', 'Name', '进度');
for i = 1:numel(Paths)
    tic
    % 更新进度条
    progress = i / numel(Paths);
    waitbar(progress, progressBar, sprintf('融合进展... %d/%d%',i,numel(Paths)));
    [path, fileName, ~] = fileparts(Paths{i});
    methodName = regexp(fileName, pattern, 'tokens');
    %% 判断是否已经保存过该方法的结果
    %     [~, FimgName, FimgExt] = fileparts(I_Res_Name{1}(i).name);
    if (flag && ismember([Name_Method_Set.(cell2mat(methodName{1})),'.bmp'],{I_Res_Name{1}.name}))
        disp([cell2mat(methodName{1}),':跳过']);
        continue;
    end
    try
        loadApiPath = ['cd ',path];
        eval(loadApiPath);
        runApi = ['R = ' fileName ';'];
        eval(runApi);
        %         figure('Name',cell2mat(methodName{1})); imshow(R);
        %         imwrite(R(:,:,1),[savePath,cell2mat(methodName{1}),'.bmp']);
        disp(runApi);
        imwrite(R(:,:,1),[savePath, Name_Method_Set.(cell2mat(methodName{1})),'.bmp']);
%         imwrite(R(:,:,1),[savePath,cell2mat(methodName{1}),'.bmp']);
    catch err
        disp([runApi,'--error:',err.message]);
        %         disp(runApi);
    end
    cd(mainPath);
    toc
end
% 关闭进度条
close(progressBar);
% 显示提取出的内容
% disp(filePath);
%% body


