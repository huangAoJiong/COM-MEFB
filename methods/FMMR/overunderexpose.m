function [ R ] = overunderexpose( I )
%OVERUNDEREXPOSE Summary of this function goes here
%   Detailed explanation goes here
I_gray=rgb2gray_n(I);
R=ones(size(I_gray));
I_gray=double(I_gray);
R((I_gray>=0.90)|(I_gray<=0.1))=0;
end