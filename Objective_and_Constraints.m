% function [f,g]=Objective_and_Constraints(x)

%% Geometry of uCRM from MDO Lab 
[Geometry_Data]=uCRM_MDO;
CRM_Mean_Chord=sum(Geometry_Data.Chord)/length(Geometry_Data.Chord);

%% Design Variables
DesignVariables.Flow_Condition.Mach=0.85;
DesignVariables.Flow_Condition.Altitude=37000; % ft
DesignVariables.Flow_Condition.Altitude_Meters=DesignVariables.Flow_Condition.Altitude*0.3048;
[T, a, P, rho] = atmosisa(DesignVariables.Flow_Condition.Altitude_Meters);
[T0, a0, P0, rho0] = atmosisa(0);
DesignVariables.Flow_Condition.Velocity=a*DesignVariables.Flow_Condition.Mach;
DesignVariables.Flow_Condition.Density_Ratio=rho/rho0;

DesignVariables.Scale=1;
DesignVariables.Mean_Chord=CRM_Mean_Chord*DesignVariables.Scale;
DesignVariables.Span=29.38*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.NoRibs=45;
DesignVariables.Geometry.Stringers.NoStringer=12;
DesignVariables.Dy=DesignVariables.Span/DesignVariables.Geometry.Ribs.NoRibs;

DesignVariables.Geometry.Spars.FrontSpar.Location.Tip=0.2;
DesignVariables.Geometry.Spars.FrontSpar.Location.Root=0.2;
DesignVariables.Geometry.Spars.FrontSpar.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Spars.FrontSpar.Thickness= [10 6 8 6 4 2]*0.001;

DesignVariables.Geometry.Spars.RearSpar.Location.Tip=0.8;
DesignVariables.Geometry.Spars.RearSpar.Location.Root=0.8;
DesignVariables.Geometry.Spars.RearSpar.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Spars.RearSpar.Thickness= [11 9 8 6 4 2]*0.001;

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

DesignVariables.Geometry.Ribs.MainRib.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.MainRib.Thickness= [8 6 4 3 2 1]*0.001;
DesignVariables.Geometry.Ribs.FrontRib.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.FrontRib.Thickness= [8 6 4 3 2 1]*0.001;
DesignVariables.Geometry.Ribs.RearRib.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.RearRib.Thickness= [7 6 4 3 1.5 0.8]*0.001;

DesignVariables.Geometry.Skin.MainLower.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.MainLower.Thickness= [11 10 8 6 4 2]*0.001;

DesignVariables.Geometry.Skin.MainUpper.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.MainUpper.Thickness= [9 8 8 7 4 2]*0.001;

DesignVariables.Geometry.Skin.FrontUpper.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.FrontUpper.Thickness=[8 7 5 4 2 1]*0.001;
DesignVariables.Geometry.Skin.FrontLower.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.FrontLower.Thickness= [9 7 5 4 2 1]*0.001;

DesignVariables.Geometry.Skin.RearUpper.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.RearUpper.Thickness= [8 8 6 4 2 1]*0.001;
DesignVariables.Geometry.Skin.RearLower.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.RearLower.Thickness= [8 7 5 3 2 1]*0.001;

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

Setup.Settings.Mesh.Size=0.4;
Setup.Settings.Mesh.Type='Quad4';
Setup.Settings.No_Spline_Points_Per_Rib=10;

%% Delete Previous File

delete_files;

%% Calling  Structural_SES_Creator
[X,Y,Z,breakrib,Nribs,Scale2,Fuel_Mass_kg,Mass_Coord,Attach_Points,Rotate2,CY,q2,q3,q4,q5]=Structural_SES_Creator(DesignVariables,Setup);
[x,Yu,Yl] = Airfoil_Coord_Matching;

%% Running Patran to export bdf
% use -b if you want to run on batch mode -ans yes 
% patran.exe mscfld -db uCRM
executable='patran.exe';
argument='-ifile init_fld.pcl -skin -db uCRM  -sfp Structural.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('Initial bdf export',executable)

%% Find Nodes for Lumped Mass Attaching
[Mass_Attach_Nodes]=Mass_Nodes_Extractor(Attach_Points,DesignVariables.Geometry.Ribs.NoRibs); 

%% Export Individual BDFs and Run Lumped Mass SES
export_bdfs;
[Mass_Node]=Mass_SES(Mass_Coord,Mass_Attach_Nodes,DesignVariables.Geometry.Ribs.NoRibs,Fuel_Mass_kg);

executable='patran.exe';
argument='-ifile init_fld.pcl -skin -db uCRM -sfp Structural.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('Export bdfs by group',executable)

argument='-ifile init_fld.pcl -skin -db uCRM -sfp Lumped_Mass.ses.txt -ans yes -b';
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
argument='-ifile init_fld.pcl -skin -db uCRM  -sfp Aero.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('SOL 144',executable)

%% Check for errors and messages
messages('ucrm.f06')

%% Mass Max Von Mises and Max Displacment
[LE,TE] = LE_TE_Ribs(q2,q3,q4,q5,CY,Rotate2,Scale2,X,Y,Z,DesignVariables.Geometry.Ribs.NoRibs);
[Mass,Max_VM,Max_Displ,Tip_Torsion,Tip_Deflection_Percent] = SOL_144_Obj_Cons(DesignVariables.Geometry.Ribs.NoRibs,DesignVariables.Span);
disp(Mass)
disp(Max_VM)
disp(Max_Displ)
disp(sum(Fuel_Mass_kg))

%% Running the SOL 103 (Normal Modes)
executable='patran.exe';
argument='-ifile init_fld.pcl -skin -db uCRM  -sfp SOL_103_Normal_Modes.ses.txt -ans yes -b';
run_exe(executable,argument)
wait_for_exe('SOL 103',executable)
messages('ucrm_sol_103.f06')

%% Extract Minimum Eigenfrequncy
h5_file='ucrm_sol_103.h5';
[Min_EigFreq]=SOL_103_Obj_Cons(h5_file);

% %% Run Flutter Cards Creator and SOL 145 Creator
% w_min=2*pi()*Min_EigFreq;
% k_min=w_min*DesignVariables.Mean_Chord/(2*DesignVariables.Flow_Condition.Velocity);
% k_max=2;
% Flutter_Cards(k_min,k_max,DesignVariables.Flow_Condition.Density_Ratio,DesignVariables.Flow_Condition.Mach);
% SOL_145_Maker

% %% Run SOL 145 
% patfl='C:\MSC.Software\MSC_Nastran\20190\bin\nastranw.exe uCRM_SOL_145.bdf';
% [~,~ ] =system(patfl);
% wait_for_exe('SOL 145','nastran.exe')
% [vfl]=flutterconv2();

%% Objective and Constraints Group
f(1)=Mass;
g(1)=Min_EigFreq;
g(2)=Max_VM;
g(3)=abs(Tip_Torsion);
g(4)=Tip_Deflection_Percent;
% g(5)=vfl; %>920 ft/s

% %% Structural and Aero Plots
% % [figure_counter]=Structural_Plots(h5_file,bdf_file);
% % 
% % %% Aero Plot 
% % 
% % [figure_counter]=Aero_Plots(h5_file,figure_counter);
% 
% bdf_plot
% 
% 
