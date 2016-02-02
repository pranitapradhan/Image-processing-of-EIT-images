PatientB_o;

%---- Finding Frame for Tidal Volume---%
 max_TV_locs= Maximas_New([1:9,11:17,19:25,27:32,34:end-1]);
 min_TV_locs= Minimas_New([1:6,8,10:11,14:20,23:29,32:37,40:end-1]);
 diff_TV_locs=(frame(:,max_TV_locs)-frame(:,min_TV_locs));
 med_TV_locs=mean(diff_TV_locs');  
 
 %---- Plotting the Tidal Volume frame---%
 
 F1=reshape (med_TV_locs,32,32)';
 figure
 F1=flipud(F1);
 pcolor(F1)
 title('TIDAL VOLUME FRAME');
 
 
 %--- 29.05.2015 Dividing frames
FB1=F1(17:32,1:16);
FB2=F1(17:32,17:32);
FB3=F1(1:16,1:16);
FB4=F1(1:16,17:32);
 
 
 %--- Tidal Volume for 1st half--%
 FB1_sum = sum(sum(FB1));
 rat1=FB1_sum/Body_plyt(4,2);
 
 %--- Tidal Volume for 2st half--%
 FB2_sum = sum(sum(FB2));
 rat2=FB2_sum/Body_plyt(4,2);
 
 %--- Tidal Volume for 3rd half--%
 FB3_sum = sum(sum(FB3));
 rat3=FB3_sum/Body_plyt(4,2);
 
 %--- Tidal Volume for 4th half--%
 FB4_sum = sum(sum(FB4));
 rat4=FB4_sum/Body_plyt(4,2);