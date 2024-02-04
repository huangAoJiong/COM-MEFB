function w=fusion21(z)
z=double(z);
mtmp1=z(:,:,1);
mtmp2=z(:,:,2);
mtmp3=z(:,:,3);
mtmp1(0<=mtmp1&mtmp1<200)=1;
mtmp1(200<=mtmp1&mtmp1<250)=1-3.*(((mtmp1(200<=mtmp1&mtmp1<250)-200)./50).^2)+2.*(((mtmp1(200<=mtmp1&mtmp1<250)-200)./50).^3);
mtmp1(mtmp1>=250|mtmp1<0)=0;

mtmp2(0<=mtmp2&mtmp2<200)=1;
mtmp2(200<=mtmp2&mtmp2<250)=1-3.*(((mtmp2(200<=mtmp2&mtmp2<250)-200)./50).^2)+2.*(((mtmp2(200<=mtmp2&mtmp2<250)-200)./50).^3);
mtmp2(mtmp2>=250|mtmp2<0)=0;

mtmp3(0<=mtmp3&mtmp3<200)=1;
mtmp3(200<=mtmp3&mtmp3<250)=1-3.*(((mtmp3(200<=mtmp3&mtmp3<250)-200)./50).^2)+2.*(((mtmp3(200<=mtmp3&mtmp3<250)-200)./50).^3);
mtmp3(mtmp3>=250|mtmp3<0)=0;



w(:,:,1)=mtmp1;w(:,:,2)=mtmp2;w(:,:,3)=mtmp3;