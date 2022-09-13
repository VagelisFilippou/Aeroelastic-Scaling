function Flutter_Cards(F1,Fend,Density_Ratio,Mach)

%% MK Aero 
N=20;

% F1=0.001;
% Fend=2.001;
% Density_Ratio=0.3;
% Mach=0.85;

DeltaRF=(Fend-F1)/N;
Init_N=190;

for i=1:N
    RF(i)=F1+(i-1)*DeltaRF;
end
i=1;
while i<N/2+1
    No(i)= Init_N+i-1;  
    i=i+1;
end
No_E=ones(1,N);
No_E(1,1:2:N-1)=No;
No_E(1,2:2:N)=No;

entry=['MKAERO2*%-15.2f %-16.5f%-16.2f%-16.5f%s%1.0f\n%s%1.0f\n'];
fid=fopen('Flutter_Cards.bdf','w');

i=1;
while i<N
fprintf(fid,entry,Mach,RF(i),Mach,RF(i+1),'*MK',No_E(i),'*MK',No_E(i+1));
i=i+2;
end

%% Density Ratios 
fprintf(fid,'\nFLFACT* 1               %1.4f                                          *FL200\n*FL200\n',Density_Ratio);

%% Mach number sets
fprintf(fid,'\nFLFACT* 2               %1.2f                                            *FLF2\n*FLF2\n\n',Mach);

%% Velocity Sets

Nv=91;
V1=50;
Vend=1000;
DV=(Vend-V1)/Nv;

for i=1:Nv
    V(i)=V1+(i-1)*DV;
end

FL_N=((Nv-3)/4);
Begin_N=200;

Line=Begin_N+1:1:1+FL_N+Begin_N;
entry=['FLFACT* 3               %-16.1f%-16.1f%-16.1f%s%1.0f\n%s%1.0f'];
fprintf(fid,entry,V(1:3),'*FL',Line(1),'*FL',Line(1));
entry=['  %-16.1f%-16.1f%-16.1f%-16.1f%s%1.0f\n%s%1.0f'];

V_=V(4:end);
V_=transpose(reshape(V_,[4,FL_N]));

for i=1:FL_N
fprintf(fid,entry,V_(i,:),'*FL',Line(i+1),'*FL',Line(i+1));
end
% FLFACT* 3               100.0           110.0           120.0           *FL201
% *FL201  130.0           140.0           150.0           160.0           *FL202

fprintf(fid,'\n\nFLUTTER*1               PK              1               2               *FLU1\n*FLU1   3\n');                                               

fclose(fid);
