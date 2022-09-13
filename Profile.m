function [x,Yu,Yl]=Profile(N)

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

% %% plot
% 
% figure(3)
% plot(xu,yu)
% hold on 
% plot(xl,yl)
% axis equal
% title('Profile Coordinates')
% grid on 
% grid minor;
% set(gca,'FontName','Palatino Linotype')

%% Convert points to match in x for upper and lower

space=1/N;
x=0:space:1;

for i=1:length(x)
    j=x(i);
    Yu(i)= interp1(xu,yu,j);
    Yl(i)= interp1(xl,yl,j);
    Ym_Catia(i)= interp1(MC_x,MC_y,j);
end

Yu(1)=yu(1);
Yl(1)=yl(1);

% FIGURE(4)=figure(4);
% hold on 
% plot(x,Yu,Color=[0 0.4470 0.7410],LineWidth=1.5)
% plot(x,Yl,Color=[0.4940 0.1840 0.5560],LineWidth=1.5)
% axis equal
% % title('Construction of Mean Camber Line')
% legend('Upper','Lower',Location='best')
% % grid on 
% % grid minor;
% axis off
% set(findall(FIGURE(4),'-property','Interpreter'),'Interpreter','latex') 
% set(findall(FIGURE(4),'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')