%16.05.2015

%-- Finding the frame for ERV-- %

PatientB_IRV_u;

g=find(min_pks_New==f_min);
FERV_locs=min_locs_New(g);
h=frame(:,min_TV_locs);
h=mean(h');
g1=frame(:,FERV_locs);
g1=g1';
FERV=h-g1;

%---- Plotting the Expiratory capacity frame---%
 
 FERV1=reshape(FERV,32,32)';
 figure;
 FERV1=flipud(FERV1);
 pcolor(FERV1);
 title('ERV FRAME');
 
  %--- 29.05.2015 Dividing frames
FBERV1=FERV1(17:32,1:16);
FBERV2=FERV1(17:32,17:32);
FBERV3=FERV1(1:16,1:16);
FBERV4=FERV1(1:16,17:32);
 
 
 %--- ERV for 1st half--%
 FBERV1_sum = sum(sum(FBERV1));
 rat_ERV1=FBERV1_sum/Body_plyt(6,3);
 
 %--- ERV for 2st half--%
 FBERV2_sum = sum(sum(FBERV2));
 rat_ERV2=FBERV2_sum/Body_plyt(6,3);
 
 %--- ERV for 3rd half--%
 FBERV3_sum = sum(sum(FBERV3));
 rat_ERV3=FBERV3_sum/Body_plyt(6,3);
 
 %--- ERV for 4th half--%
 FBERV4_sum = sum(sum(FBERV4));
 rat_ERV4=FBERV4_sum/Body_plyt(6,3);