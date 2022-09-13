%% Fuel mass calculation for each section

function [FuelMass,tf,tr] = Fuel_Mass(q2,q3,q4,q5,CY,Rotate2,Scale2,X,Nribs,Span)
q4=0.2;
q5=0.8;
q3=0.8;
q2=0.2;
xif=q2+CY*(q4-q2);
xir=q3+CY*(q5-q3);

xf0=xif;
xr0=xir;

yif=zeros(1,length(xif));
yir=zeros(1,length(xir));
zif=zeros(1,length(xif));
zir=zeros(1,length(xir));

xifc4=xif-0.25;
xirc4=xir-0.25;

Rotation=Rotate2;
Rotation=-deg2rad(Rotation);
  
xif=(xifc4.*cos(Rotation)+0.25).*Scale2+X;
xir=(xirc4.*cos(Rotation)+0.25).*Scale2+X;

[x,Yu,Yl] = Airfoil_Coord_Matching;

%% Calculate Volume

for i=1:length(x) 
    T(i) = abs(Yu(i)-Yl(i))/2; % thickness camber line
end

for i=1:Nribs+1
tf(i)=interp1(x,T,xf0(i))*Scale2(i);
tr(i)=interp1(x,T,xr0(i))*Scale2(i);
end
Tm=(tf+tr)/2;

for i=1:Nribs
    di=xir(i)-xif(i);
    di_1=xir(i+1)-xif(i+1);
    dy=Span/Nribs;
    V(i)=1.33*(di*Tm(i)+di_1*Tm(i+1)+0.5*(di*Tm(i+1)+di_1*Tm(i)))*dy/3;
end

FuelMass=V*800;





% plot3(xif,yif,zif,'*r')
% hold on
% plot3(xir,yir,zir,'ob')
% axis equal

