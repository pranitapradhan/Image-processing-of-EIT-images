close all; clear all;
%% read bin file
[fname_get,pname_get]=uigetfile('*.bin','Open data file');
      
if fname_get==0
  return
end
CurrentPath=pname_get;
fullname_get=fullfile(pname_get,fname_get);

fid=fopen(fullname_get,'r');
    getarray=fread(fid, [1 inf],'int8');
    fclose(fid);
    len=length(getarray);
    frame_length=len/4358;
    frame=zeros(1024,frame_length);
    fid=fopen(fullname_get,'r');
    for i=1:frame_length      
        time_stamp=fread(fid, [1 2],'float32');     % read time stamp
        dummy=fread(fid, [1],'float32');            % read dummy
        frame(:,i)=fread(fid, [1 1024],'float32');  % read pixel values for each frame
        int_value=fread(fid, [1 2],'int32');        % read MinMax, Event Marker, 
        EventText=fread(fid,[1 30],'int8'); 
        int_Time=fread(fid, [1 ],'int32');          % Timing Error
        Medibus=fread(fid, [1 52],'float32');
    end
        fclose(fid);
              
SumImpedance=sum(frame);

%------ plot SumImpedance-------%

figure
plot(SumImpedance)                      % global impedance
title('global EIT reading')

%....... our project start from here........

%---- Finding Maximas------------%

[max_pks,max_locs]=findpeaks(SumImpedance);
max_pks=max_pks(3:end);
max_locs=max_locs(3:end);
Maximas = [];
for i = 1:1:length(max_pks)
   if (max_pks(i)>2.2e04 && max_pks(i)< 2.6e04)
    Maximas(end+1) = max_locs(i);
  end
end


%---- Finding Minimas------------%
SumImpedanceInv = (-SumImpedance);
[min_pks,min_locs] = findpeaks(SumImpedanceInv);
min_pks=min_pks(2:end);
min_locs=min_locs(2:end);
Minimas=[];
for i = 1:1:length(min_pks)
   if (min_pks(i)<-1.8e04 && min_pks(i)>-2.5e04)
    Minimas(end+1)= min_locs(i);
  end
end

%-----Finding Mean frame----%------ Change 01.06.2015

max_meanframe=Maximas([1:13,15:22,24:32,34:40,42:end]);
min_meanframe=Minimas([1:13,16:23,25:33,37:43,45:end]);
sub_Frame=(frame(:,max_meanframe)-frame(:,min_meanframe));                 
mean_frame= mean(sub_Frame');         
fuz=reshape((mean_frame),32,32)';
fuz=flipud(fuz);
figure
pcolor(fuz)
title('MEAN FRAME');

B = reshape(fuz.',1,[]);
Max_val=max(B);
fact=0.2*Max_val;

 r=zeros(32,32);
 for i=1:1:32
    for j=1:1:32
         if fuz(i,j)>= fact
             r(i+1,j+1)=fuz(i,j);
         end
         
    end
end

%------Plotting mean frame----%


figure
pcolor(r)
title('LUNG CONTOUR');

 r=flipud(r);
 R = reshape(r.',1,[]);
zeros_pos1 = find(~R);

%------Plotting New SumImpedance---%
%% 30.04.2015
frame_back=frame;
frame(zeros_pos1,:)=0;
SumImpedance_New=sum(frame);
figure
plot(SumImpedance_New,'r')
hold on 
plot(SumImpedance);
legend('lung conture','Global')

%---- Finding Maximas------------%

[max_pks_New,max_locs_New]=findpeaks(SumImpedance_New);
Maximas_New = [];
Maximas_New_pks =[];
for i = 1:1:length(max_pks_New)
   if (max_pks_New(i)>1.7e04 && max_pks_New(i)< 1.9e04)
    Maximas_New(end+1) = max_locs_New(i);
    Maximas_New_pks(end+1) = max_pks_New(i);
  end
end

%---- Finding Minimas------------%
SumImpedanceInv_New = (-SumImpedance_New);
[min_pks_New,min_locs_New] = findpeaks(SumImpedanceInv_New);
min_pks_New=min_pks_New([1:50,52:end]);
min_locs_New=min_locs_New([1:50,52:end]);
Minimas_New=[];
Minimas_pks_New=[];
for i = 1:1:length(min_pks_New)
   if (min_pks_New(i)<-1.3e04 && min_pks_New(i)> -1.9e04)
    Minimas_New(end+1)= min_locs_New(i);
    Minimas_pks_New(end+1) = min_pks_New(i);
  end
end

%---- To find Tidal Volume---%
max_TV= Maximas_New_pks([1:13,15:31,33:end]);
min_TV= Minimas_pks_New([2:14,18:25,27:35,37:43,45:end]);
Tidal_vol = median(max_TV-abs(min_TV));  %---- excelude the frc manuer wave

%-------To find Inspiratory Capacity---%
high_pks=max(max_pks_New);
mean_min_TV=mean(min_TV);
IC = high_pks-abs(mean_min_TV);

%----To find Inspiratory Reserve Volume---%
IRV = IC-Tidal_vol;

%----To find Expiratory reserve volume---%
f=min_pks_New(51:end);
f_min=max(f);
ERV = abs(mean_min_TV)-abs(f_min);    

%----To find Functional residual capacity---%
FFRC=[1424 2401 3490 4429];
Minimas_FRC = SumImpedance_New(FFRC);  
FRC = abs(mean(Minimas_FRC));


%----To find ratio---%
       
Body_plyt = xlsread('Body-Werte.xlsx');

ratio_VT = Tidal_vol/Body_plyt(1,2);
ratio_ERV = ERV/Body_plyt(1,3);
ratio_IRV = IRV/Body_plyt(1,4);
ratio_FRC = FRC/Body_plyt(1,1);