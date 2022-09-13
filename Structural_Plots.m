%% ___________Displacement_Plot____________%%

clear all;close all;clc 
h5_file = 'ucrm.h5';
bdf_file='uCRM.bdf';

% function[figure_counter]=Structural_Plots(h5_file,bdf_file)

h5Data = h5extract(h5_file);

% function [figures] =Displacement_Plo(h5_file,bdf_file)
opengl software
figure_counter=1;

addpath(genpath('images'))
 
if ~isfolder('Results')
 mkdir Results
 newsubfolder = fullfile('Results', 'Figures');
 mkdir(newsubfolder)
end

h5Data   = h5extract(h5_file);
Displ_ID=h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.ID;
Displ_x=h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X;
Displ_y=h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y;
Displ_z=h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z;
Displ_Magnitude=sqrt(Displ_x.^2+Displ_y.^2+Displ_z.^2);

[remaining_bdf,gridpoints] = gridpoint_extractor(bdf_file);
Grid_ID=gridpoints(:,1);
Grid_x=gridpoints(:,2);
Grid_y=gridpoints(:,3);
Grid_z=gridpoints(:,4);

Dx=Grid_x+Displ_x;
Dy=Grid_y+Displ_y;
Dz=Grid_z+Displ_z;

% figures(1)=figure(figure_counter);
% axs = axes;
% view(3);
% daspect([1 1 1]);
% h = triad('Parent',axs,'Scale',6,'LineWidth',2,'Tag','Triad Example','Matrix',makehgtform('xrotate',0,'zrotate',0,'translate',[0,0,0]));
% H = get(h,'Matrix');
% axis equal
% grid on 
% grid minor
% scatter3(Grid_x,Grid_y,Grid_z,1,[0.19 0.07 0.23],'MarkerFaceAlpha',.2)
% hold on

% colormap turbo;
% colorbar;
% title(colorbar,'Displacement','fontweight','bold')

% cb = colorbar;  % create and label the colorbar
% cb.Colormap=jet;
% cb.Label.String = 'Displacement(m)';

% scatter3(Dx,Dy,Dz,10,Displ_Magnitude,'filled','MarkerFaceAlpha',.2)    % draw the scatter plot
% ax = gca;
% ax.XDir = 'reverse';
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')

% hold on
% imagesc(Z)

% text(Dx(end),Dy(end),Dz(end),'Deformed','HorizontalAlignment','right')
% text(Grid_x(end),Grid_y(end),Grid_z(end),'Undeformed','HorizontalAlignment','right')

% butplotwell;

figure_counter=figure_counter+1;

% figures(2)=figure(figure_counter);
% axs = axes;
% view(3);
% daspect([1 1 1]);
% h = triad('Parent',axs,'Scale',3,'LineWidth',1,'Tag','Triad Example','Matrix',makehgtform('xrotate',0,'zrotate',0,'translate',[0,0,0]));
% H = get(h,'Matrix');
% axis equal
% grid on 
% grid minor
% scatter3(Grid_x,Grid_y,Grid_z,4,[0.19 0.07 0.23],'filled','MarkerFaceAlpha',.2)
% hold on
% 
% scatter3(Dx,Dy,Dz,4,[0.5 0.0 0.1],'filled','MarkerFaceAlpha',.2)    % draw the scatter plot
% ax = gca;
% ax.XDir = 'reverse';
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% legend('Undeformed','Deformed','Location','Best');

% butplotwell;

% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% __________________________Surface_Figures____________________________ %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h5Data.NASTRAN.INPUT.NODE.GRID.X(4,:)=Dx;
h5Data.NASTRAN.INPUT.NODE.GRID.X(5,:)=Dy;
h5Data.NASTRAN.INPUT.NODE.GRID.X(6,:)=Dz;

for i=1:4
for j = 1:length(h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.EID)

