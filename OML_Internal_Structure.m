clear all 
close all 
clc
if ~isfolder('Figures')
 mkdir Figures
end
if ~isfolder('Figures\Structural')
%  mkdir Figures
 newsubfolder = fullfile('Figures', 'Structural');
 mkdir(newsubfolder)
end

No_Components=11;

File{1}='uCRM_FrontSpar.bdf';
File{2}='uCRM_RearSpar.bdf';
File{3}='uCRM_UpperMainSkin.bdf';
File{4}='uCRM_LowerMainSkin.bdf';
File{5}='uCRM_FrontUpperSkin.bdf';
File{6}='uCRM_FrontLowerSkin.bdf';
File{7}='uCRM_RearLowerSkin.bdf';
File{8}='uCRM_RearUpperSkin.bdf';
File{9}='uCRM_FrontRib.bdf';
File{10}='uCRM_RearRib.bdf';
File{11}='uCRM_MainRib.bdf';

Dark_Grey=[32 32 32]/255;
Light_Grey=[32 32 32]/255;

Color{1}=Dark_Grey;
Color{2}=Dark_Grey;
Color{3}=Dark_Grey;
Color{4}=Dark_Grey;
Color{5}=Light_Grey;
Color{6}=Light_Grey;
Color{7}=Light_Grey;
Color{8}=Light_Grey;
Color{9}=Light_Grey;
Color{10}=Light_Grey;
Color{11}=Dark_Grey;

TRNSPRC=[0.2 0.2 0.2 0.2 0.1 0.1 0.1 0.1 0.1 0.1 0.2];

X(1)=0;Y(1)=0;Z(1)=0;
X(2)=0;Y(2)=0;Z(2)=0;

X(3)=0;Y(3)=0;Z(3)=0;
X(5)=0;Y(5)=0;Z(5)=0;
X(8)=0;Y(8)=0;Z(8)=0;

X(4)=0;Y(4)=0;Z(4)=0;
X(6)=0;Y(6)=0;Z(6)=0;
X(7)=0;Y(7)=0;Z(7)=0;

X(9)=0;Y(9)=0;Z(9)=0;
X(10)=0;Y(10)=0;Z(10)=0;
X(11)=0;Y(11)=0;Z(11)=0;

m=[1 2 3 4 11];
for j=1:5
 i=m(j);
[ID{i},Element{i},Grid{i},Stress{i},Thickness{i},Displacement{i}]=QUAD_ELEMENT(File{i},X(i),Y(i),Z(i));
[ID_T{i},Element_T{i},Grid_T{i},Stress_T{i},Thickness_T{i},Displacement_T{i}]=TRIA_ELEMENT(File{i},X(i),Y(i),Z(i));
end

f(1)=figure(1);
hold on
for j=1:5
i=m(j);
fill{i}=fill3(Element{1,i}.X,Element{1,i}.Y,Element{1,i}.Z,Color{1,i}/255,'FaceAlpha',TRNSPRC(i));
if isempty(ID_T{i})==0
fill3(Element_T{1,i}.X,Element_T{1,i}.Y,Element_T{1,i}.Z,Color{1,i}/255,'FaceAlpha',TRNSPRC(i))
end
end
lightangle(gca,-45,30)
lighting gouraud

axis equal
axis off
view(45,45);
ax = gca;
ax.Clipping = 'off';
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
zoom(1.5);