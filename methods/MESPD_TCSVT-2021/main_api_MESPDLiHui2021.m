function [F] = main_api_2021MESPDLiHui(I)
%MAIN_API_2021MESPD 此处显示有关此函数的摘要
%   此处显示详细说明

r=10;
 
  imgSeqColor = detection_color(I,r);
    r1=4;
    

    T=0.5;
    lambda=0.25;
    %% single scale
    % C_out= SPD_fast_single3(imgSeqColor,r,t,eps);
    %% multi-scale scale
    [ D1,i_mean1,aa1,N1] = scale_fine(imgSeqColor,r1,lambda);
    

    [w,h,~,~]=size(imgSeqColor);
nlev = floor(log(min(w,h)) / log(2))-5;

D2 = cell(nlev,1);
aa2= cell(nlev,1);
N2= cell(nlev,1);
    r2=4;


     lambda=lambda*T;

for ii=1:nlev
    [ D2{ii},i_mean2,aa2{ii},N2{ii}] = scale_interm(i_mean1,r2,lambda);
    i_mean1=i_mean2;
    lambda=lambda*T;

end

   
%% the coarsest  scale
    r3=3;
    t=1;

[fI3,i_mean3,aa3,N3] = scale_coarse(i_mean2,r3,lambda);

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
% C_out=repmat(B1,[1 1 3])+2/pi*atan(2.3*D1);
C_out=repmat(B1,[1 1 3])+D1;
F = C_out;
end

