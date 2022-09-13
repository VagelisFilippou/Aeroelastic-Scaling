function [Coords] = uCRM_MDO
points='uCRM_9_Coord.txt';
fid = fopen(points) ;
C = textscan(fid, '%s %f %f %f %s %s');
fclose(fid);

P(:,1)=C{1,2};
P(:,2)=C{1,3};
P(:,3)=C{1,4};

Front=P(1:21,:);
Rear=P(22:42,:);

for i=1:21
c(i)=sqrt((Front(i,3)-Rear(i,3))^2+(Front(i,1)-Rear(i,1))^2);
aoa(i)=atan(-(Front(i,3)-Rear(i,3))/(Front(i,1)-Rear(i,1)));
d(i)=c(i)*0.25*cos(aoa(i));
dx(i)=c(i)*0.25-d(i);
dz(i)=c(i)*0.25*sin(aoa(i));

zinit(i)=Front(i,3)-dz(i);
xinit(i)=Front(i,1)+dx(i);
end

Coords.Z=zinit-zinit(1);
Coords.X=xinit-xinit(1);
Coords.Y(1,:)=P(1:21,2);
Coords.AoA=rad2deg(aoa);
Coords.Chord=c;

% figure(1)
% hold on
% axis equal
% plot3(Front(:,1),Front(:,2),Front(:,3),'*r',MarkerSize=15)
% plot3(Rear(:,1),Rear(:,2),Rear(:,3),'*b',MarkerSize=15)
% plot3(Coords.X(1,:),Coords.Y(1,:),Coords.Z(1,:))

end