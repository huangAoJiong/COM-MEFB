function lcc_res = LCC(input)
%输入的参数类型必须是double
if(~strcmp(class(input),'double'))
    error('请输入double类型的输入参数\n')
end
input_temp = 1 - input;
mask = fspecial('average',[5 5]);
m = imfilter(input_temp,mask);
% figure,imshow(m),title('15');  %显示掩膜mask
lcc = real(1 * ((input / 1) .^ (2 .^((0.5 - m) / 0.5))));        
lcc_res = lcc;
