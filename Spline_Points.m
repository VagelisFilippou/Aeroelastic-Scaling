%________________Nearest_ID_Function________________%
% clear all
% This function's purpose is to read the bdf file and a file that contains
% some target points for splining and return the nearest gridpoints to them  
% Target_Points='Input_Data\Spline_Points\LE_TE_SPL.txt';
% Nodes='uCRM.bdf';
% [NearestIDS]=Spline_Point(Target_Points,Nodes);
% clear all
% points='Input_Data\Spline_Points\R_SPL.txt';
% bdf_file='uCRM_Ribs.bdf';
% [NearestID] = Spline_Point(points,bdf_file);

function [NearestID] = Spline_Points(points,bdf_file)
if ~isfolder('Figures')
 mkdir Figures
end
if ~isfolder('Figures')
 mkdir Figures
 newsubfolder = fullfile('Figures', 'Splining');
 mkdir(newsubfolder)
end

% Topology='z=0'
% clear all; close all; clc;
fid = fopen(points) ;
% if points=='Input_Data\Spline_Points\R_SPL.txt'
    C = textscan(fid, '%f %f %f');
% else
%     C = textscan(fid, '%s %f %f %f %s %s');
% end
fclose(fid);
[remaining_bdf,gridpoints] = gridpoint_extractor(bdf_file);

% h5_file = 'ucrm.h5';
% h5Data   = h5extract(h5_fil
% e);

% if points=='Input_Data\Spline_Points\R_SPL.txt'
P(:,1)=C{1,1};
P(:,2)=C{1,2};
P(:,3)=C{1,3};
% else
% P(:,1)=C{1,2};
% P(:,2)=C{1,3};
% P(:,3)=C{1,4};
% end
% if Topology ~= 'z=0'
%     P(:,3)=0;
% end
PQ=zeros(length(gridpoints),3);
ID=gridpoints(:,1);
PQ(:,1)=gridpoints(:,2);
PQ(:,2)=gridpoints(:,3);
PQ(:,3)=gridpoints(:,4);

% PQ=h5Data.NASTRAN.INPUT.NODE.GRID.X;
% PQ=transpose(PQ);

% P=[0 0 0;1 10 1;2 2 20 ;0 29 0; 10 1 1 ; 2 15 0];
% L = 28; W = 29; H = -1;
% pick plenty of random points
% P(:,1) = L*rand(1,100); %x-coordinate of a point
% P(:,2) = W*rand(1,100); %y-coordinate of a point
% P(:,3) = H*rand(1,100); %z-coordinate of a point

[k,dist] = dsearchn(PQ,P);

% figure(1)
% plot3(PQ(:,1),PQ(:,2),PQ(:,3),'.')
% hold on
% plot3(P(:,1),P(:,2),P(:,3),'*g')
% hold on
% plot3(PQ(k,1),PQ(k,2),PQ(k,3),'*r')
% legend('Grid','Target Points','Nearest Points','Location','sw')
% axis equal
% box on

offset=1:length(dist);
b = num2str(k); c = cellstr(b);
dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
% 
% figure(2)
% plot(offset,dist)
% text(offset+dx, dist+dy, c);
% legend('Distance From Target Points','Location','best')
% grid on 
% grid minor
% box on 
% 
% figure(3)
% plot3(P(:,1),P(:,2),P(:,3),'*g')
% legend('Target Points','Location','sw')
% axis equal 
% box on 

for i=1:length(k)
NearestID(i)=k(i);

end

fileName{1} = sprintf('Nearest_Points.jpg');
fileName{2}=sprintf('Distance.jpg');
fileName{3}=sprintf('Target.jpg');
% 
% for i=1:3
% fullFileName = fullfile('Figures\Splining', fileName{i});
% % saveas(f(i),fullFileName);
% exportgraphics(figure(i),fullFileName,'Resolution',500);
% 
% end

% end