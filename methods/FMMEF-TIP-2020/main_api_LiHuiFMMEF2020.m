function [R] = main_api_2020LiHuiFMMEF(I)
%MAIN_API 此处显示有关此函数的摘要
%   此处显示详细说明
addpath(genpath(pwd));

imgSeqColor = I;      

%% fusion as static
r1=4;
[ D1,i_mean1,aa1,N1] = scale_fine(imgSeqColor,r1);

%% the intermediate  scale
[w,h,~,~]=size(imgSeqColor);
nlev = floor(log(min(w,h)) / log(2))-5;

D2 = cell(nlev,1);
aa2= cell(nlev,1);
N2= cell(nlev,1);

r2=4;
for ii=1:nlev
    [ D2{ii},i_mean2,aa2{ii},N2{ii}] = scale_interm(i_mean1,r2);
    i_mean1=i_mean2;
end


%% the coarsest  scale
r3=4;
[fI3,i_mean3,aa3,N3] = scale_coarse(i_mean2,r3);

%% reconstruct
%% Intermediate layers
for ii=nlev:-1:1
    temp=aa2{ii};
    fI=zeros(size(temp));
    fI(1:2:size(temp,1),1:2:size(temp,2))=fI3;
    B2=boxfilter(fI, r2)./ N2{ii}+D2{ii};
    
    fI3=B2;
end
%% finest layers
fI=zeros(size(aa1));
fI(1:2:size(aa1,1),1:2:size(aa1,2))=B2;
B1=boxfilter(fI, r1)./ N1;
C_out=repmat(B1,[1 1 3])+D1;

R = C_out;
end

