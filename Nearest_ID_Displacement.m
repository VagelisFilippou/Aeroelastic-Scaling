function [D]=Nearest_ID_Displacement(Target_Points,Nodes,h5_file,Displ_txt)
% Find the nearest nodes to target points in full scale
[Full_Scale_IDs]=Spline_Points(Target_Points,Nodes);

% Compute Displacemetnts for full scale nearest nodes
h5data=h5extract(h5_file);
D(:,1)=h5data.NASTRAN.RESULT.NODAL.DISPLACEMENT.X(Full_Scale_IDs);
D(:,2)=h5data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y(Full_Scale_IDs);
D(:,3)=h5data.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z(Full_Scale_IDs);

fileID=fopen(Displ_txt,'w');
fprintf(fileID,'%f %f %f\n',D);
fclose(fileID);
