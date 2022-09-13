function [ID,CQUAD4,Grid,Stress,Thickness,Displacement,IDs]=QUAD_ELEMENT(file,dx,dy,dz)

% clear all 
% close all 
% clc
% file='uCRM_RearSpar.bdf';

fid = fopen(file,'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx = ~contains(S,'CQUAD4') ;
S(idx) = [] ;
fid = fopen('Input_Data\Bdf_plot\CQUAD.txt','wt') ;
fprintf(fid,'%s\n',S{:,:});
fclose(fid);
fid = fopen('Input_Data\Bdf_plot\CQUAD.txt','rt+') ;
C = textscan(fid, '%s %f %f %f %f %f %f');
fclose(fid);
ID=C{1,2};
QUAD(:,1)=C{1,4};
QUAD(:,2)=C{1,5};
QUAD(:,3)=C{1,6};
QUAD(:,4)=C{1,7};
[~,Grid] = gridpoint_extractor(file);
Grid(:,2)=Grid(:,2)+dx;
Grid(:,3)=Grid(:,3)+dy;
Grid(:,4)=Grid(:,4)+dz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h5data=h5extract('ucrm.h5');
[~,gridpoints] = gridpoint_extractor('uCRM.bdf');
Grid_ID=gridpoints(:,1);
Grid_x=gridpoints(:,2);
Grid_y=gridpoints(:,3);
Grid_z=gridpoints(:,4);

Displ_x=h5data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X;
Displ_y=h5data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y;
Displ_z=h5data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z;
Displ_Magnitude=sqrt(Displ_x.^2+Displ_y.^2+Displ_z.^2);

Dx=Grid_x+Displ_x;
Dy=Grid_y+Displ_y;
Dz=Grid_z+Displ_z;

h5data.NASTRAN.INPUT.NODE.GRID.X(4,:)=Dx;
h5data.NASTRAN.INPUT.NODE.GRID.X(5,:)=Dy;
h5data.NASTRAN.INPUT.NODE.GRID.X(6,:)=Dz;

for i=1:4
for j = 1:length(h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.EID)

x(i,j)=h5data.NASTRAN.INPUT.NODE.GRID.X(1,h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
y(i,j)=h5data.NASTRAN.INPUT.NODE.GRID.X(2,h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
z(i,j)=h5data.NASTRAN.INPUT.NODE.GRID.X(3,h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));

dx(i,j)=h5data.NASTRAN.INPUT.NODE.GRID.X(4,h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
dy(i,j)=h5data.NASTRAN.INPUT.NODE.GRID.X(5,h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
dz(i,j)=h5data.NASTRAN.INPUT.NODE.GRID.X(6,h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));

end
end

summ=0;
for i=1:length(h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.EID)
for j=1:4
    summ=Displ_Magnitude(h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(j,i))+summ;
end
    El_Displacement(i,1)=summ/4;
    summ=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=0;
linearIndices=zeros(max(Grid(:,1)),1);
for i =1:max(Grid(:,1))
   k=find(Grid(:,1)==i);
    if k~=0  
    linearIndices(i,1) = find(Grid(:,1)==i);
    idx(i,1)=1;
    else
    linearIndices(i,1) = 0;
    idx(i,1)=0;
    end
end

for i=1:length(QUAD)
for j = 1:4

CQUAD4.X(i,j)=Grid(linearIndices(QUAD(i,j)),2);
CQUAD4.Y(i,j)=Grid(linearIndices(QUAD(i,j)),3);
CQUAD4.Z(i,j)=Grid(linearIndices(QUAD(i,j)),4);
IDs(i,j)=linearIndices(QUAD(i,j));
end
end
CQUAD4.X=transpose(CQUAD4.X);
CQUAD4.Y=transpose(CQUAD4.Y);
CQUAD4.Z=transpose(CQUAD4.Z);

h5data=h5extract('ucrm.h5');
Eid=h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.EID  ;

VM_1= sqrt(h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X1.^2+h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y1.^2 ...
-h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X1.*h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y1+ ...
3*h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.TXY1.^2);

VM_2= sqrt(h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X2.^2+h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y2.^2 ...
-h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X2.*h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y2+ ...
3*h5data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.TXY2.^2);

VM=max(VM_1,VM_2);

k=1;
for i=1:length(Eid)
    for j = 1: length(ID)

    if Eid(i)==ID(j)
        Stress(k)=VM(1,i);
        Thickness(k)=h5data.NASTRAN.INPUT.PROPERTY.PSHELL.T(h5data.NASTRAN.INPUT.ELEMENT.CQUAD4.PID(i));
        Displacement(k)=El_Displacement(i);
        k=k+1;
    else
    end

    end
end

end





