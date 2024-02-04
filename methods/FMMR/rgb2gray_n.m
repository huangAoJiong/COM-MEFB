function [ R ] = rgb2gray_n( I )
%RGB2GRAY_N Summary of this function goes here
%   Detailed explanation goes here
N=size(I,4);
for i=1:N
    mono=I(:,:,:,i);
    R(:,:,i)=rgb2gray((mono));
%     R(:,:,i)=medfilt2(R(:,:,i),[8 8]);
end

end

