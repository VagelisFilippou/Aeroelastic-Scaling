%% Create Spline Points in Chord of Each Rib
function [LE,TE] = LE_TE_Ribs(q2,q3,q4,q5,CY,Rotate2,Scale2,X,Y,Z,Nribs)
% Nribs=10;

xif=zeros(1,length(Nribs+1));
xir=ones(1,length(Nribs+1));
yif=zeros(1,length(Nribs+1));
yir=zeros(1,length(Nribs+1));
zif=zeros(1,length(Nribs+1));
zir=zeros(1,length(Nribs+1));

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

% plot3(xif,yif,zif,'*r')
% hold on
% plot3(xir,yir,zir,'ob')
% axis equal

LE(1,:)=xif;
LE(2,:)=yif;
LE(3,:)=zif;
TE(1,:)=xir;
TE(2,:)=yir;
TE(3,:)=zir;

fileID = fopen('Input_Data\Objective\LE_POINTS\LE','w');
fprintf(fileID,'%f %f %f\n',LE);
fclose(fileID);

fileID = fopen('Input_Data\Objective\TE_POINTS\TE','w');
fprintf(fileID,'%f %f %f\n',TE);
fclose(fileID);