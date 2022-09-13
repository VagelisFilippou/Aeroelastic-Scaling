function vfl=flutterconv2()
% %% Run flutter analysis
% patfl='C:\MSC.Software\MSC_Nastran\20190\bin\nastranw.exe uCRM_Flutter_Upd.bdf';
% [~,~ ] =system(patfl);
% flag = true;
% while flag
%      flag = isprocess('nastran.exe');
%      pause(1)
% end

%% Read output
fidfl='ucrm_sol_145.f06';fidflout=fopen(fidfl);
dataflutter=textscan(fidflout,'%s', 'delimiter', '\n');
keyp1='POINT =    1';keyp2='POINT =    2';keyp3='POINT =    3';keyp4='POINT =    4';keyp5='POINT =    5';
keyp6='POINT =    6';keyp7='POINT =    7';keyp8='POINT =    8';keyp9='POINT =    9';keyp10='POINT =   10';keyp11='POINT =   11';
countm1=1;countm2=1;countm3=1;countm4=1;countm5=1;
countm6=1;countm7=1;countm8=1;countm9=1;countm10=1;countm11=1;
for iks=1:length(dataflutter{1})
tf1=strncmp(dataflutter{1}{iks},keyp1,length(keyp1));tf2=strncmp(dataflutter{1}{iks},keyp2,length(keyp2));tf3=strncmp(dataflutter{1}{iks},keyp3,length(keyp3));
tf4=strncmp(dataflutter{1}{iks},keyp4,length(keyp4));tf5=strncmp(dataflutter{1}{iks},keyp5,length(keyp5));tf6=strncmp(dataflutter{1}{iks},keyp6,length(keyp6));
tf7=strncmp(dataflutter{1}{iks},keyp7,length(keyp7));tf8=strncmp(dataflutter{1}{iks},keyp8,length(keyp8));tf9=strncmp(dataflutter{1}{iks},keyp9,length(keyp9));
tf10=strncmp(dataflutter{1}{iks},keyp10,length(keyp10));tf11=strncmp(dataflutter{1}{iks},keyp11,length(keyp11));         
      if tf1==1
         idmode1(countm1)=iks;
         countm1=countm1+1;
      end
      if tf2==1
         idmode2(countm2)=iks;
         countm2=countm2+1;
      end
      if tf3==1
         idmode3(countm3)=iks;
         countm3=countm3+1;
      end
      if tf4==1
         idmode4(countm4)=iks;
         countm4=countm4+1;
      end
      if tf5==1
         idmode5(countm5)=iks;
         countm5=countm5+1;
      end
      if tf6==1
         idmode6(countm6)=iks;
         countm6=countm6+1;
      end
      if tf7==1
         idmode7(countm7)=iks;
         countm7=countm7+1;
      end
      if tf8==1
         idmode8(countm8)=iks;
         countm8=countm8+1;
      end
      if tf9==1
         idmode9(countm9)=iks;
         countm9=countm9+1;
      end
      if tf10==1
         idmode10(countm10)=iks;
         countm10=countm10+1;
      end   
      if tf11==1
         idmode11(countm11)=iks;
         countm11=countm11+1;
      end   
end
%% Locate mode velocities, damping and frequencies
for kk=1:length(idmode1)
    if kk==1
  strmode1=dataflutter{1}(idmode1(kk)+4:idmode1(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode1)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode1(kk)+4:idmode1(kk+1)-6));
    end
    if kk==length(idmode1)
        if length(kk)<=2
   strmodef1=vertcat(strmode1,dataflutter{1}(idmode1(kk)+4:idmode2(1)-6));
        else
    strmodef1=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode2)
   if kk==1
  strmode1=dataflutter{1}(idmode2(kk)+4:idmode2(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode2)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode2(kk)+4:idmode2(kk+1)-6));
    end
    if kk==length(idmode2)
        if length(kk)<=2
   strmodef2=vertcat(strmode1,dataflutter{1}(idmode2(kk)+4:idmode3(1)-6));
        else
    strmodef2=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode3)
    if kk==1
  strmode1=dataflutter{1}(idmode3(kk)+4:idmode3(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode3)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode3(kk)+4:idmode3(kk+1)-6));
    end
    if kk==length(idmode3)
        if length(kk)<=2
   strmodef3=vertcat(strmode1,dataflutter{1}(idmode3(kk)+4:idmode4(1)-6));
        else
    strmodef3=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode4)
    if kk==1
  strmode1=dataflutter{1}(idmode4(kk)+4:idmode4(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode4)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode4(kk)+4:idmode4(kk+1)-6));
    end
    if kk==length(idmode4)
        if length(kk)<=2
   strmodef4=vertcat(strmode1,dataflutter{1}(idmode4(kk)+4:idmode5(1)-6));
        else
    strmodef4=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode5)
   if kk==1
  strmode1=dataflutter{1}(idmode5(kk)+4:idmode5(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode5)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode5(kk)+4:idmode5(kk+1)-6));
    end
    if kk==length(idmode5)
        if length(kk)<=2
   strmodef5=vertcat(strmode1,dataflutter{1}(idmode5(kk)+4:idmode6(1)-6));
        else
    strmodef5=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode6)
    if kk==1
  strmode1=dataflutter{1}(idmode6(kk)+4:idmode6(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode6)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode6(kk)+4:idmode6(kk+1)-6));
    end
    if kk==length(idmode6)
        if length(kk)<=2
   strmodef6=vertcat(strmode1,dataflutter{1}(idmode6(kk)+4:idmode7(1)-6));
        else
    strmodef6=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode7)
   if kk==1
  strmode1=dataflutter{1}(idmode7(kk)+4:idmode7(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode7)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode7(kk)+4:idmode7(kk+1)-6));
    end
    if kk==length(idmode7)
        if length(kk)<=2
   strmodef7=vertcat(strmode1,dataflutter{1}(idmode7(kk)+4:idmode8(1)-6));
        else
    strmodef7=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode8)
   if kk==1
  strmode1=dataflutter{1}(idmode8(kk)+4:idmode8(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode8)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode8(kk)+4:idmode8(kk+1)-6));
    end
    if kk==length(idmode8)
        if length(kk)<=2
   strmodef8=vertcat(strmode1,dataflutter{1}(idmode8(kk)+4:idmode9(1)-6));
        else
    strmodef8=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode9)
    if kk==1
  strmode1=dataflutter{1}(idmode9(kk)+4:idmode9(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode9)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode9(kk)+4:idmode9(kk+1)-6));
    end
    if kk==length(idmode9)
        if length(kk)<=2
   strmodef9=vertcat(strmode1,dataflutter{1}(idmode9(kk)+4:idmode10(1)-6));
        else
    strmodef9=vertcat(strmode1,strmode2);
        end
    end
