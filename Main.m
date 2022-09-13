%% _______________________Main_____________________%%

clear all
close all 
clc

tic;


x  = [0.25,0.8,18,2,18,2,15,2,10,2,25,4];
%% Design Variables
DesignVariables.Geometry.Spars.FrontSpar.Location.Tip=x(1);
DesignVariables.Geometry.Spars.FrontSpar.Location.Root=x(1);
DesignVariables.Geometry.Spars.FrontSpar.Thickness.Root=x(3);
DesignVariables.Geometry.Spars.FrontSpar.Thickness.Tip=x(4); % <root

DesignVariables.Geometry.Spars.RearSpar.Location.Tip=x(2);
DesignVariables.Geometry.Spars.RearSpar.Location.Root=x(2);
DesignVariables.Geometry.Spars.RearSpar.Thickness.Root=x(5);
DesignVariables.Geometry.Spars.RearSpar.Thickness.Tip=x(6); % <root

DesignVariables.Geometry.Stringers.Properties.L.H=0.03;
DesignVariables.Geometry.Stringers.Properties.L.W=0.03;
DesignVariables.Geometry.Stringers.Properties.L.t1=0.008;
DesignVariables.Geometry.Stringers.Properties.L.t2=0.008;
DesignVariables.Geometry.Stringers.Properties.L.offset=0.01;

DesignVariables.Geometry.Stringers.Properties.Hat.H=0.015;
DesignVariables.Geometry.Stringers.Properties.Hat.t=0.004;
DesignVariables.Geometry.Stringers.Properties.Hat.W=0.03;
DesignVariables.Geometry.Stringers.Properties.Hat.W1=0.01;
DesignVariables.Geometry.Stringers.Properties.Hat.offset=0.013;

DesignVariables.Geometry.Ribs.NoRibs=x(11);
DesignVariables.Geometry.Ribs.Thickness.Root=x(7);
DesignVariables.Geometry.Ribs.Thickness.Tip=x(8); % <root

DesignVariables.Geometry.Skin.Thickness.Root=x(9);
DesignVariables.Geometry.Skin.Thickness.Tip=x(10); % <root

DesignVariables.Geometry.Stringers.NoStringer=x(12);

DesignVariables.Materials.Aluminum.Young=69e9;
DesignVariables.Materials.Aluminum.Poisson=0.3;
DesignVariables.Materials.Aluminum.Density=2770;

DesignVariables.Materials.Steel.Young=200e9;
DesignVariables.Materials.Steel.Poisson=0.3;
DesignVariables.Materials.Steel.Density=7800;

DesignVariables.Materials.Titanium.Young=120e9;
DesignVariables.Materials.Titanium.Poisson=0.3;
DesignVariables.Materials.Titanium.Density=4110;

DesignVariables.NoGeometryVariables=15;

Setup.Settings.Mesh.Size=0.5;
Setup.Settings.Mesh.Type='Quad4';
Setup.Settings.No_Spline_Points_Per_Rib=10;

Span=29.38;
%% Delete Previous File
% delete uCRM.db
% delete uCRM.db.jou
% delete patran.ses.01
% delete patran.ses.02
% delete patran_conf.ini
% delete ucrm.log
% delete ucrm.f04
% delete ucrm.f06
% delete ucrm.h5
% delete ucrm.xdb
% delete uCRM.bdf

delete_files;

%% Calling  Structural_SES_Creator
[X,Y,Z,breakrib,Nribs,Scale2,Fuel_Mass_kg,Mass_Coord,Attach_Points,Rotate2,CY,q2,q3,q4,q5]=Structural_SES_Creator(DesignVariables,Setup);
[x,Yu,Yl] = Airfoil_Coord_Matching;

%% Running Patran to export bdf
% use -b if you want to run on batch mode -ans yes 
% patran.exe mscfld -db uCRM
executable='patran.exe';
argument='C:\MSC.Software\Patran_x64\20190\bin\exe\patran.exe  -skin -db uCRM  -sfp Structural.ses.txt -ans yes -b ';
[~,~ ] =system(argument);
wait_for_exe('Initial bdf export',executable)

%% Find Nodes for Lumped Mass Attaching
[Mass_Attach_Nodes]=Mass_Nodes_Extractor(Attach_Points,DesignVariables.Geometry.Ribs.NoRibs); 

%% Export Individual BDFs and Run Lumped Mass SES
export_bdfs;
Fuel_Mass_kg=ones(1,25);
[Mass_Node]=Mass_SES(Mass_Coord,Mass_Attach_Nodes,DesignVariables.Geometry.Ribs.NoRibs,Fuel_Mass_kg);

executable='patran.exe';
argument='C:\MSC.Software\Patran_x64\20190\bin\patran.exe -ifile init_fld.pcl -skin -db uCRM  -sfp Structural.ses.txt -ans yes -b ';
run_exe(executable,argument)
wait_for_exe('Export bdfs by group',executable)

argument='C:\MSC.Software\Patran_x64\20190\bin\patran.exe -ifile init_fld.pcl -skin -db uCRM  -sfp Lumped_Mass.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('Lumped masses generation',executable)

%% Calling Spline_Points function
Target_Points='Input_Data\Spline_Points\R_SPL.txt';
Nodes='uCRM.bdf';
[NearestID]=Spline_Points(Target_Points,Nodes);

%% Calling Aero_SES_Creator 
[~,Grid] = gridpoint_extractor('uCRM.bdf');
Aero_SES_Creator(X,Y,Z,breakrib,Nribs,Scale2,NearestID,Mass_Node,Grid);

%% Running Patran for aerodynamic setup and analysis in nastran
executable='patran.exe';
argument='C:\MSC.Software\Patran_x64\20190\bin\patran.exe -ifile init_fld.pcl -skin -db uCRM  -sfp Aero.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('SOL 144',executable)

%% Check for errors and messages
messages('ucrm.f06')

%% Mass Max Von Mises and Max Displacment
[LE,TE] = LE_TE_Ribs(q2,q3,q4,q5,CY,Rotate2,Scale2,X,Y,Z,DesignVariables.Geometry.Ribs.NoRibs);
[Mass,Max_VM,Max_Displ,Tip_Torsion,Tip_Deflection_Percent] = SOL_144_Obj_Cons(DesignVariables.Geometry.Ribs.NoRibs,Span);
disp(Mass)
disp(Max_VM)
disp(Max_Displ)
disp(sum(Fuel_Mass_kg))

%% Running the SOL 103 (Normal Modes)
executable='patran.exe';
argument='C:\MSC.Software\Patran_x64\20190\bin\patran.exe -ifile init_fld.pcl -skin -db uCRM  -sfp SOL_103_Normal_Modes.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('SOL 103',executable)
messages('ucrm_sol_103.f06')

%% Extract Minimum Eigenfrequncy
h5_file='ucrm_sol_103.h5';
[Min_EigFreq]=SOL_103_Obj_Cons(h5_file);

%% Objective and Constraints Group

f(1)=Mass;
g(1)=Min_EigFreq;
g(2)=Max_VM;
g(3)=abs(Tip_Torsion);
g(4)=Tip_Deflection_Percent;

%% Structural and Aero Plots
% [figure_counter]=Structural_Plots(h5_file,bdf_file);
% 
% %% Aero Plot 
% 
% [figure_counter]=Aero_Plots(h5_file,figure_counter);
% bdf_plot

h5data=h5extract(h5_file);
fclose('all');

toc

