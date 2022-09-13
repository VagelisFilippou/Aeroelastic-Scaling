 % function [f,g]=Optimization_Run_1(x)

clear all

% x(1:11)    = 16; 
% x(12:22)   = 14; 
% x(23:33)   = 12; 
% x(34:44)   = 10; 
% x(45:55)   = 7; 
% x(56:66)   = 3; 
% x(67)      = 0.1;
% x(68)      = 0.6;
% x(69)      = 30;
% x(70)      = 12;
%x=problem.x(:);

% fid = fopen("Design_Points.txt",'rt') ;
% S = textscan(fid,'%f','delimiter','\n') ;
% fclose(fid);
% 
% NoEval=length(S{1, 1})/76;
% 
% x=S{1,1};
% x=transpose(reshape(x,[76,NoEval]));
% x=x(250,:);

% %% Objective Function
% fid = fopen("MIDACO_SOLUTION.TXT",'rt') ;
% S = textscan(fid,'%s','delimiter','\n') ;
% fclose(fid);
% S = S{1} ;
% idx =~contains(S,'f(X)');
% S(idx) = [];
% STR=extractAfter(S,'=');
% F_X=str2double(STR(:,1));
% 
% %% Design Points in Obj Function
% NoV=70;
% NoEv=length(F_X);
% 
% fid = fopen("MIDACO_SOLUTION.TXT",'rt') ;
% S = textscan(fid,'%s','delimiter','\n') ;
% fclose(fid);
% S = S{1} ;
% idx =~contains(S,'x(');
% S(idx) = [];
% S=transpose(reshape(S,[NoV,NoEv]));
% S = extractBetween(S,"=",";");
% X_ = str2double(S);
% 
% x=X_(end,:);

%% Objective Function
fid = fopen("MIDACO_SOLUTION_Run_2.TXT",'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx =~contains(S,'f(X)');
S(idx) = [];
STR=extractAfter(S,'=');
F_X=str2double(STR(:,1));

%% Design Points in Obj Function
NoV=70;
NoEv=length(F_X);

fid = fopen("MIDACO_SOLUTION_Run_2.TXT",'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx =~contains(S,'x(');
S(idx) = [];
S=transpose(reshape(S,[NoV,NoEv]));
S = extractBetween(S,"=",";"); 
X_ = str2double(S);
x=X_(end,:);

%% Geometry of uCRM from MDO Lab 
[Geometry_Data]=uCRM_MDO;
CRM_Mean_Chord=sum(Geometry_Data.Chord)/length(Geometry_Data.Chord);

%% Design Variables
DesignVariables.Flow_Condition.Mach=0.65;
DesignVariables.Flow_Condition.Altitude=0; % ft
DesignVariables.Flow_Condition.Altitude_Meters=DesignVariables.Flow_Condition.Altitude*0.3048;
[T, a, P, rho] = atmosisa(DesignVariables.Flow_Condition.Altitude_Meters);
[T0, a0, P0, rho0] = atmosisa(0);
DesignVariables.Flow_Condition.Velocity=a*DesignVariables.Flow_Condition.Mach;
DesignVariables.Flow_Condition.Density_Ratio=rho/rho0;

DesignVariables.Scale=1;
DesignVariables.Mean_Chord=CRM_Mean_Chord*DesignVariables.Scale;
DesignVariables.Span=29.38*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.NoRibs=x(69);
DesignVariables.Geometry.Stringers.NoStringer=x(70);
DesignVariables.Dy=DesignVariables.Span/DesignVariables.Geometry.Ribs.NoRibs;

DesignVariables.Geometry.Spars.FrontSpar.Location.Tip=x(67);
DesignVariables.Geometry.Spars.FrontSpar.Location.Root=x(67);
DesignVariables.Geometry.Spars.FrontSpar.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Spars.FrontSpar.Thickness= [x(1) x(12) x(23) x(34) x(45) x(56)]*0.001;

DesignVariables.Geometry.Spars.RearSpar.Location.Tip=x(68);
DesignVariables.Geometry.Spars.RearSpar.Location.Root=x(68);
DesignVariables.Geometry.Spars.RearSpar.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Spars.RearSpar.Thickness= [x(2) x(13) x(24) x(35) x(46) x(57)]*0.001;

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
DesignVariables.Geometry.Ribs.MainRib.Thickness= [x(3) x(14) x(25) x(36) x(47) x(58)]*0.001;
DesignVariables.Geometry.Ribs.FrontRib.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.FrontRib.Thickness= [x(4) x(15) x(26) x(37) x(48) x(59)]*0.001;
DesignVariables.Geometry.Ribs.RearRib.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Ribs.RearRib.Thickness= [x(5) x(16) x(27) x(38) x(49) x(60)]*0.001;

DesignVariables.Geometry.Skin.MainLower.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.MainLower.Thickness= [x(6) x(17) x(28) x(39) x(50) x(61)]*0.001;

DesignVariables.Geometry.Skin.MainUpper.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.MainUpper.Thickness= [x(7) x(18) x(29) x(40) x(51) x(62)]*0.001;

DesignVariables.Geometry.Skin.FrontUpper.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.FrontUpper.Thickness=[x(8) x(19) x(30) x(41) x(52) x(63)]*0.001;
DesignVariables.Geometry.Skin.FrontLower.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.FrontLower.Thickness= [x(9) x(20) x(31) x(42) x(53) x(64)]*0.001;

DesignVariables.Geometry.Skin.RearUpper.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.RearUpper.Thickness= [x(10) x(21) x(32) x(43) x(54) x(65)]*0.001;
DesignVariables.Geometry.Skin.RearLower.ControlPoints=[0 5 10 15 20 29.38]*DesignVariables.Scale;
DesignVariables.Geometry.Skin.RearLower.Thickness= [x(11) x(22) x(33) x(44) x(55) x(66)]*0.001;

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

Setup.Settings.Mesh.Size=0.4*DesignVariables.Scale;
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
mass_all=Mass+sum(Fuel_Mass_kg);
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
% 
% %% Run SOL 145 
% patfl='C:\MSC.Software\MSC_Nastran\20190\bin\nastranw.exe uCRM_SOL_145.bdf';
% [~,~ ] =system(patfl);
% wait_for_exe('SOL 145','nastran.exe')
% [vfl]=flutterconv2();
% 
% %% Objective and Constraints Group
% f(1)=Mass;
% g(1)=Min_EigFreq;
% g(2)=Max_VM;
% g(3)=abs(Tip_Torsion);
% g(4)=Tip_Deflection_Percent;
% g(5)=sum(Fuel_Mass_kg);
% g(5)=vfl; %>1.2*221.7 ft/s
% 
% % %% Structural and Aero Plots
% % % [figure_counter]=Structural_Plots(h5_file,bdf_file);
% % % 
% % % %% Aero Plot 
% % % 
% % % [figure_counter]=Aero_Plots(h5_file,figure_counter);
% % 
% % % bdf_plot
% % 
% % 
