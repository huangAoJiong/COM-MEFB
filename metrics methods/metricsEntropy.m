% The source code is from the Internet
% The interface is modified by the author of MEFB to integrate it into MEFB. 
%
% V. Aardt and Jan, ?°„Assessment of image fusion procedures using entropy, image quality, and multispectral 
% classification,?°¿ Journal of Applied Remote Sensing, vol. 2, no. 1, p.023522, 2008.

function res = metricsEntropy(I,fused) 
res = entropy(fused);
end
