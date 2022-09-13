%% ___________Aero_SES_File_Creator___________ %%

% This script creates the txt file that contains all the pcl commands tha
% define the geometry and creates the structural mesh. Given the design
% data structure can achieve any design.

function [GN]=Aero_SES_Creator(X,Y,Z,breakrib,Nribs,Scale2,NearestID,Mass_Node,Grid)
% open ses file
fidw = fopen('Aero.ses.txt', 'w');

% %% Export mass property report
% fid2=fopen("Input_Data\STRUCTURAL_SES_CREATOR\Mass_Report_Generation.txt","rt");
% S = textscan(fid2,'%s','delimiter','\n') ;
% S = S{1} ;
% fclose(fid2);
% fprintf(fidw, '%s\n',S{:});

%% Group creation of structural nodes for splining
fprintf(fidw,'%s\n','sys_poll_option( 2 )');
fprintf(fidw,'%s\n','ga_group_create( "SPL" )');
command='\nga_group_entity_add( "SPL", "Node %1.0f" )\n';
for i=1:length(NearestID)

fprintf(fidw,command,NearestID(i));
% fprintf(fidw,'%s\n','ga_group_current_set( "SPL" )');
% fprintf(fidw,'%s\n','sys_poll_option( 0 )');
end

%% Create aerodynamic surfaces
% create the points that define the surface
%L.E.
xaero(1,1)=X(1,1);
yaero(1,1)=Y(1,1);
xaero(1,2)=X(1,breakrib);
yaero(1,2)=Y(1,breakrib);
xaero(1,3)=X(1,Nribs+1);
yaero(1,3)=Y(1,Nribs+1);
%T.E.
xaero(1,4)=X(1,1)+Scale2(1,1);
yaero(1,4)=Y(1,1);
xaero(1,5)=X(1,breakrib)+Scale2(1,breakrib);
yaero(1,5)=Y(1,breakrib);
xaero(1,6)=X(1,Nribs+1)+Scale2(1,Nribs+1);
yaero(1,6)=Y(1,Nribs+1);

for i=1:6
    pointnumber(1,i)=i;
end

for i=1:6
aeropoints(1,i)=pointnumber(1,i);
aeropoints(2,i)=xaero(1,i);
aeropoints(3,i)=yaero(1,i);
end

aerocom =[ 'STRING asm_create_grid_xyz_created_ids[VIRTUAL]\n'...
    'asm_const_grid_xyz( "%1.0f", "[%1.5f %1.5f 0]", "Coord 0", asm_create_grid_xyz_created_ids )\n'];
fprintf(fidw,aerocom,aeropoints);

%create lines
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10001", "Point 1", "Point 2", 0, "", 50., 1, asm_line_2point_created_ids )\n');
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10002", "Point 2", "Point 3", 0, "", 50., 1, asm_line_2point_created_ids )\n');
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10003", "Point 4", "Point 5", 0, "", 50., 1, asm_line_2point_created_ids )\n');
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10004", "Point 5", "Point 6", 0, "", 50., 1, asm_line_2point_created_ids )\n');
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10005", "Point 1", "Point 4", 0, "", 50., 1, asm_line_2point_created_ids )\n');
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10006", "Point 2", "Point 5", 0, "", 50., 1, asm_line_2point_created_ids )\n');
fprintf(fidw,'STRING asm_line_2point_created_ids[VIRTUAL]\nasm_const_line_2point( "10007", "Point 3", "Point 6", 0, "", 50., 1, asm_line_2point_created_ids )\n');

%create surface
fprintf(fidw,'STRING sgm_surface_4edge_created_ids[VIRTUAL]\n');
fprintf(fidw,'sgm_const_surface_4edge( "100001", "Curve 10005", "Curve 10003", "Curve 10001", "Curve 10006", sgm_surface_4edge_created_ids )\n');
fprintf(fidw,'sgm_const_surface_4edge( "100002", "Curve 10004", "Curve 10006", "Curve 10007", "Curve 10002", sgm_surface_4edge_created_ids )\n');
fprintf(fidw,'sys_poll_option( 2 )\nga_group_create( "AeroSurf" )\nga_group_entity_add( "AeroSurf", "Surface 100001:100002" )\nsys_poll_option( 0 )\n');

