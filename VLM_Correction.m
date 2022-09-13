%%__________________________________________VLM_Inclination_Correction_Script______________________________________________%%

clear all
close all
clc

delete Input_Data\VLM_Correction\w2gj.csv
if ~isfolder('Figures')
 mkdir Figures
end
if ~isfolder('Figures')
 mkdir Figures
 newsubfolder = fullfile('Figures', 'DLM Mesh');
 mkdir(newsubfolder)
end

%% Nodes
points='Input_Data\VLM_Correction\Aero_grid_3.txt';
fid = fopen(points) ;
C = textscan(fid, '%s %f %f %f %s %s');

P(:,1)=C{1,2};
P(:,2)=C{1,4};
P(:,3)=C{1,3};
Id(:,1)=1:length(C{1,1});

Nx= 30; % Elements in x direction
Ny= 120; % Elements in y direction
Ny_1=30; % Elements in x direction of the 1st section of the wing
Nodesx=Nx+1; % Nodes in x direction
Nodesy=Ny+1; % Nodes in y direction
%% Centroid of each element

% x=cell(Nx,Ny);
% y=cell(Nx,Ny);

for i = 1: Nx
    for j = 1: Ny+1

        id(1)=(j-1)*Nodesx+i;
        id(2)=(j)*Nodesx+i;
        id(3)=(j-1)*Nodesx+i+1;
        id(4)=(j)*Nodesx+i+1;
        idx{i,j}=[id(1) id(3) id(4) id(2)];
        x{i,j}= [P(id(1),1) P(id(3),1) P(id(4),1) P(id(2),1)];
        y{i,j}= [P(id(1),3) P(id(3),3) P(id(4),3) P(id(2),3)];
        polyin = polyshape(x{i,j},y{i,j});
        [Xc(i,j),Yc(i,j)] = centroid(polyin);
        c_element(i,j)=((-P(id(1),1)+P(id(3),1))+(-P(id(2),1)+P(id(4),1)))/2 ;       
    end
end
Xc(:,Ny_1+1)=[];
Yc(:,Ny_1+1)=[];
c_element(:,Ny_1+1)=[];

y_fill3=y(:);
y_fill3= cell2mat(y_fill3);
y_fill3=transpose(y_fill3);

x_fill3=x(:);
x_fill3= cell2mat(x_fill3);
x_fill3=transpose(x_fill3);

z_fill3=zeros(size(x_fill3));

figure(1)
fill3(x_fill3,y_fill3,z_fill3,[0 0.4470 0.7410])
axis equal
ax = gca;
ax.Clipping = 'off';
axis off
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

X3_4=Xc+c_element/4;
Y3_4=Yc;

figure(2)
plot(P(:,1),P(:,3),'.g',MarkerSize=6)
hold on
xc=Xc(:);
yc=Yc(:);
plot(xc,yc,'.b',MarkerSize=6)
axis equal
hold on 
%% 3/4 of element
x3_4=X3_4(:);
y3_4=Y3_4(:);
plot(x3_4,y3_4,'.r',MarkerSize=6)
xlabel('x(m)')
ylabel('y(m)')
grid on
grid minor
set(gca,'FontName','Palatino Linotype')
legend('Nodes','Element Center','Element 3/4','Location','Best');

for i = 1: Nx
    for j = 1: Ny
        x_normalized(i,j)=(X3_4(i,j)-X3_4(1,j))/max(X3_4(:,j)-X3_4(1,j));
    end
end
%% Variables

Span=29.38;
Chord=1;% the interpolation is done in the nondimensional airfoil and because we correct the inclination it doesn't affect the sol
Nspan=10;
Nchord=10;
Dspan=Span/Nspan;
Dchord=Chord/Nchord;

% angle=correction(X,Y,Nspan,Nchord);
% function[angle]=correction(X,Y,Nspan,Nchord)

%% Load Airfoil Coordinates

%upper

fid = fopen('Input_Data\VLM_Correction\CRM_Upper.txt');
Columns = length(regexp( '[\d\.]+', 'match'));
Upper = textscan(fid,repmat('%f', 1, Columns), 'CollectOutput', true, 'Delimiter', '\b\t');
fclose(fid);

%lower

fid = fopen('Input_Data\VLM_Correction\CRM_Lower.txt');
Columns = length(regexp('[\d\.]+', 'match'));
Lower = textscan(fid, repmat('%f', 1, Columns), 'CollectOutput', true, 'Delimiter', '\b\t');
fclose(fid);

% Cell to matrix 

Upper=cell2mat(Upper);
Lower=cell2mat(Lower);

xu=Upper(:,1);
yu=Upper(:,2);
xl=Lower(:,1);
yl=Lower(:,2);

coord=[xu yu;flip(xl) flip(yl)];
Matrix_FileName{2} = 'Input_Data\VLM_Correction\coordinates.xlsx';
fullFileName = fullfile('Results', Matrix_FileName{2});
% writematrix(coord,fullFileName,'Sheet',1)

%% Load mean camber points constructed in catia

filename = 'Input_Data\VLM_Correction\Mean_Camber_Points.xlsx';
sheet = 1;
xlRange = 'B2:D51';

MC_Catia = xlsread(filename,sheet,xlRange)/1000;
MC_x=MC_Catia(:,2);
MC_y=MC_Catia(:,3);

%% plot

figure(3)
plot(xu,yu)
hold on 
plot(xl,yl)
axis equal
title('Profile Coordinates')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')

%% Convert points to match in x for upper and lower

space=0.01;
x=0:space:1;

for i=1:length(x)
    j=x(i);
    Yu(i)= interp1(xu,yu,j);
    Yl(i)= interp1(xl,yl,j);
    Ym_Catia(i)= interp1(MC_x,MC_y,j);
