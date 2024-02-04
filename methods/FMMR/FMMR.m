function [ F ] = FMMR(I,p,radius,blurdegree)
% Pls refer the paper "fast multi-exposure image fusion with median filter
% and recursive filter" by Shutao Li and Xudong Kang
% This code is last edited in 27 Jan 2013 and is only allowed for research
% purpose.
% Inputs: I - a color multi-exposure image sequence.
% Output: F - the fused image
% Parameter: p is a parameter which tells wether this image is captured in
% dynamic scenes %default [] 

% Peform histogram equalization
[r c bands N]=size(I);
I_eq=Heq(double(I));
cost1=contrast(double(I));
cost3=overunderexpose(I);
% if p==1 then the ghost removal function is open
if p==1
med_map=median(I_eq,4);
cost2=distance_map(I_eq,med_map,1,3,30); 
% color difference used for motion detection
Y=cost2.*cost3;
else
Y=cost3;
end
Y = Y + 1e-12; %avoids division by zero
Y = Y./repmat(sum(Y,3),[1 1 N]);
Z=ones(r,c,N);
Z(Y<1/N)=0; % Turn cost into one and zero map
[F]=RF_fusion_color(I,Z,cost1,radius,blurdegree);

