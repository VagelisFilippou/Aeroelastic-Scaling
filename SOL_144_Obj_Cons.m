%% Objectives
function [Mass,Max_VM,Max_Displ,Tip_Torsion,Tip_Deflection_Percent] = SOL_144_Obj_Cons(Nribs,Span)
% clear all 
% close all 

h5_file='ucrm.h5';
h5_data=h5extract(h5_file);

%% Structural Mass of the Model
Mass_File='uCRM_Mass.rpt.01';
fid = fopen(Mass_File,'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
S = S{1} ;
fclose(fid);
Mass=S{11,1};
Mass=str2num(Mass);
Mass=Mass(2);

%% Calculate Maximum Von Mises Stress
VM_1= sqrt(h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X1.^2+h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y1.^2 ...
-h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X1.*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y1+ ...
3*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.TXY1.^2);
VM_1(2:5,:)=[];
VM_1=VM_1(:);
VM_1_Max=max(VM_1);

VM_2= sqrt(h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X2.^2+h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y2.^2 ...
-h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X2.*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.Y2+ ...
3*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.TXY2.^2);
VM_2(2:5,:)=[];
VM_2=VM_2(:);
VM_2_Max=max(VM_2);

Max_VM_QUAD4=max(VM_2_Max,VM_1_Max);

if isfield(h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS,'TRIA3')==1
VM_1= sqrt(h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.X1.^2+h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.Y1.^2 ...
-h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.X1.*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.Y1+ ...
3*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.TXY1.^2);
VM_1(1,:)=[];
VM_1=VM_1(:);
VM_1_Max=max(VM_1);

VM_2= sqrt(h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.X2.^2+h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.Y2.^2 ...
-h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.X2.*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.Y2+ ...
3*h5_data.NASTRAN.RESULT.ELEMENTAL.STRESS.TRIA3.TXY2.^2);
VM_2(1,:)=[];
VM_2=VM_2(:);
VM_2_Max=max(VM_2);

Max_VM_TRIA3=max(VM_2_Max,VM_1_Max);

Max_VM=max(Max_VM_QUAD4,Max_VM_TRIA3);
else
    Max_VM=Max_VM_QUAD4;
end

Displ_Magn=sqrt(h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X.^2+ ...
    h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y.^2+h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z.^2);

Max_Displ=max(Displ_Magn);

%% Calculate Wing Tip Torsion

Target_Points='Input_Data\Objective\LE_POINTS\LE';
Nodes='uCRM.bdf';
[LE_IDs]=Spline_Points(Target_Points,Nodes);

Target_Points='Input_Data\Objective\TE_POINTS\TE';
Nodes='uCRM.bdf';
[TE_IDs]=Spline_Points(Target_Points,Nodes);

for i =1:length(TE_IDs)
    LE(1,i)=h5_data.NASTRAN.INPUT.NODE.GRID.X(1,LE_IDs(i));
    LE(2,i)=h5_data.NASTRAN.INPUT.NODE.GRID.X(2,LE_IDs(i));
    LE(3,i)=h5_data.NASTRAN.INPUT.NODE.GRID.X(3,LE_IDs(i));
end

for i =1:length(TE_IDs)
    TE(1,i)=h5_data.NASTRAN.INPUT.NODE.GRID.X(1,TE_IDs(i));
    TE(2,i)=h5_data.NASTRAN.INPUT.NODE.GRID.X(2,TE_IDs(i));
    TE(3,i)=h5_data.NASTRAN.INPUT.NODE.GRID.X(3,TE_IDs(i));
end

for i =1:length(TE_IDs)
    LE_D(1,i)=h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X(LE_IDs(i))+h5_data.NASTRAN.INPUT.NODE.GRID.X(1,LE_IDs(i));
    LE_D(2,i)=h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y(LE_IDs(i))+h5_data.NASTRAN.INPUT.NODE.GRID.X(2,LE_IDs(i));
    LE_D(3,i)=h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z(LE_IDs(i))+h5_data.NASTRAN.INPUT.NODE.GRID.X(3,LE_IDs(i));
end

for i =1:length(TE_IDs)
    TE_D(1,i)=h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X(TE_IDs(i))+h5_data.NASTRAN.INPUT.NODE.GRID.X(1,TE_IDs(i));
    TE_D(2,i)=h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y(TE_IDs(i))+h5_data.NASTRAN.INPUT.NODE.GRID.X(2,TE_IDs(i));
    TE_D(3,i)=h5_data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z(TE_IDs(i))+h5_data.NASTRAN.INPUT.NODE.GRID.X(3,TE_IDs(i));
end

for i=1:Nribs+1
Twist_Init(i)=rad2deg(atan(LE(3,i)-TE(3,i))./(-LE(1,i)+TE(1,i)));
Twist_Fin(i)=rad2deg(atan(LE_D(3,i)-TE_D(3,i))/(-LE_D(1,i)+TE_D(1,i)));
end
Torsion_Angle=Twist_Fin-Twist_Init;

Tip_Torsion=Torsion_Angle(end);

%% Wing Tip Vertical Deflection

Tip_Deflection=max(abs(TE_D(3,end)),abs(LE_D(3,end)));
Tip_Deflection_Percent=(Tip_Deflection/Span)*100;


[Coords] = uCRM_MDO;

