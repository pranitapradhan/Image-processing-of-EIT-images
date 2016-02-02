%16.05.2015

PatientB_TV_u;

%--- Finding the Inspiratory Capacity frame--%

k=find(max_pks_New==high_pks);
hp=max_locs_New(k);

%---- Finding FIC frame-----%
h=frame(:,min_TV_locs);
h=mean(h');
h1=frame(:,hp);
h1=h1';
FIC=h1-h;

%---- Finding IRV frame--%
FIRV = FIC- med_TV_locs;

%---- Plotting the IRV frame---%
 
 FIRV1=reshape(FIRV,32,32)';
 figure;
 FIRV1=flipud(FIRV1);
 pcolor(FIRV1);
 title('IRV FRAME');
 
  %--- 29.05.2015 Dividing frames
FBIRV1=FIRV1(17:32,1:16);
FBIRV2=FIRV1(17:32,17:32);
FBIRV3=FIRV1(1:16,1:16);
FBIRV4=FIRV1(1:16,17:32);
 
 
 %--- IRV for 1st half--%
 FBIRV1_sum = sum(sum(FBIRV1));
 rat_IRV1=FBIRV1_sum/Body_plyt(6,4);
 
 %--- IRV for 2st half--%
 FBIRV2_sum = sum(sum(FBIRV2));
 rat_IRV2=FBIRV2_sum/Body_plyt(6,4);
 
 %--- IRV for 3rd half--%
 FBIRV3_sum = sum(sum(FBIRV3));
 rat_IRV3=FBIRV3_sum/Body_plyt(6,4);
 
 %--- IRV for 4th half--%
 FBIRV4_sum = sum(sum(FBIRV4));
 rat_IRV4=FBIRV4_sum/Body_plyt(6,4);