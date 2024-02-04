function w=fusion11(z)

mtmp1=z(:,:,1);
mtmp2=z(:,:,2);
mtmp3=z(:,:,3);
mtmp1(0<=mtmp1&mtmp1<10)=0;
mtmp1(10<=mtmp1&mtmp1<55)=1-3.*(((55-mtmp1(10<=mtmp1&mtmp1<55))./45).^2)+2.*(((55-mtmp1(10<=mtmp1&mtmp1<55))./45).^3);
mtmp1(mtmp1>=55|mtmp1<0)=1;

mtmp2(0<=mtmp2&mtmp2<10)=0;
mtmp2(10<=mtmp2&mtmp2<55)=1-3.*(((55-mtmp2(10<=mtmp2&mtmp2<55))./45).^2)+2.*(((55-mtmp2(10<=mtmp2&mtmp2<55))./45).^3);
mtmp2(mtmp2>=55|mtmp2<0)=1;

mtmp3(0<=mtmp3&mtmp3<10)=0;
mtmp3(10<=mtmp3&mtmp3<55)=1-3.*(((55-mtmp3(10<=mtmp3&mtmp3<55))./45).^2)+2.*(((55-mtmp3(10<=mtmp3&mtmp3<55))./45).^3);
mtmp3(mtmp3>=55|mtmp3<0)=1;

w(:,:,1)=mtmp1;w(:,:,2)=mtmp2;w(:,:,3)=mtmp3;
