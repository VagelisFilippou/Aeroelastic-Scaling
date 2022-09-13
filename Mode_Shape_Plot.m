% function bdf_plot
clear all 
close all 
clc
if ~isfolder('Figures')
 mkdir Figures
end
if ~isfolder('Figures\Modal')
%  mkdir Figures
 newsubfolder = fullfile('Figures', 'Modal');
 mkdir(newsubfolder)
end

No_Components=11;

h5_file='ucrm_sol_103.h5';
h5data=h5extract(h5_file);

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

X(3)=0;Y(3)=0;Z(3)=0;
X(5)=0;Y(5)=0;Z(5)=0;
X(8)=0;Y(8)=0;Z(8)=0;

X(4)=0;Y(4)=0;Z(4)=0;
X(6)=0;Y(6)=0;Z(6)=0;
X(7)=0;Y(7)=0;Z(7)=0;

X(9)=0;Y(9)=0;Z(9)=0;
X(10)=0;Y(10)=0;Z(10)=0;
X(11)=0;Y(11)=0;Z(11)=0;

%% Modes
C=[0.5 0.5 1]*200;

for i=3:8
[Element{i}]=QUAD_ELEMENT_MODAL(File{i},h5_file,C);
[Element_T{i}]=TRIA_ELEMENT_MODAL(File{i},h5_file,C);
end

% figure(1)
% for j=1:10
% f(j)=subplot(5,2,j);
% axis equal
% axis off
% view(210,40)
% ax = gca;
% ax.Clipping = 'off';
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% hold on
% for i=3:8
%     fill{j}=fill3(Element{1,i}.X{1,j},Element{1,i}.Y{1,j},Element{1,i}.Z{1,j}, ...
%     Color{1,i}/255,'FaceAlpha',0.6,EdgeColor='none');
% if isempty(Element_T{1,i})==0
%     fill3(Element_T{1,i}.X{1,j},Element_T{1,i}.Y{1,j},Element_T{1,i}.Z{1,j}, ...
%     Color{1,i}/255,'FaceAlpha',0.6,EdgeColor='none')
% end
% end
% zoom(f(j),6)
% 
% end
% 
% %% Undeformed
% C=[0,0,0];
% for i=3:8
% [Element{i}]=QUAD_ELEMENT_MODAL(File{i},h5_file,C);
% [Element_T{i}]=TRIA_ELEMENT_MODAL(File{i},h5_file,C);
% end
% 
% for j=1:10
% f(j)=subplot(5,2,j);
% hold on
% for i=3:8
%     hill{j}=fill3(Element{1,i}.X{1,j},Element{1,i}.Y{1,j},Element{1,i}.Z{1,j}, ...
%     [255 51 51]/255,'FaceAlpha',0.6,EdgeColor='none');
% if isempty(Element_T{1,i})==0
%     fill3(Element_T{1,i}.X{1,j},Element_T{1,i}.Y{1,j},Element_T{1,i}.Z{1,j}, ...
%     [255 51 51]/255,'FaceAlpha',0.6,EdgeColor='none')
% end
% end
% title({['Mode Number ',num2str(j)];['Eigenfrequency = ', ...
%     num2str(h5data.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(j)),'Hz']},'interpreter', 'latex');
% % set(get(gca,'title'),'Position',[1 2 0.5])
% end
% 
% fileName{1}='ModeSubplots.jpg';
% 
% for i=1
% fullFileName = fullfile('Figures\Modal', fileName{i});
% % saveas(f(i),fullFileName);
% exportgraphics(figure(i),fullFileName,'Resolution',600);
% end

for j=1:10
figure(j)
axis equal
axis off
view(210,40)
ax = gca;
ax.Clipping = 'off';
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
hold on
for i=3:8
    fill{j}=fill3(Element{1,i}.X{1,j},Element{1,i}.Y{1,j},Element{1,i}.Z{1,j}, ...
    Color{1,i}/255,'FaceAlpha',0.6,EdgeColor='none');
if isempty(Element_T{1,i})==0
    fill3(Element_T{1,i}.X{1,j},Element_T{1,i}.Y{1,j},Element_T{1,i}.Z{1,j}, ...
    Color{1,i}/255,'FaceAlpha',0.6,EdgeColor='none')
end
end
zoom(1.8)
zoom(1.2)
zoom(1.1)
zoom(1.1)
zoom(1.1)
zoom(1.1)
end

%% Undeformed
C=[0,0,0];
for i=3:8
[Element{i}]=QUAD_ELEMENT_MODAL(File{i},h5_file,C);
[Element_T{i}]=TRIA_ELEMENT_MODAL(File{i},h5_file,C);
end

for j=1:10
figure(j)
hold on
for i=3:8
    hill{j}=fill3(Element{1,i}.X{1,j},Element{1,i}.Y{1,j},Element{1,i}.Z{1,j}, ...
    [255 51 51]/255,'FaceAlpha',0.6,EdgeColor='none');
if isempty(Element_T{1,i})==0
    fill3(Element_T{1,i}.X{1,j},Element_T{1,i}.Y{1,j},Element_T{1,i}.Z{1,j}, ...
    [255 51 51]/255,'FaceAlpha',0.6,EdgeColor='none')
end
end
%title({['Mode Number ',num2str(j)];['Eigenfrequency = ', ...
%    num2str(h5data.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(j)),'Hz']},'interpreter', 'latex');
% set(get(gca,'title'),'Position',[1 2 0.5])
end

fileName{1}='mode1.eps';
fileName{2}='mode2.eps';
fileName{3}='mode3.eps';
fileName{4}='mode4.eps';
fileName{5}='mode5.eps';
fileName{6}='mode6.eps';
fileName{7}='mode7.eps';
fileName{8}='mode8.eps';
fileName{9}='mode9.eps';
fileName{10}='mode10.eps';

for i=1:10
fullFileName = fullfile('Figures\Modal', fileName{i});
% saveas(f(i),fullFileName);
exportgraphics(figure(i),fullFileName,'Resolution',100);
end

