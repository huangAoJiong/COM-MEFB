
function pyr = gif_gau_pyramid(I, radius, eps, nlev)

r = size(I,1);
c = size(I,2);
k = size(I,3);

if ~exist('nlev')
    %compute the highest possible pyramid
    nlev = floor(log(min(r,c)) / log(2));
end

% start by copying the image to the finest level
pyr = cell(nlev,1);
pyr{1} = I;

% recursively downsample the image
% filter = pyramid_filter;
for l = 2:nlev
    for m = 1:k
        I(:,:,m) = guidedfilter(I(:,:,m), I(:,:,m), radius, eps);
    end
%     I = downsample(I,filter);
    I = I(1:2:end, 1:2:end, :  );
    pyr{l}= I;
end