%16.05.2015

%-- Finding frame for FRC---%


ERV;

FFRC=[879 1811 2743 3659];
FFRC_mean=(frame(:,FFRC));
FFRC_mean= mean(FFRC_mean');


%---- Plotting the FRC frame---%
 
 FFRC1=reshape(FFRC_mean,32,32)';
 figure;
 FFRC1=flipud(FFRC1);
 pcolor(FFRC1);
 title('FRC FRAME');
 
  %--- 29.05.2015 Dividing frames
FBFRC1=FFRC1(17:32,1:16);
FBFRC2=FFRC1(17:32,17:32);
FBFRC3=FFRC1(1:16,1:16);
FBFRC4=FFRC1(1:16,17:32);
 
 
 %--- FRC for 1st half--%
 FBFRC1_sum = sum(sum(FBFRC1));
 rat_FRC1=FBFRC1_sum/Body_plyt(2,1);
 
 %--- FRC for 2st half--%
 FBFRC2_sum = sum(sum(FBFRC2));
 rat_FRC2=FBFRC2_sum/Body_plyt(2,1);
 
 %--- FRC for 3rd half--%
 FBFRC3_sum = sum(sum(FBFRC3));
 rat_FRC3=FBFRC3_sum/Body_plyt(2,1);
 
 %--- FRC for 4th half--%
 FBFRC4_sum = sum(sum(FBFRC4));
 rat_FRC4=FBFRC4_sum/Body_plyt(2,1);