end

Yu(1)=yu(1);
Yl(1)=yl(1);

figure(4)
plot(x,Yu)
hold on 
plot(x,Yl)
hold on

%% Calculate camber line 

for i=1:length(x) 
    Ym(i) = (Yu(i)+Yl(i))/2; % mean camber line
end


plot(x,Ym)
hold on 
plot(x,Ym_Catia)
axis equal
title('Profile With Mean Camber Line')
legend('Upper','Lower','Mean Camber','Mean Camber Catia',Location='best')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')

%% Calculate inclination

incl=diff(Ym)/space;
incl_catia=diff(Ym_Catia)/space;
% rad to degrees
incl=-incl*180/pi();
incl_catia=-incl_catia*180/pi();

for i=1:length(x)-1 
xincl(i)=x(i)+(x(i+1)-x(i))/2;
end
xincl(1)=0;
xincl(end)=1;

figure(5)
plot(xincl,incl)
legend('1st Method',Location='best')
title('Airfoil Inclination Distribution')
xlabel('X [m]')
ylabel('Inclination [Degrees]')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')

figure(6)
plot(xincl,incl_catia)
legend('2nd Method',Location='best')
title('Airfoil Inclination Distribution')
xlabel('X [m]')
ylabel('Inclination [Degrees]')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')

figure(7)
hold on
plot(xincl,incl)
hold on
plot(xincl,incl_catia)
legend('1st Method','2nd Method',Location='best')
title('Airfoil Inclination Distribution')
xlabel('X [m]')
ylabel('Inclination [Degrees]')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')

%% load twist distribution

% fid = fopen('Input_Data\VLM_Correction\Twist.txt');
% Columns = length(regexp( '[\d\.]+', 'match'));
% Twist = textscan(fid,repmat('%f', 1, Columns), 'CollectOutput', true, 'Delimiter', '\b\t');
% fclose(fid);
% Twist=cell2mat(Twist);
% TwistAngle=Twist(:,2);
% TwistY=Twist(:,1);

[Coords] = uCRM_MDO;
TwistAngle=Coords.AoA;
TwistY=Coords.Y;
mc=sum(Coords.Chord)/length(Coords.Chord);

figure(8)
plot(TwistY,TwistAngle)
title('Wing Twist Distribution')
xlabel('Y [m]')
ylabel('Twist [Degrees]')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')

%% Construction of the correction matrix

K=zeros(Nx,Ny);
 
for i=1:Nx
    for j=1:Ny
        K(i,j)=interp1(xincl,incl,x_normalized(i,j));
        G(i,j)=interp1(TwistY,TwistAngle,Y3_4(i,j));
    end
end

ANGLES=(K+G);

figure(9)
plot3(X3_4,Y3_4,ANGLES,'LineWidth',1)
xlabel('x[m]')
ylabel('y[m]')
zlabel('Angle[Degrees]')
title('Element AoA Distribution')
grid on 
grid minor;
set(gca,'FontName','Palatino Linotype')
axis equal

%% Save to xlsx

for i =1:Nx*Ny_1
    w2gj{i,1}= ("Elem "+num2str(100000+i));
    el(i,1)=100000+i;
end
j=i;
for i=1:Nx*(Ny-Ny_1)
    w2gj{j+i,1}= ("Elem "+num2str(10001000 +i));
    el(j+i,1)=10001000+i;
end

ANGLES=num2cell(ANGLES(:));
for i =1:length(ANGLES)
w2gj{i,2} = ANGLES{i,1};
end

ANGLES=deg2rad(cell2mat(ANGLES));

Cell_FileName{1} = 'Input_Data\VLM_Correction\w2gj.csv';
fullFileName = fullfile(Cell_FileName{1});
writecell(w2gj,fullFileName)

fileName{1} = sprintf('VLM_Mesh.jpg');
fileName{2}=sprintf('W2GJ_Center.jpg');
fileName{3}=sprintf('Profile_Coord.jpg');
fileName{4}=sprintf('Prof_Mean_Camber.jpg');
fileName{5}=sprintf('Airfoil_Incl_Distribution.jpg');
fileName{6}=sprintf('Airfoil_Incl_Distribution_Catia.jpg');
fileName{7}=sprintf('Airfoil_Incl_Distribution_Together.jpg');
fileName{8}=sprintf('Wing_Twist.jpg');
fileName{9}=sprintf('Total_AoA_Distribution.jpg');

for i=1:9

fullFileName = fullfile('Figures\DLM Mesh', fileName{i});
% saveas(f(i),fullFileName);
exportgraphics(figure(i),fullFileName,'Resolution',500);

end

entry=['DMIJ    W2GJ    1       0               %-8.0f%-8.0f%-0.5f\n'];
fid=fopen('w2gj_entry.bdf','w');
fprintf(fid,entry,el(1),3,ANGLES(1));

w2gj_dmi(:,1)=el(2:2:end);
w2gj_dmi(:,2)=3*ones(Nx*Ny/2,1);
w2gj_dmi(:,3)=ANGLES(2:2:end);

w2gj_dmi(1:Nx*Ny/2-1,4)=el(3:2:end-1);
w2gj_dmi(1:Nx*Ny/2-1,5)=3*ones(Nx*Ny/2-1,1);
w2gj_dmi(1:Nx*Ny/2-1,6)=ANGLES(3:2:end-1);

w2gj_dmi(end,4)= NaN;
w2gj_dmi(end,5)= NaN;
w2gj_dmi(end,6)= NaN;

w2gj_dmi=transpose(w2gj_dmi);
entry=['        %-8.0f%-8.0f%-16.5f%-8.0f%-8.0f%-0.5f\n'];

fprintf(fid,entry,w2gj_dmi);
fclose(fid);

