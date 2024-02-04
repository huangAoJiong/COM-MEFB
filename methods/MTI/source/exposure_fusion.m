function R = exposure_fusion(I,m,method)

%method = 2; 
BETA = 2; %%%test four different choices of BETA as 0, 1, 2, 3
fprintf('method = %d\n',method);
    
r = size(I,1);
c = size(I,2);
N = size(I,4);

nlev = floor(log(min(r,c)) / log(2))-BETA;
radius = 2^BETA; %60
eps = 1/1024;  %1/2048  8196 32768

%compute the measures and combines them into a weight map
contrast_parm = m(1);
sat_parm = m(2);
wexp_parm = m(3);

W = ones(r,c,N);
if (contrast_parm > 0)
    W = W.*contrast(I).^contrast_parm;
end
if (sat_parm > 0)
    W = W.*saturation(I).^sat_parm;
end
if (wexp_parm > 0)
    W = W.*well_exposedness(I).^wexp_parm;
end

%normalize weights: make sure that weights sum to one for each pixel
W = W + 1e-12;
W = W./repmat(sum(W,3),[1 1 N]);



if method==1 %%%Gaussian pyramid [paper 1]
    pyr = gaussian_pyramid(zeros(r,c,3),nlev);% an nlevel empty pyramid;
    for i = 1:N
        pyrW = gaussian_pyramid(W(:,:,i),nlev);  %the gaussian_pyramid decomposition of weight map 
        pyrI = laplacian_pyramid(I(:,:,:,i),nlev);%the gaussian_pyramid decomposition of input image
        for l = 1:nlev
            w = repmat(pyrW{l},[1 1 3]);
            pyr{l} = pyr{l} + w.*pyrI{l};        %same weighting of different channel of color?; 
        end
    end
    R = reconstruct_laplacian_pyramid(pyr);
elseif method==2 %%%GGIF pyramid ICME
    Y = 0.299*I(:,:,1,:)+0.587*I(:,:,2,:)+0.114*I(:,:,3,:);
    pyr = gaussian_pyramid(zeros(r,c,3),nlev);
    
    
    for i = 1:N
        tmp =  Y(:,:,i);
        W(:,:,i) = W(:,:,i)*(mean(tmp(:))^2);
    end
    W = W./repmat(sum(W,3),[1 1 N]);

    wsum = cell(nlev,1);
    for i = 1:N
        pyrW = gaussian_pyramid(W(:,:,i),nlev);
        pyrY = gaussian_pyramid(Y(:,:,i),nlev);
        pyrI = laplacian_pyramid(I(:,:,:,i),nlev);
        
        % all the layer of weights map used GIF guided by pyrI
        for l = 1:nlev
%              pyrW{l}=guidedfilter_WMSE_FixedRadius(pyrY{l}, pyrW{l}, radius, eps);
               pyrW{l}=gguidedfilter(pyrY{l}, pyrW{l}, radius, eps);
        end

        for l = 1:nlev
            % accumulate the weights map over different images 
            if i == 1 
                wsum{l}= pyrW{l}+ 1e-12;
            else
                wsum{l} = wsum{l}+pyrW{l}+1e-12;
            end
            % calc fuse pyramid
            w = repmat(pyrW{l}+ 1e-12,[1 1 3]);
            pyr{l} = pyr{l} + w.*pyrI{l};
        end
    end
    % normalize fuse pyramid
    for l = 1:nlev
        pyr{l} = pyr{l}./repmat(wsum{l},[1,1,3]);
    end
    % reconstruct
    R = reconstruct_laplacian_pyramid(pyr);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% contrast measure
function C = contrast(I)
h = [0 1 0; 1 -4 1; 0 1 0]; % laplacian filter
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = rgb2gray(I(:,:,:,i));
    C(:,:,i) = abs(imfilter(mono,h,'replicate'));
end

% saturation measure
function C = saturation(I)
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    % saturation is computed as the standard deviation of the color channels
    R = I(:,:,1,i);
    G = I(:,:,2,i);
    B = I(:,:,3,i);
    mu = (R + G + B)/3;
    C(:,:,i) = sqrt(((R - mu).^2 + (G - mu).^2 + (B - mu).^2)/3);%./255;
end

% well-exposedness measure
function C = well_exposedness(I)
sig = .2; %%%only the color of final image will be effected by the value of sig.
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);

for i = 1:N
    R = exp(-.4*(I(:,:,1,i) - 0.5).^2/sig.^2);
    G = exp(-.4*(I(:,:,2,i) - 0.5).^2/sig.^2);
    B = exp(-.4*(I(:,:,3,i) - 0.5).^2/sig.^2);
    C(:,:,i) = R.*G.*B;
end
