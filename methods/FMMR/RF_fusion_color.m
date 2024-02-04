function [ F_1 ] = RF_fusion_color( I,W,X,par1,par2)
%GUIDED_FUSION Summary of this function goes here
%   Detailed explanation goes here
[r,c,cl,N]=size(I);
[x labels]=max(X,[],3);
clear x;

for i=1:N
    mono=zeros(r,c);
    mono(labels==i)=1;
    X(:,:,i)=mono;
end
Weight=zeros(r,c,N);
Weight=X.*W;
Weight1=RF_refine_color(I,Weight,par1,par2); 
%the Recursive filtering based weight optimization step 
F_1=zeros(r,c,3);
for i=1:N
    w = repmat(Weight1(:,:,i),[1 1 3]);
    F_1=F_1+double(I(:,:,:,i)).*w;
end


