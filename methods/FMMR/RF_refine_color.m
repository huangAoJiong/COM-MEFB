function [ Q ] = RF_refine_color( I,SF,r,eps )
N=size(I,4);
for i=1:N
mono = double(I(:,:,:,i));
w = double(SF(:,:,i));
q(:,:,i) = RF(w, r, eps, 3, mono);
end
Q = q + 10^-25; %avoids division by zero
Q = Q./repmat(sum(Q,3),[1 1 N]);
end
