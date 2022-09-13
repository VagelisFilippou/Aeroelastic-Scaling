% function bdf_plot
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

Color{1}=[0 0 0];
Color{2}=[0 0 0];
Color{3}=[0 76 153];
Color{4}=[0 76 153];
Color{5}=[0 76 153];
Color{6}=[0 76 153];
Color{7}=[0 76 153];
Color{8}=[0 76 153];
Color{9}=[255 51 51];
Color{10}=[255 51 51];
Color{11}=[255 51 51];

X(1)=0;Y(1)=0;Z(1)=0;
X(2)=0;Y(2)=0;Z(2)=0;

X(3)=0;Y(3)=0;Z(3)=2.5;
X(5)=0;Y(5)=0;Z(5)=2.5;
X(8)=0;Y(8)=0;Z(8)=2.5;

X(4)=0;Y(4)=0;Z(4)=-2.5;
X(6)=0;Y(6)=0;Z(6)=-2.5;
X(7)=0;Y(7)=0;Z(7)=-2.5;

X(9)=0;Y(9)=0;Z(9)=0;
X(10)=0;Y(10)=0;Z(10)=0;
X(11)=0;Y(11)=0;Z(11)=0;

for i=1:No_Components
[ID{i},Element{i},Grid{i},Stress{i},Thickness{i},Displacement{i}]=QUAD_ELEMENT(File{i},X(i),Y(i),Z(i));
[ID_T{i},Element_T{i},Grid_T{i},Stress_T{i},Thickness_T{i},Displacement_T{i}]=TRIA_ELEMENT(File{i},X(i),Y(i),Z(i));
end
[BAR,BEAM]=Beam_Bar_Elements;

f(1)=figure(1);
hold on
for i=1:No_Components
fill{i}=fill3(Element{1,i}.X,Element{1,i}.Y,Element{1,i}.Z,Color{1,i}/255,'FaceAlpha',0.6,EdgeColor='none');
if isempty(ID_T{i})==0
fill3(Element_T{1,i}.X,Element_T{1,i}.Y,Element_T{1,i}.Z,Color{1,i}/255,'FaceAlpha',0.6,EdgeColor='none')
end
end
for i=1:length(BAR)
    p1=plot3(BAR{1,i}(:,1),BAR{1,i}(:,2),BAR{1,i}(:,3),'Color',[255 255 153]/255,LineWidth=0.5);
end
for i=1:length(BEAM)
    p2=plot3(BEAM{1,i}(:,1),BEAM{1,i}(:,2),BEAM{1,i}(:,3),'Color',[255 204 153]/255,LineWidth=0.5);
end

axis equal
axis off
view(45,45);
ax = gca;
ax.Clipping = 'off';
h= legend([fill{1,1}(1,1),fill{1,3}(1,1),fill{1,9}(1,1),p1,p2], {'Spars','Skin','Ribs','Stringers','Spar Caps'},'interpreter','latex');
legend Location south
legend Orientation horizontal 
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
zoom(1.5);

f(2)=figure(2);
hold on
for i=1:No_Components
fill3(Element{1,i}.X,Element{1,i}.Y,Element{1,i}.Z,Stress{1,i},'FaceAlpha',1,EdgeColor='none')
if isempty(ID_T{i})==0
fill3(Element_T{1,i}.X,Element_T{1,i}.Y,Element_T{1,i}.Z,Stress_T{1,i},'FaceAlpha',1,EdgeColor='none')
end
end
hold off
axis equal
axis off
view(45,45);
ax = gca;
ax.Clipping = 'off';
colormap turbo;
c=colorbar;
title(c,'[Pa]','fontweight')
c.Location = 'southoutside';
c.Position(4) = 0.3*c.Position(4);
c.Position(3) = 0.2;
c.Position(1) =0.4;
c.Box='off';
set(gca,'FontName','Palatino Linotype')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
view(45,45);
zoom(1.5);
clear c

f(3)=figure(3);
hold on
for i=1:No_Components
fill3(Element{1,i}.X,Element{1,i}.Y,Element{1,i}.Z,Thickness{1,i},'FaceAlpha',1,EdgeColor='none')
if isempty(ID_T{i})==0
fill3(Element_T{1,i}.X,Element_T{1,i}.Y,Element_T{1,i}.Z,Thickness_T{1,i},'FaceAlpha',1,EdgeColor='none')
end
end
axis equal
axis off
view(45,45);
ax = gca;
ax.Clipping = 'off';
colormap turbo;
c=colorbar;
title(c,'[m]','fontweight')
c.Location = 'southoutside';
c.Position(4) = 0.3*c.Position(4);
c.Position(3) = 0.2;
c.Position(1) =0.4;
c.Box='off';
set(gca,'FontName','Palatino Linotype')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
view(45,45);
zoom(1.5);
clear c

f(4)=figure(4);
hold on
for i=1:No_Components
fill3(Element{1,i}.X,Element{1,i}.Y,Element{1,i}.Z,Displacement{1,i},'FaceAlpha',1,EdgeColor='none')
if isempty(ID_T{i})==0
fill3(Element_T{1,i}.X,Element_T{1,i}.Y,Element_T{1,i}.Z,Displacement_T{1,i},'FaceAlpha',1,EdgeColor='none')
end
end
axis equal
axis off
view(45,45);
ax = gca;
ax.Clipping = 'off';
colormap turbo;
c=colorbar;
title(c,'[m]','fontweight')
c.Location = 'south';
c.Position(4) = 0.3*c.Position(4);
c.Position(3) = 0.2;
c.Position(1) =0.4;
c.Box='off';
set(gca,'FontName','Palatino Linotype')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
view(45,45);
zoom(1.5);
clear c

f(5)=figure(5);
hold on
m=[1 2];
for j=1:2
    i=m(j);
    fill{i}=fill3(Element{1,i}.X,Element{1,i}.Y,Element{1,i}.Z,Color{1,i}/255,'FaceAlpha',0.6);
    if isempty(ID_T{i})==0
    fill3(Element_T{1,i}.X,Element_T{1,i}.Y,Element_T{1,i}.Z,Color{1,i}/255,'FaceAlpha',0.6)
end
end
[rbe,mn,ap]=RBE3(5);
axis equal
axis off
view(45,45);
ax = gca;
ax.Clipping = 'off';
legend Location south
legend Orientation horizontal 
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
zoom(1.5);
h= legend([rbe,mn,ap], {'RBE3','CONM','Attach Points'},'interpreter','latex');

fileName{1} = sprintf('Exploded_View.jpg');
fileName{2}=sprintf('Stress_Distribution.jpg');
fileName{3}=sprintf('Thickness_Distribution.jpg');
fileName{4}=sprintf('Displacement_Distrbution.jpg');
fileName{5}=sprintf('RBE3.jpg');

for i=1:5
fullFileName = fullfile('Figures\Structural', fileName{i});
% saveas(f(i),fullFileName);
exportgraphics(figure(i),fullFileName,'Resolution',600);
end
