%% Create Spline Points in Chord of Each Rib
function [Rib_ML,TXT] = Ribs_Mid_Points(q2,q3,q4,q5,CY,Rotate2,Scale2,X,Y,Z,Nribs,number)

xif=q2+CY*(q4-q2);
xir=q3+CY*(q5-q3);
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

zif=(xifc4.*sin(Rotation)).*Scale2+Z;
zir=(xirc4.*sin(Rotation)).*Scale2+Z;

yif=Y;
yir=Y;

% plot3(xif,yif,zif,'*r')
% hold on
% plot3(xir,yir,zir,'ob')
% axis equal

for i=1:Nribs+1
    dx=(xir(i)-xif(i))/number;
    dy=(yir(i)-yif(i))/number;
    dz=(zir(i)-zif(i))/number;
    for j=1:number
    xi(i,j)=xif(i)+j*dx;
    yi(i,j)=yif(i)+j*dy;
    zi(i,j)=zif(i)+j*dz;
    end
end

xi=xi(:);
yi=yi(:);
zi=zi(:);
Rib_ML.X=xi;
Rib_ML.Y=yi;
Rib_ML.Z=zi;

TXT(1,:)=xi;
TXT(2,:)=yi;
TXT(3,:)=zi;

fileID = fopen('Input_Data\Spline_Points\R_SPL.txt','w');
fprintf(fileID,'%f %f %f\n',TXT);
fclose(fileID);

% figure(2)
% plot3(xi,yi,zi,'*r',LineWidth=1)
% axis equal