x(i,j)=h5Data.NASTRAN.INPUT.NODE.GRID.X(1,h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
y(i,j)=h5Data.NASTRAN.INPUT.NODE.GRID.X(2,h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
z(i,j)=h5Data.NASTRAN.INPUT.NODE.GRID.X(3,h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));

dx(i,j)=h5Data.NASTRAN.INPUT.NODE.GRID.X(4,h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
dy(i,j)=h5Data.NASTRAN.INPUT.NODE.GRID.X(5,h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));
dz(i,j)=h5Data.NASTRAN.INPUT.NODE.GRID.X(6,h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(i,j));

end
end

summ=0;
for i=1:length(h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.EID)
for j=1:4
    summ=Displ_Magnitude(h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.G(j,i))+summ;
end
    C(i)=summ/4;
    summ=0;
end

Stress=h5Data.NASTRAN.RESULT.ELEMENTAL.STRESS.QUAD_CN.X1(2,:);

% figures(3)=figure(figure_counter);
% 
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% 
% subplot(2,2,1)
% 
% fill3(x,y,z,Stress,'FaceAlpha',1,EdgeColor='none')
% title(subplot(2,2,1),'Stress Distribution','fontweight','bold')
% axis equal
% colormap turbo;
% colorbar;
% title(colorbar,'[Pa]','fontweight','bold')
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% ax = gca;
% ax.XDir = 'reverse';
% ax.YDir = 'reverse';
% 
% for i =1:length(h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.PID)
%     Thickness(i)=h5Data.NASTRAN.INPUT.PROPERTY.PSHELL.T(h5Data.NASTRAN.INPUT.ELEMENT.CQUAD4.PID(i));
% end
% 
% subplot(2,2,2)
% 
% fill3(x,y,z,Thickness,'FaceAlpha',1,EdgeColor='none')
% title(subplot(2,2,2),'Thickness Distribution','fontweight','bold')
% axis equal
% colormap turbo;
% colorbar;
% title(colorbar,'[m]','fontweight','bold')
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% ax = gca;
% ax.XDir = 'reverse';
% 
% subplot(2,2,3)
% 
% fill3(x,y,z,[0 0.4470 0.7410],'FaceAlpha',0.3,EdgeColor='none')
% title(subplot(2,2,3),'Undeformed State','fontweight','bold')
% axis equal
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% ax = gca;
% ax.XDir = 'reverse';
% 
% subplot(2,2,4)
% 
% fill3(dx,dy,dz,[0.6350 0.0780 0.1840],'FaceAlpha',0.3,EdgeColor='none')
% title(subplot(2,2,4),'Deformed State','fontweight','bold')
% 
% axis equal
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% ax = gca;
% ax.XDir = 'reverse';
% 
% figure_counter=figure_counter+1;

figures(4)=figure(figure_counter);
hold on 
fill3(x,y,z,[0 0.4470 0.7410],'FaceAlpha',1,EdgeColor='none')
fill3(dx,dy,dz,[0.6350 0.0780 0.1840],'FaceAlpha',1,EdgeColor='none')
set(gca,'visible','off')


% figure_counter=figure_counter+1;
% 
% figures(6)=figure(figure_counter);
% fill3(x,y,z,C,'FaceAlpha',1,EdgeColor='none')
% title('Displacement Distribution','fontweight','bold')
% axis equal
% colormap turbo;
% colorbar;
% title(colorbar,'[m]','fontweight','bold')
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% ax = gca;
% ax.XDir = 'reverse';
% ax.YDir = 'reverse';
% 
% figure_counter=figure_counter+1;
% 
% figures(7)=figure(figure_counter);
% fill3(x,y,z,Stress,'FaceAlpha',1,EdgeColor='none')
% title('Stress Distribution','fontweight','bold')
% axis equal
% colormap turbo;
% colorbar;
% title(colorbar,'[Pa]','fontweight','bold')
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% ax = gca;
% ax.XDir = 'reverse';
% ax.YDir = 'reverse';
% view(0,-45)
% 
% figure_counter=figure_counter+1;
% 
% fileName{1} = sprintf('Contour_Plot_Displacement.fig');
% fileName{2}=sprintf('Deformed_Undeformed.fig');
% fileName{3}=sprintf('Stress_Thickness_Deformed_Undeformed.fig');
% fileName{4}=sprintf('Mesh.fig');
% fileName{5}=sprintf('Deformed_Mesh.fig');
% fileName{6}=sprintf('Displacement_Surface.fig');
% fileName{7}=sprintf('Stress.fig');
% 
% for i=1:figure_counter-1
% 
% fullFileName = fullfile('Results\Figures', fileName{i});
% % exportgraphics(figures(i),fullFileName,'Resolution',300);
% % saveas(figures(i),fullFileName);
% 
% % Export mesh to vtk format 
% % vtkwrite('Input_Data\Displacement_Plot\uCRM.vtk','polydata','tetrahedron',Grid_x,Grid_y,Grid_z,tetra);
% 
% end
% 
% end