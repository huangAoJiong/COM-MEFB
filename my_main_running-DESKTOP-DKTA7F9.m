close all
clear
clc
warning off all;

addpath('./util');

addpath(['./methods'])
path = 'D:\MatlabCode\MEFB-main\output';
outputPath = [path '\fused_images\'];
simpleImgPath = 'D:\Papers\3\2\';

imgs = configImgs;

methods=configMethods;

numImgs=length(imgs);
numMethods=length(methods);

if ~exist(outputPath,'dir')
    mkdir(outputPath);
end

visualization = 0;
[I,~,Iclass] = load_images(simpleImgPath);
for idxMethod=1:1
    m = methods{idxMethod};
    t1 = clock;

    j =0;
%     for idxImgs=1:length(imgs)
    for idxImgs=1:1
        s = imgs{idxImgs};
        s.ext=Iclass;
        % check whether the result exists
        if exist([outputPath s.name '_' m.name '.' s.ext])
            continue;
        end
        myfuncName = ['img = run_' m.name '_my(I);'];
        try
            cd(['./methods/' m.name]);
            addpath(genpath('./'))            
            eval(myfuncName);
            j=j+1;
            
        catch err
            disp('error');
            rmpath(genpath('./'))
            cd('D:\MatlabCode\MEFB-main\')
            continue;
        end
        
        imwrite(img, [outputPath '/' s.name '_' m.name '.' s.ext]);
        cd('D:\MatlabCode\MEFB-main');
    end
    
    t2=clock;
    runtimeAverage = etime(t2,t1)./j;
        
    str=['The total runtime of ' m.name ' is: ' num2str(etime(t2,t1)) 's'];
    disp(str)
    
    str=['The average runtime of ' m.name ' per image is: ' num2str(runtimeAverage) 's'];
    disp(str)
end