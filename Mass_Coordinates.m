
function [Mass_Coord,Attach_Points] = Mass_Coordinates(q2,q3,q4,q5,CY,Rotate2,Scale2,X,Y,Z,Nribs)

[x,Yu,Yl] = Airfoil_Coord_Matching;

%% Points on Chord
xif=q2+CY*(q4-q2);
xir=q3+CY*(q5-q3);
yif=zeros(1,length(xif));
yir=zeros(1,length(xir));
zif=zeros(1,length(xif));
zir=zeros(1,length(xir));

%% Points on OML that are products of intersection of airfoil with spars
% those will be lumped mass' attach points

Attach_Points.X.FU=q2+CY.*(q4-q2);
Attach_Points.X.RU=q3+CY.*(q5-q3);
Attach_Points.X.FL=q2+CY.*(q4-q2);
Attach_Points.X.RL=q3+CY.*(q5-q3);

Attach_Points.Y.FU=Y;
Attach_Points.Y.RU=Y;
Attach_Points.Y.FL=Y;
Attach_Points.Y.RL=Y;

Attach_Points.Z.FU=zeros(1,length(xif));
Attach_Points.Z.RU=zeros(1,length(xir));
Attach_Points.Z.FL=zeros(1,length(xif));
Attach_Points.Z.RL=zeros(1,length(xir));

for i=1:Nribs+1
    Attach_Points.Z.FU(i)=interp1(x,Yu,Attach_Points.X.FU(i));
    Attach_Points.Z.RU(i)=interp1(x,Yu,Attach_Points.X.RU(i));
    Attach_Points.Z.FL(i)=interp1(x,Yl,Attach_Points.X.FL(i));
    Attach_Points.Z.RL(i)=interp1(x,Yl,Attach_Points.X.RL(i));
end

xifc4=xif-0.25;
xirc4=xir-0.25;

Rotation=Rotate2;
Rotation=-deg2rad(Rotation);

xif=(xifc4.*cos(Rotation)+0.25).*Scale2+X;
xir=(xirc4.*cos(Rotation)+0.25).*Scale2+X;
zif=(xifc4.*sin(Rotation)).*Scale2+Z;
zir=(xirc4.*sin(Rotation)).*Scale2+Z;
yif=Y;
yir=Y;

Attach_Points.X.FU=Attach_Points.X.FU-0.25;
Attach_Points.X.RU=Attach_Points.X.RU-0.25;
Attach_Points.X.FL=Attach_Points.X.FL-0.25;
Attach_Points.X.RL=Attach_Points.X.RL-0.25;

Attach_Points.X_.FU=cos(Rotation).*Attach_Points.X.FU-sin(Rotation).*Attach_Points.Z.FU+0.25;
Attach_Points.X_.RU=cos(Rotation).*Attach_Points.X.RU-sin(Rotation).*Attach_Points.Z.RU+0.25;
Attach_Points.X_.FL=cos(Rotation).*Attach_Points.X.FL-sin(Rotation).*Attach_Points.Z.FL+0.25;
Attach_Points.X_.RL=cos(Rotation).*Attach_Points.X.RL-sin(Rotation).*Attach_Points.Z.RL+0.25;

Attach_Points.Z_.FU=sin(Rotation).*Attach_Points.X.FU+cos(Rotation).*Attach_Points.Z.FU;
Attach_Points.Z_.RU=sin(Rotation).*Attach_Points.X.RU+cos(Rotation).*Attach_Points.Z.RU;
Attach_Points.Z_.FL=sin(Rotation).*Attach_Points.X.FL+cos(Rotation).*Attach_Points.Z.FL;
Attach_Points.Z_.RL=sin(Rotation).*Attach_Points.X.RL+cos(Rotation).*Attach_Points.Z.RL;

Attach_Points.X.FU=Attach_Points.X_.FU.*Scale2+X;
Attach_Points.X.RU=Attach_Points.X_.RU.*Scale2+X;
Attach_Points.X.FL=Attach_Points.X_.FL.*Scale2+X;
Attach_Points.X.RL=Attach_Points.X_.RL.*Scale2+X;

Attach_Points.Z.FU=(Attach_Points.Z_.FU).*Scale2+Z;
Attach_Points.Z.RU=(Attach_Points.Z_.RU).*Scale2+Z;
Attach_Points.Z.FL=(Attach_Points.Z_.FL).*Scale2+Z;
Attach_Points.Z.RL=(Attach_Points.Z_.RL).*Scale2+Z;

% plot3(xif,yif,zif,'*r')
% hold on
% plot3(xir,yir,zir,'ob')
% axis equal
% hold on 
% plot3(Attach_Points.X.FU,Attach_Points.Y.FU,Attach_Points.Z.FU,"oy")
% plot3(Attach_Points.X.FL,Attach_Points.Y.FL,Attach_Points.Z.FL,"*y")
% plot3(Attach_Points.X.RU,Attach_Points.Y.RU,Attach_Points.Z.RU,"oc")
% plot3(Attach_Points.X.RL,Attach_Points.Y.RL,Attach_Points.Z.RL,"*c")

d=sqrt((xif-xir).^2+(zif-zir).^2);

for i=1:Nribs
Mass_Coord.Y(i)=(Y(i+1)+Y(i))/2;
end

for i=1:length(xif)
    theta=atan((zif(i)-zir(i))/(xir(i)-xif(i)));
    Mass_Coord.X(i)=xir(i)-d(i)*cos(theta)/2;
    Mass_Coord.Z(i)=zir(i)+d(i)*sin(theta)/2;
end

Mass_Coord.X=interp1(Y,Mass_Coord.X,Mass_Coord.Y);
Mass_Coord.Z=interp1(Y,Mass_Coord.Z,Mass_Coord.Y);

% plot3(Mass_Coord.X,Mass_Coord.Y,Mass_Coord.Z,".g")

% Attach_Points.X.FU=[];
% Attach_Points.X.RU=[];
% Attach_Points.X.FL=[];
% Attach_Points.X.RL=[];
% Attach_Points.Y.FU=[];
% Attach_Points.Y.RU=[];
% Attach_Points.Y.FL=[];
% Attach_Points.Y.RL=[];
% Attach_Points.Z.FU=[];
% Attach_Points.Z.RU=[];
% Attach_Points.Z.FL=[];
% Attach_Points.Z.RL=[];



