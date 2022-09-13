%%__________________________________________Aerodynamic_Plots_____________________________________________%%
clear all
close all 
% function[figure_counter]=Aero_Plots(h5_file,figure_counter)
if ~isfolder('Figures')
 mkdir Figures
end
if ~isfolder('Figures\Aerodynamic')
%  mkdir Figures
 newsubfolder = fullfile('Figures', 'Aerodynamic');
 mkdir(newsubfolder)
end

figure_counter=1;
h5_file='ucrm.h5';

%% import analysis results
h5Data=h5extract(h5_file);
Pressure=h5Data.NASTRAN.RESULT.AERODYNAMIC.PRESSURE.COEF  ;
Force=h5Data.NASTRAN.RESULT.AERODYNAMIC.FORCE.T3;
Lift=sum(sum(h5Data.NASTRAN.RESULT.AERODYNAMIC.FORCE.T3));
a=Lift/133750;
%% Nodes
points='Input_Data\VLM_Correction\Aero_grid_3.txt';
fid = fopen(points) ;
C = textscan(fid, '%s %f %f %f %s %s');
fclose(fid);

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
x=cell(Nx,Ny+1);
y=cell(Nx,Ny+1);
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

%% Element matrices
% y(:,32)=[];
% x(:,32)=[];
% 
Xc(:,Ny_1+1)=[];
Yc(:,Ny_1+1)=[];
c_element(:,Ny_1+1)=[];

y_fill3=y(:);
y_fill3= cell2mat(y_fill3);
y_fill3=transpose(y_fill3);
y_fill3(:,901:930)=[];
% 
x_fill3=x(:);
x_fill3= cell2mat(x_fill3);
x_fill3=transpose(x_fill3);
x_fill3(:,901:930)=[];
% 
z_fill3=zeros(size(x_fill3));

%% CP Plot
CP_Plot(figure_counter,x_fill3,y_fill3,z_fill3,Pressure);
figure_counter=figure_counter+1;
fileName{1} = sprintf('Coefficient_of_Pressure.jpg');

%% Force plot
Lift_Plot(figure_counter,x_fill3,y_fill3,z_fill3,Force);
figure_counter=figure_counter+1;
fileName{2} = sprintf('Lift.jpg');

%% Force vectors in CP plot
Force_Vector=10*h5Data.NASTRAN.RESULT.AERODYNAMIC.FORCE.T3/max(abs(h5Data.NASTRAN.RESULT.AERODYNAMIC.FORCE.T3));
i=Nx;
j=Ny;
Force_Vector = (reshape(Force_Vector,[i,j]));
Lift_Distribution(figure_counter,x_fill3,y_fill3,z_fill3)
figure_counter=figure_counter+1;
fileName{3} = sprintf('Lift_Distribution.jpg');
% for i=1:length(Xc(:,1))
%     for j=1:length(Xc(1,:))
%         
%         mArrow3([Xc(i,j) Yc(i,j) 0],[Xc(i,j) Yc(i,j) Force_Vector(i,j) ],'stemWidth',.05,'FaceAlpha',1,'color','r');
% 
%     end
% end

for i=1:length(Xc(1,:))
    Fi(i)=sum(Force_Vector(:,i));
    Ci(i)=sum(c_element(:,i));
end

Fi=6*Fi/max(Fi);

for i=1:length(Xc(1,:))
        mArrow3([Ci(i)/2+Xc(1,i) Yc(1,i) 0],[Ci(i)/2+Xc(1,i) Yc(1,i) Fi(i)],'stemWidth',.05,'tipWidth',0.1,'FaceAlpha',1,'color','r');
end


for i=1:figure_counter-1

fullFileName = fullfile('Figures\Aerodynamic', fileName{i});
% saveas(f(i),fullFileName);
exportgraphics(figure(i),fullFileName,'Resolution',500);

end

Lift=sum(sum(h5Data.NASTRAN.RESULT.AERODYNAMIC.FORCE.T3));
a=Lift/148750;