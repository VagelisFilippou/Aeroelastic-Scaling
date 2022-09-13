function [x,Yu,Yl] = Airfoil_Coord_Matching
%% Load Airfoil Coordinates
fid = fopen('Input_Data\VLM_Correction\CRM_Upper.txt');
Columns = length(regexp( '[\d\.]+', 'match'));
Upper = textscan(fid,repmat('%f', 1, Columns), 'CollectOutput', true, 'Delimiter', '\b\t');
fclose(fid);
fid = fopen('Input_Data\VLM_Correction\CRM_Lower.txt');
Columns = length(regexp('[\d\.]+', 'match'));
Lower = textscan(fid, repmat('%f', 1, Columns), 'CollectOutput', true, 'Delimiter', '\b\t');
fclose(fid);
Upper=cell2mat(Upper);
Lower=cell2mat(Lower);
xu=Upper(:,1);
yu=Upper(:,2);
xl=Lower(:,1);
yl=Lower(:,2);
coord=[xu yu;flip(xl) flip(yl)];

%% Convert points to match in x for upper and lower

space=0.01;
x=0:space:1;
for i=1:length(x)
    j=x(i);
    Yu(i)= interp1(xu,yu,j);
    Yl(i)= interp1(xl,yl,j);
end
Yu(1)=yu(1);
Yl(1)=yl(1);
