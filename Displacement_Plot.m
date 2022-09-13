%% ___________Displacement_Plot____________%%
clear all 
close all 
clc

h5_file='ucrm_sol_103.h5';
bdf_file='uCRM_SOL_103.bdf';
% h5Data   = h5extract(h5_file);
% C=0.1;
% Displ_ID=h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.ID;
% Displ_x=C*h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X;
% Displ_y=C*h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y;
% Displ_z=C*h5Data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z;
% Displ_Magnitude=sqrt(Displ_x.^2+Displ_y.^2+Displ_z.^2);

% [remaining_bdf,gridpoints] = gridpoint_extractor(bdf_file);
% Grid_ID=gridpoints(:,1);
% Grid_x=gridpoints(:,2);
% Grid_y=gridpoints(:,3);
% Grid_z=gridpoints(:,4);
% 
% % Dx=Grid_x+Displ_x;
% % Dy=Grid_y+Displ_y;
% % Dz=Grid_z+Displ_z;
% 
% Displacement=figure(1);
% axs = axes;
% view(3);
% daspect([1 1 1]);
% h = triad('Parent',axs,'Scale',6,'LineWidth',2,'Tag','Triad Example','Matrix',makehgtform('xrotate',0,'zrotate',0,'translate',[0,0,0]));
% H = get(h,'Matrix');
% axis equal
% grid on 
% grid minor
% scatter3(Grid_x,Grid_y,Grid_z,1,[0.19 0.07 0.23])
% hold on

% colormap turbo;
% colorbar;
% title(colorbar,'Displacement','fontweight','bold')
% 
% % cb = colorbar;  % create and label the colorbar
% cb.Colormap=jet;
% cb.Label.String = 'Displacement(m)';

% scatter3(Dx,Dy,Dz,10,Displ_Magnitude,'filled')    % draw the scatter plot
% ax = gca;
% ax.XDir = 'reverse';
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% 
% % text(Dx(end),Dy(end),Dz(end),'Deformed','HorizontalAlignment','right')
% % text(Grid_x(end),Grid_y(end),Grid_z(end),'Undeformed','HorizontalAlignment','right')
% 
% hold off

% Compare=figure(2);
% 
% axs = axes;
% view(3);
% daspect([1 1 1]);
% h = triad('Parent',axs,'Scale',3,'LineWidth',1,'Tag','Triad Example','Matrix',makehgtform('xrotate',0,'zrotate',0,'translate',[0,0,0]));
% H = get(h,'Matrix');
% axis equal
% grid on 
% grid minor
% scatter3(Grid_x,Grid_y,Grid_z,4,[0.19 0.07 0.23],'filled')
% hold on
% 
% scatter3(Dx,Dy,Dz,4,[0.5 0.0 0.1],'filled')    % draw the scatter plot
% ax = gca;
% ax.XDir = 'reverse';
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% set(gca,'FontName','Palatino Linotype')
% 
% legend('Undeformed','Deformed','Location','Best');
% 
% hold off


h5Data   = h5extract(h5_file);
[remaining_bdf,gridpoints] = gridpoint_extractor(bdf_file);
Grid_ID=gridpoints(:,1);
Grid_x=transpose(gridpoints(:,2));
Grid_y=transpose(gridpoints(:,3));
Grid_z=transpose(gridpoints(:,4));

NoGrid=length(Grid_ID);
NoModes=length(h5Data.NASTRAN.RESULT.SUMMARY.EIGENVALUE.MODE);

vector_x=h5Data.NASTRAN.RESULT.NODAL.EIGENVECTOR.X;
vector_y=h5Data.NASTRAN.RESULT.NODAL.EIGENVECTOR.Y;
vector_z=h5Data.NASTRAN.RESULT.NODAL.EIGENVECTOR.Z;

i=NoModes;
j=length(vector_x)/NoModes;

vector_x = transpose(reshape(vector_x,[j,i]));
vector_y = transpose(reshape(vector_y,[j,i]));
vector_z = transpose(reshape(vector_z,[j,i]));

coefficient=100; 

for i = 3
Dx(1,:)=Grid_x+0*vector_x(i,:);
Dy(1,:)=Grid_y+0*vector_y(i,:);
Dz(1,:)=Grid_z+coefficient*vector_z(i,:); 
end

grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')
axis equal



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

figure(1)
fill3(x,y,z,[0 0.4470 0.7410],'FaceAlpha',0.5,EdgeColor='none')
title('Undeformed State','fontweight','bold')
axis equal
xlabel('x(m)')
ylabel('y(m)')
zlabel('z(m)')
set(gca,'FontName','Palatino Linotype')
ax = gca;
ax.XDir = 'reverse';

figure(2)
fill3(dx,dy,dz,[0.6350 0.0780 0.1840],'FaceAlpha',0.5,EdgeColor='none')
title('Deformed State','fontweight','bold')


axis equal
xlabel('x(m)')
ylabel('y(m)')
zlabel('z(m)')
set(gca,'FontName','Palatino Linotype')
ax = gca;
ax.XDir = 'reverse';

% Dx=Grid_x+Displ_x;
% Dy=Grid_y+Displ_y;
% Dz=Grid_z+Displ_z;

% Displacement=figure(1);
% axs = axes;
% view(3);
% daspect([1 1 1]);
% h = triad('Parent',axs,'Scale',6,'LineWidth',3,'Tag','Triad Example','Matrix',makehgtform('xrotate',0,'zrotate',0,'translate',[0,0,0]));
% H = get(h,'Matrix');
% axis equal
% grid on 
% grid minor
% scatter3(Grid_x,Grid_y,Grid_z,1,'blue')
% hold on
% scatter3(Dx,Dy,Dz,10,Displ_Magnitude,'filled')    % draw the scatter plot
% ax = gca;
% ax.XDir = 'reverse';
% xlabel('x(m)')
% ylabel('y(m)')
% zlabel('z(m)')
% cb = colorbar;  % create and label the colorbar
% cb.Label.String = 'Displacement(m)';
% set(gca,'FontName','Palatino Linotype')