%% _____________________Set up the analysis______________________ %%


%% Load Cases Creation

%constraints
fprintf(fidw,'loadcase_create2( "Constraints", "Static", "", 1., ["Fix"], [0], [1.], "", 0., TRUE )\n');


% GN(1,1)=Mass_Node(1,1);
% GN(2,1)=Mass_Node(1,end);
% GN(3,1)=Grid(1,1);
% GN(4,1)=Grid(end,1);
% 
% Gravity=['loadsbcs_create2( "Gravity", "Acceleration", "Nodal", "", "Static", [ @\n'...
% '"Node %1.0f:%1.0f %1.0f:%1.0f"], "FEM", "Coord 0", "1.", ["< 0 0 -10  >",  @\n'...
% '"< 0 0 0 >", "<     >", "<     >"], ["", "", "", ""] )\n'];
% 
% fprintf(fidw,Gravity,GN);

fid1=fopen('Input_Data\AERO_SES_CREATOR\SOL_144_3.ses.txt','rt');
S = textscan(fid1,'%s','delimiter','\n') ;
S = S{1} ;
fclose(fid1);

fprintf(fidw, '%s\n',S{:});

fclose(fidw);


% %% Switch to aeroelasticity
% 
% fprintf(fidw,'uil_pref_analysis.set_analysis_preference( "MSC.Nastran", "Aeroelasticity", ".bdf", ".op2", "No Mapping" )\n');
% 
% %% Flat plate aero modelling
% 
% fprintf(fidw,'flat_plate_surf_create( "ls_wing_1st", [0., 0., 0.], [0., 0., 0.], 0., 0., 100001, 1, 0, "None", 0, ["empty"], 9, 5, [0., 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.], [0., 0.25, 0.5, 0.75, 1.], FALSE, "Surface 100001", 0, TRUE)\n');
% fprintf(fidw,'flat_plate_surf_create( "ls_wing_2nd", [0., 0., 0.], [0., 0., 0.], 0., 0., 200001, 1, 0, "None", 0, ["empty"], 9, 5, [0., 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.], [0., 0.25, 0.5, 0.75, 1.], FALSE, "Surface 100002", 0, TRUE)\n');

%% Splines

% fprintf(fidw,'flds_spline_create( "sp_wing_1", "Finite Plate", ["General", "Rigid Attach", "10", "10"], "", ["SPL"], "", ["ls_wing_1st", "ls_wing_2nd"] )\n');

