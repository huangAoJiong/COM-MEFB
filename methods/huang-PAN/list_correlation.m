function w = list_correlation(I)
[m,n,K] = size(I);
w=zeros(m,n,K);
for i=1:m
    for j=1:n
        w(i,j,:) =  mean2(I(i,j,:))-abs(I(i,j,:)-mean2(I(i,j,:)));
    end
end
end