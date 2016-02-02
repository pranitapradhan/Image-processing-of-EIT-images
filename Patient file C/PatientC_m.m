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
        int_Time=fread(fid, [1],'int32');          % Timing Error
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
Maximas = [];
for i = 1:1:length(max_pks)
   if (max_pks(i)>2.0e04 && max_pks(i)< 3.0e04)
    Maximas(end+1) = max_locs(i);
  end
end

%---- Finding Minimas------------%
SumImpedanceInv = (-SumImpedance);
[min_pks,min_locs] = findpeaks(SumImpedanceInv);
Minimas=[];
for i = 1:1:length(min_pks)
   if (min_pks(i)<-1.05e04 && min_pks(i)> -2e04)
    Minimas(end+1)= min_locs(i);
  end
end

%-----Finding Mean frame----%------ Change 01.06.2015

max_meanframe=Maximas([2:11,13:19,21:29]);
min_meanframe=Minimas([1:10,13:19,21:28,30]);
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
legend('20% of global','Global')

%---- Finding Maximas------------%

[max_pks_New,max_locs_New]=findpeaks(SumImpedance_New);
Maximas_New = [];
Maximas_New_pks =[];
for i = 1:1:length(max_pks_New)
   if (max_pks_New(i)>1.6e04 && max_pks_New(i)< 2.5e04)
    Maximas_New(end+1) = max_locs_New(i);
    Maximas_New_pks(end+1) = max_pks_New(i);
  end
end

%---- Finding Minimas------------%
SumImpedanceInv_New = (-SumImpedance_New);
[min_pks_New,min_locs_New] = findpeaks(SumImpedanceInv_New);
Minimas_New=[];
Minimas_pks_New=[];
for i = 1:1:length(min_pks_New)
   if (min_pks_New(i)<-0.92e04 && min_pks_New(i)> -1.5e04)
    Minimas_New(end+1)= min_locs_New(i);
    Minimas_pks_New(end+1) = min_pks_New(i);
  end
end

%---- To find Tidal Volume---%
max_TV= Maximas_New_pks([2:11,13:19,21:28,30]);
min_TV= Minimas_pks_New([1:10,13:19,21:28,30]);
Tidal_vol = median(max_TV-abs(min_TV));  %---- excelude the frc manuer wave

%-------To find Inspiratory Capacity---%
high_pks=max(max_pks_New);
mean_min_TV=mean(min_TV);
IC = high_pks-abs(mean_min_TV);

%----To find Inspiratory Reserve Volume---%
IRV = IC-Tidal_vol;

%----To find Expiratory reserve volume---%
f=min_pks_New(32:33);
f_min=max(f);
ERV = abs(mean_min_TV)-abs(f_min);    

%----To find Functional residual capacity---%
FFRC=[879 1811 2743 3659];
Minimas_FRC = SumImpedance_New(FFRC);  
FRC = abs(mean(Minimas_FRC));


%----To find ratio---%
       
Body_plyt = xlsread('Body-Werte.xlsx');

ratio_VT = Tidal_vol/Body_plyt(8,2);
ratio_ERV = ERV/Body_plyt(8,3);
ratio_IRV = IRV/Body_plyt(8,4);
ratio_FRC = FRC/Body_plyt(8,1);