% %% Characteristics of the model 
% 
% fprintf(fidw,'fields_create_general( "SUPER_GROUP_AeroSG2D", 2, 5, 2, "Real", "Coord 0", "", 0, 0, 0, 0 )\n');
% fprintf(fidw,'fields_create_general_term( "SUPER_GROUP_AeroSG2D", 0, 0, 0, 128,"35.295399*13.616*480.58215*Coord 0*3*1.226*Half Model" )\n');
% fprintf(fidw,'fields_create_general( "STRUCT_MODEL_-1", 2, 5, 2, "Real","Coord 0", "", 0, 0, 0, 0 )\n');
% fprintf(fidw,'fields_create_general_term( "STRUCT_MODEL_-1", 0, 0, 0, 250,"TRUE*0.*TRUE*Lumped*0.1*TRUE*721*TRUE*FALSE*20.*FALSE*0.1*TRUE" )\n');
% 
% %% Analysis Data
% 
% fprintf(fidw,'mscnastran_subcase.create_char_param( "LOAD CASE", "Constraints" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO SUBCASE METHOD NAME", "Rigid Trim" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "DISPLACEMENTS", "1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "DISPLACEMENTS 1","DISPLACEMENT(SORT1,REAL)=0" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "ELEMENT STRESSES", "1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "ELEMENT STRESSES 1","STRESS(SORT1,REAL,VONMISES,BILIN)=0;PARAM,NOCOMPS,1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "CONSTRAINT FORCES", "1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "CONSTRAINT FORCES 1","SPCFORCES(SORT1,REAL)=0" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERODYNAMIC FORCES", "1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERODYNAMIC FORCES 1", "AEROF=0" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERODYNAMIC PRESSURES", "1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERODYNAMIC PRESSURES 1", "APRES=0" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "SUBCASE WRITE", "ON" )\n');
% fprintf(fidw,'mscnastran_subcase.create_int_param( "SUBCASE INPUT 0", 0 )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "PERFORM ERROR ANALYSIS", "ON" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO BOUNDARY SYMMETRY FLAG","Symmetric" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO GROUND SYMMETRY FLAG","Asymmetric" )\n');
% fprintf(fidw,'mscnastran_subcase.create_real_param( "AERO MACH NUMBER", 0.60000002 )\n');
% fprintf(fidw,'mscnastran_subcase.create_real_param( "AERO DYNAMIC PRESSURE", 20000. )\n');
% fprintf(fidw,'mscnastran_subcase.create_real_param( "AERO VELOCITY", 0. )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO AIC FLAG", "TRUE" )\n');
% fprintf(fidw,'mscnastran_subcase.create_int_param( "AERO RB MOTION 0", 11 )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 1", "ANGLEA" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 2", "SIDES" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 3", "ROLL" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 4", "PITCH" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 5", "YAW" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 6", "URDD1" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 7", "URDD2" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 8", "URDD3" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 9", "URDD4" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 10", "URDD5" )\n');
% fprintf(fidw,'mscnastran_subcase.create_char_param( "AERO RB MOTION 11", "URDD6" )\n');
% fprintf(fidw,'analysis_create.step_matrix_param( "MSC.Nastran", "144__1g_lowspeed_high_alt","AERO USE ARRAY", 1, 11, [-1., -2., -2., -2., -2., -2., -2., -1., -2., -2.,-2.] )\n');
% fprintf(fidw,'analysis_create.step_matrix_param( "MSC.Nastran", "144__1g_lowspeed_high_alt","AERO ARRAY OF FIXED VALUES", 1, 11, [0.15000001, 0., 0., 0., 0., 0., 0., 1.,0., 0., 0.] )\n');
% 
% t=['analysis_create.step_matrix_param( "MSC.Nastran", "144__1g_lowspeed_high_alt", @\n'...
% '"AERO LINK FACTOR MATRIX", 11, 11, [[0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,  @\n'...
% '0.][0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.][0., 0., 0., 0., 0., 0., 0.,  @\n'...
% '0., 0., 0., 0.][0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.][0., 0., 0., 0.,  @\n'...
% '0., 0., 0., 0., 0., 0., 0.][0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.][0.,  @\n'...
% '0., 0., 0., 0., 0., 0., 0., 0., 0., 0.][0., 0., 0., 0., 0., 0., 0., 0., 0.,  @\n'...
% '0., 0.][0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.][0., 0., 0., 0., 0., 0.,  @\n'...
% '0., 0., 0., 0., 0.][0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]] )\n'];
% fprintf(fidw,t);
% 
% fprintf(fidw,'mscnastran_subcase.create_int_param( "AERO NUMBER OF RESTRAINED NODES", 1 )\n');
% fprintf(fidw,'analysis_create.step_matrix_param( "MSC.Nastran", "144__1g_lowspeed_high_alt","AERO ARRAY OF RESTRAINED NODES", 1, 1, [297.] )\n');
% fprintf(fidw,'analysis_create.step_matrix_param( "MSC.Nastran", "144__1g_lowspeed_high_alt","AERO MATRIX OF DOF", 1, 1, [35.] )\n');
% 
% fclose(fidw)
end