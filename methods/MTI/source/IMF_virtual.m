
function [I_l,I_h]=IMF_virtual(H)
%%
numExposures=2;
% a=I;
%  filenames=a;
% [filenames, exposures, numExposures] = readDir(pathname);
% % Pre-define parameters
% tmp = imread(filenames{1});
% [row,col,h]=size(tmp);
GY = cell(1,numExposures);
% Check the consistent of image labels
for i=1:numExposures
%     a = imread(filenames{i});
%     tmp = rgb2gray(a);
    tmp= H(:,:,1,i);
    GY{i} = tmp;
    Tvalue(i)=sum(tmp(:));
end
% [vv,nn] = sort(Tvalue,'descend');
% [EV,EN] = sort(exposures,'descend');
% if (nn~=EN)
%     msgbox('Note: the labeled exposures are not correct','Error:');
%     return
% end
%%
Ref = double(GY{2});
Ref2A = zeros(256,numExposures-1);
A2Ref = zeros(256,1);%A2Ref = zeros(256,numExposures-1);
for j = 1:1%numExposures-1
    A=double(GY{1});%figure,imshow(B);title('Image B');
    [TableRef2A,HRef,HA] = IMF(Ref,A);
    TableA2Ref = IMF(A,Ref);
    Ref2A(:,j)= TableRef2A';
    A2Ref(:,1)= TableA2Ref';
end
% new = TableRef2A(Ref+1)-1;
% H =[HRef;HA]
% 
% Table = [1:256;TableRef2A;TableA2Ref]
% figure;
% plot(1:256,TableRef2A,'r');
% hold on
% plot(1:256,TableA2Ref,'b')
% hold off
% figure,imshow(GY{6});
% figure,imshow(GY{1});
a = 1:256;
Ref2A = [Ref2A,a'];
A2Ref = [A2Ref,a'];
DR2A =diff(Ref2A);
DA2R = diff(A2Ref);
% figure,plot(Ref2A),title('Ref2A')
% figure,plot(A2Ref),title('A2Ref')
% figure,plot(DR2A),title('DR2A')
% figure,plot(DA2R),title('DA2R')
%%利用A2Ref将图片对应回去
I=GY{1};
for i=1:256
idx=find(GY{1}==A2Ref(i,2)); % find all 1.5
I(idx)=A2Ref(i,1);
end
I1(:,:,1)=I;
F=GY{2};
for i=1:256
idx=find(GY{2}==Ref2A(i,2)); % find all 1.5
F(idx)=Ref2A(i,1);
end
%%red
F1(:,:,1)=F;





% imwrite(I,'Ib.jpg');
 % set 1 to these indexes
% aa = [TableRef2A',TableA2Ref',a']
for i=1:numExposures
%     a = imread(filenames{i});
    %tmp = rgb2gray(a);
    tmp = H(:,:,2,i);
    GY{i} = tmp;
    Tvalue(i)=sum(tmp(:));
end
% [vv,nn] = sort(Tvalue,'descend');
% [EV,EN] = sort(exposures,'descend');
% if (nn~=EN)
%     msgbox('Note: the labeled exposures are not correct','Error:');
%     return
% end
%%
Ref = double(GY{2});
Ref2A = zeros(256,numExposures-1);
A2Ref = zeros(256,1);%A2Ref = zeros(256,numExposures-1);
for j = 1:1%numExposures-1
    A=double(GY{1});%figure,imshow(B);title('Image B');
    [TableRef2A,HRef,HA] = IMF(Ref,A);
    TableA2Ref = IMF(A,Ref);
    Ref2A(:,j)= TableRef2A';
    A2Ref(:,1)= TableA2Ref';
end
% new = TableRef2A(Ref+1)-1;
% H =[HRef;HA]
% 
% Table = [1:256;TableRef2A;TableA2Ref]
% figure;
% plot(1:256,TableRef2A,'r');
% hold on
% plot(1:256,TableA2Ref,'b')
% hold off
% figure,imshow(GY{2});
% figure,imshow(GY{1});
a = 1:256;
Ref2A = [Ref2A,a'];
A2Ref = [A2Ref,a'];
DR2A =diff(Ref2A);
DA2R = diff(A2Ref);
% figure,plot(Ref2A),title('Ref2A')
% figure,plot(A2Ref),title('A2Ref')
% figure,plot(DR2A),title('DR2A')
% figure,plot(DA2R),title('DA2R')
%%利用A2Ref将图片对应回去
I=GY{1};
for i=1:256
idx=find(GY{1}==A2Ref(i,2)); % find all 1.5
I(idx)=A2Ref(i,1);
end
I1(:,:,2)=I;
F=GY{2};
for i=1:256
idx=find(GY{2}==Ref2A(i,2)); % find all 1.5
F(idx)=Ref2A(i,1);
end
%%red
F1(:,:,2)=F;


for i=1:numExposures
%     a = imread(filenames{i});
    %tmp = rgb2gray(a);
    tmp = H(:,:,3,i);
    GY{i} = tmp;
    Tvalue(i)=sum(tmp(:));
end
% [vv,nn] = sort(Tvalue,'descend');
% [EV,EN] = sort(exposures,'descend');
% if (nn~=EN)
%     msgbox('Note: the labeled exposures are not correct','Error:');
%     return
% end
%%
Ref = double(GY{2});
Ref2A = zeros(256,numExposures-1);
A2Ref = zeros(256,1);%A2Ref = zeros(256,numExposures-1);
for j = 1:1%numExposures-1
    A=double(GY{1});%figure,imshow(B);title('Image B');
    [TableRef2A,HRef,HA] = IMF(Ref,A);
    TableA2Ref = IMF(A,Ref);
    Ref2A(:,j)= TableRef2A';
    A2Ref(:,1)= TableA2Ref';
end
% new = TableRef2A(Ref+1)-1;
% H =[HRef;HA]
% 
% Table = [1:256;TableRef2A;TableA2Ref]
% figure;
% plot(1:256,TableRef2A,'r');
% hold on
% plot(1:256,TableA2Ref,'b')
% hold off
% figure,imshow(GY{2});
% figure,imshow(GY{1});
a = 1:256;
Ref2A = [Ref2A,a'];
A2Ref = [A2Ref,a'];
DR2A =diff(Ref2A);
DA2R = diff(A2Ref);
% figure,plot(Ref2A),title('Ref2A')
% figure,plot(A2Ref),title('A2Ref')
% figure,plot(DR2A),title('DR2A')
% figure,plot(DA2R),title('DA2R')
%%利用A2Ref将图片对应回去
I=GY{1};
for i=1:256
idx=find(GY{1}==A2Ref(i,2)); % find all 1.5
I(idx)=A2Ref(i,1);
end
I1(:,:,3)=I;
F=GY{2};
for i=1:256
idx=find(GY{2}==Ref2A(i,2)); % find all 1.5
F(idx)=Ref2A(i,1);
end
%%red
F1(:,:,3)=F;

figure(1),imshow(I1);
figure(2),imshow(F1);

I_l=F1;
I_h=I1;
% imwrite(I_h,'finalimage\I_h.png');
% imwrite(I_l,'finalimage\I_s.png');
% I_h=imread('finalimage\I_h.png');
% I_l=imread('finalimage\I_s.png');