end
for kk=1:length(idmode10)
    if kk==1
  strmode1=dataflutter{1}(idmode10(kk)+4:idmode10(kk+1)-6);
    end
    if kk>1 && kk~=length(idmode10)
    strmode2=vertcat(strmode1,dataflutter{1}(idmode10(kk)+4:idmode10(kk+1)-6));
    end
    if kk==length(idmode10)
        if length(kk)<=2
   strmodef10=vertcat(strmode1,dataflutter{1}(idmode10(kk)+4:idmode11(1)-6));
        else
    strmodef10=vertcat(strmode1,strmode2);
        end
    end
end
%% Obtain g,F,V
for kk=1:length(strmodef1)
    %1st Mode
    gg1=strsplit(strmodef1{kk});
    velm(kk,1)=str2double(gg1{3});
    gm(kk,1)=str2double(gg1{4});
    fm(kk,1)=str2double(gg1{5});
    %2nd Mode
    gg2=strsplit(strmodef2{kk});
    velm(kk,2)=str2double(gg2{3});
    gm(kk,2)=str2double(gg2{4});
    fm(kk,2)=str2double(gg2{5});
     %3rd Mode
    gg3=strsplit(strmodef3{kk});
    velm(kk,3)=str2double(gg3{3});
    gm(kk,3)=str2double(gg3{4});
    fm(kk,3)=str2double(gg3{5});
      %4th Mode
    gg4=strsplit(strmodef4{kk});
    velm(kk,4)=str2double(gg4{3});
    gm(kk,4)=str2double(gg4{4});
    fm(kk,4)=str2double(gg4{5});
    %5th Mode
    gg5=strsplit(strmodef5{kk});
    velm(kk,5)=str2double(gg5{3});
    gm(kk,5)=str2double(gg5{4});
    fm(kk,5)=str2double(gg5{5});
    %6th Mode
    gg6=strsplit(strmodef6{kk});
    velm(kk,6)=str2double(gg6{3});
    gm(kk,6)=str2double(gg6{4});
    fm(kk,6)=str2double(gg6{5});
    %7th Mode
    gg7=strsplit(strmodef7{kk});
    velm(kk,7)=str2double(gg7{3});
    gm(kk,7)=str2double(gg7{4});
    fm(kk,7)=str2double(gg7{5});
    %6th Mode
    gg8=strsplit(strmodef8{kk});
    velm(kk,8)=str2double(gg8{3});
    gm(kk,8)=str2double(gg8{4});
    fm(kk,8)=str2double(gg8{5});
    %6th Mode
    gg9=strsplit(strmodef9{kk});
    velm(kk,9)=str2double(gg9{3});
    gm(kk,9)=str2double(gg9{4});
    fm(kk,9)=str2double(gg9{5});
    %6th Mode
    gg10=strsplit(strmodef10{kk});
    velm(kk,10)=str2double(gg10{3});
    gm(kk,10)=str2double(gg10{4});
    fm(kk,10)=str2double(gg10{5});
end
%% Inspect locii for positive damping values
[a1,b1]=find(gm>0);
if isempty(a1) %% No flutter speed detected, set to 1000 m/s
vfl=1e3;    
else
flmode=min(b1);
flvel=a1(1);
vflupper=velm(flvel,flmode);
vfllower=velm(flvel-1,flmode);
gmupper=gm(flvel,flmode);
gmlower=gm(flvel-1,flmode);
%%Linear interpolation to obtain flutter point
coeffs=polyfit([vfllower vflupper],[gmlower gmupper],1);
vfl=-(coeffs(2)/coeffs(1));
end
fclose(fidflout);