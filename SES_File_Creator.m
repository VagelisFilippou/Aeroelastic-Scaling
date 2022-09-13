%% ___________SES_File_Creator___________ %%

function [fidw] = SES_File_Creator(DesignVariables)

%delete previous files
delete uCRM.db
delete uCRM.db.jou
delete patran.ses.01
delete patran_conf.ini
delete ucrm.log
delete ucrm.f04
delete ucrm.f06
delete ucrm.h5
delete uCRM.bdf
delete uCRM_Mass.rpt.01
%% Design Variables

q1 = DesignVariables.Geometry.Ribs.NoRibs;% Number of Ribs
q2 = DesignVariables.Geometry.Spars.FrontSpar.Location.Root; % Front Spar Location in nondimensionalized Chord ROOT
q3 = DesignVariables.Geometry.Spars.RearSpar.Location.Root; % Rear Spar Location in nondimensionalized Chord ROOT
q4 = DesignVariables.Geometry.Spars.FrontSpar.Location.Trail; % Front Spar Location in nondimensionalized Chord TRAIL
q5 = DesignVariables.Geometry.Spars.RearSpar.Location.Trail; % Second Spar Location in nondimensionalized Chord TRAIL

q6=DesignVariables.Geometry.Stringers.Properties.L.H;
q7=DesignVariables.Geometry.Stringers.Properties.L.W;
q8=DesignVariables.Geometry.Stringers.Properties.L.t1;
q9=DesignVariables.Geometry.Stringers.Properties.L.t2;
q10=DesignVariables.Geometry.Stringers.Properties.L.offset;

q11=DesignVariables.Geometry.Stringers.Properties.Hat.H;
q12=DesignVariables.Geometry.Stringers.Properties.Hat.t;
q13=DesignVariables.Geometry.Stringers.Properties.Hat.W;
q14=DesignVariables.Geometry.Stringers.Properties.Hat.W1;
q15=DesignVariables.Geometry.Stringers.Properties.Hat.offset;

q20 = DesignVariables.Materials.Aluminum.Young; %Ealum
q21 = DesignVariables.Materials.Aluminum.Poisson; %nialum
q22 = DesignVariables.Materials.Aluminum.Density; %rhoalum
q23 = DesignVariables.Materials.Steel.Young; %Esteel
q24 = DesignVariables.Materials.Steel.Poisson; %nisteel
q25 = DesignVariables.Materials.Steel.Density; %rhosteel
q26 = DesignVariables.Materials.Titanium.Young; %Etitanium
q27 = DesignVariables.Materials.Titanium.Poisson; %nititanium
q28 = DesignVariables.Materials.Titanium.Density; %rhotitanium

UpperStringers=DesignVariables.Geometry.Stringers.NoStringer;
LowerStringers=DesignVariables.Geometry.Stringers.NoStringer;

NoV=DesignVariables.NoGeometryVariables;
NoExpr=2;
DesignMatrix=zeros(NoExpr,NoV);
name=1:NoV;
DesignMatrix(2,1)=q1;
DesignMatrix(2,2)=q2;
DesignMatrix(2,3)=q3;
DesignMatrix(2,4)=q4;
DesignMatrix(2,5)=q5;
DesignMatrix(2,6)=q6;
DesignMatrix(2,7)=q7;
DesignMatrix(2,8)=q8;
DesignMatrix(2,9)=q9;
DesignMatrix(2,10)=q10;
DesignMatrix(2,11)=q11;
DesignMatrix(2,12)=q12;
DesignMatrix(2,13)=q13;
DesignMatrix(2,14)=q14;
DesignMatrix(2,15)=q15;

for i=1:NoV
    DesignMatrix(1,i)=name(1,i);
end
Variables='REAL q%1.0f = %1.6f\n';
fidw = fopen('PCL.ses.txt', 'wt');
% fprintf(fidw,'%s\n','uil_pref_analysis.set_analysis_preference( "MSC.Nastran", "Aeroelasticity", ".bdf", ".op2", "Legacy Mapping" )');
fprintf(fidw,Variables,DesignMatrix);
fclose(fidw);

Sections=q1;
ThicknessesSkin=ones(1,Sections);
for i=1:Sections
   ThicknessesSkin(i)=(DesignVariables.Geometry.Skin.Thickness.Root-DesignVariables.Geometry.Skin.Thickness.Coefficient*(i-1)/(Sections-1))*0.001;
end

ThicknessesRibs=ones(1,Sections+1);
for i=1:Sections+1
   ThicknessesRibs(i)=(DesignVariables.Geometry.Ribs.Thickness.Root-DesignVariables.Geometry.Ribs.Thickness.Coefficient*(i-1)/(Sections))*0.001;
end

ThicknessesFSpar=ones(1,Sections);
for i=1:Sections
   ThicknessesFSpar(i)=(DesignVariables.Geometry.Spars.FrontSpar.Thickness.Root-DesignVariables.Geometry.Spars.FrontSpar.Thickness.Coefficient*(i-1)/(Sections-1))*0.001;
end

ThicknessesRSpar=ones(1,Sections);
for i=1:Sections
   ThicknessesRSpar(i)=(DesignVariables.Geometry.Spars.RearSpar.Thickness.Root-DesignVariables.Geometry.Spars.FrontSpar.Thickness.Coefficient*(i-1)/(Sections-1))*0.001;
end

%% Constant Variables

Span=29.38; %Span


%% Standard commands in the beginning of the session file such as airfoil coordinates strings and spars position etc.
fid=fopen('StandardCommands1.ses.txt','rt');
S = textscan(fid,'%s','delimiter','\n') ;
S = S{1} ;
fclose(fid);
fidw = fopen('PCL.ses.txt', 'a+');
fprintf(fidw, '%s\n',S{:});

%% Inside Variables

Nribs=q1-1; 
dy=Span/Nribs;
NoCurves=3+3+(UpperStringers+1)+(LowerStringers+1);
PointCount1=0;
CurveCommands=100;
CurveCount=ones(1,CurveCommands);
CurveCount(1)= 8;
SurfaceCount(1)=0;

%% Step 1: Interpolate points in the skin's curve and break it with them 

PointCount2=PointCount1+1;

Interpolate=['STRING asm_grid_interp_poi_created_ids[VIRTUAL]\n'...
'asm_const_grid_interp_point( "%1.0f", "Curve 7.1", "Curve 8.1", 0.,%1.0f,  @\n'...
'asm_grid_interp_poi_created_ids)\n'];
PointCount3=PointCount2+UpperStringers;
InterU(1,1)=PointCount2;
InterU(1,2)=UpperStringers;
fprintf(fidw,Interpolate,InterU);

Interpolate=['STRING asm_grid_interp_poi_created_ids[VIRTUAL]\n'...
'asm_const_grid_interp_point( "%1.0f", "Curve 7.2", "Curve 8.2", 0., %1.0f,  @\n'...
'asm_grid_interp_poi_created_ids )\n'];
PointCount4=PointCount3+LowerStringers;
InterL(1,1)=PointCount3;
InterL(1,2)=LowerStringers;
fprintf(fidw,Interpolate,InterL);

BreakUSkin=['STRING sgm_curve_break_poi_created_ids[VIRTUAL]\n'...
'sgm_edit_curve_break_point( "%1.0f", "Point %1.0f:%1.0f", "Curve 2", TRUE,  @\n'...
'sgm_curve_break_poi_created_ids )\n'...
'$? YES 38000217 \n'];
BreakUS(1,2)=CurveCount(1)+1;
BreakUS(1,2)=PointCount2;
BreakUS(1,3)=PointCount3-1;
fprintf(fidw,BreakUSkin,BreakUS);
CurveCount(2)=CurveCount(1)+(UpperStringers+1);

BreakLSkin=['STRING sgm_curve_break_poi_created_ids[VIRTUAL]\n'...
'sgm_edit_curve_break_point( "%1.0f", "Point %1.0f:%1.0f", "Curve 5", TRUE,  @\n'...
'sgm_curve_break_poi_created_ids )\n'...
'$? YES 38000217 \n'];
BreakLS(1,2)=CurveCount(2)+1;
BreakLS(1,2)=PointCount3;
BreakLS(1,3)=PointCount4-1;
fprintf(fidw,BreakLSkin,BreakLS);
CurveCount(3)=CurveCount(2)+(LowerStringers+1);

%% Delete all points and renumber curves

fprintf(fidw,'STRING asm_delete_any_deleted_ids[VIRTUAL]\n');
fprintf(fidw,'asm_delete_point( "Point 1:10000", @\n'); 
fprintf(fidw,'asm_delete_any_deleted_ids )\n'); 
fprintf(fidw,'repaint_graphics( )\n'); 
fprintf(fidw,'sgm_renumber( 1, "curve", "1", "Curve 1 3 4 6:35", sgm_renum_curve_new_ids )\n');

CurveCount(4)=NoCurves; %Because of renumber
%% Step 2: Airfoil Scaling

% C(y)=-32.256*x^6+175.03*x^5-319.96*x^4+249.99*x^3-772.99*x^2-10.642*x+13.589
n=Nribs;

for i=1:Nribs+1    
w(1,i)=i-1;
CY(1,i)=(dy*w(1,i))/Span; %Non-dimensionilized Y
end

breakrib=0;
for i=1:Nribs+1

if i>1
    if CY(1,i-1)<0.370000 && CY(1,i)>0.370000     
        cY(1,i)=0.37000;
        breakrib=i;
    else
        cY(1,i)=CY(1,i);
    end

else
        cY(1,i)=CY(1,i);
end

end

for i=1:Nribs+1-breakrib+1
    cY(1,breakrib+i)=CY(1,breakrib+i-1);
end

CY=cY;
Nribs=Nribs+1;
n=Nribs;

k=5;%for scale command matrix
Scale=[k,n];
Scale1=CurveCount(4)+1:NoCurves:CurveCount(4)+NoCurves*(Nribs+1);

for i=1:Nribs+1
%     %polynomial 
%     Scale2(1,i)=-32.256*CY(1,i)^6+175.03*CY(1,i)^5-319.96*CY(1,i)^4+249.99*CY(1,i)^3-72.99*CY(1,i)^2-10.642*CY(1,i)+13.589;
if CY(1,i)<=0.370000
Scale2(1,i)=-17.186*CY(1,i)+13.616;
else
Scale2(1,i)=-7.1904*CY(1,i)+9.9178;
end
end

for i=1:n+1
    Scale(1,i)=Scale1(1,i);
    Scale(2,i)=Scale2(1,i);
    Scale(3,i)=Scale2(1,i);
    Scale(4,i)=Scale2(1,i);
    Scale(5,i)=NoCurves;
end
ScaleStr =[ 'STRING sgm_transform_curve_created_ids[VIRTUAL]\n'...
    'sgm_transform_scale( "%1.0f", "curve",[%1.5f %1.5f %1.5f], "[0 0 0]", @\n'...
    '"Coord 0", 1, FALSE, "Curve 1:%1.0f", sgm_transform_curve_created_ids )\n'...
    '$? YES 38000217\n$? YESFORALL 1000034\n'];

fprintf(fidw,ScaleStr,Scale);

yes='$? YES 38000217';
fprintf(fidw, '%s' , yes );

CurveCount(5)=CurveCount(4)+NoCurves*(Nribs+1);
PointCount=(Nribs)*10;
    
%% Step 3:Airfoil Translate

k=7;%for translate command matrix    
Translate=[k,n+1];
Translate1=CurveCount(5)+1:NoCurves:CurveCount(5)+(Nribs+1)*NoCurves;

for i=1:Nribs+1
w(1,i)=i-1;
%     X(1,i)= -2.3605*CY(1,i).^4+2.4214*CY(1,i).^3+3.0948*CY(1,i).^2+16.612*CY(1,i)+0.0277; % x coord. fit

if CY(1,i)<=0.370000
X(1,i)=17.873*CY(1,i)-0.00331-1;% -1 from the origina l x becose patran takes it as a dublicated
else
X(1,i)=20.57*CY(1,i)-1.0136-1; %-1 from the original x to ensure continuity 
end

Y(1,i)= 29.38*CY(1,i)+3E-14 ; % y coord. fit
Z(1,i)= -3.2311*CY(1,i).^5+9.1805*CY(1,i).^4-10.259*CY(1,i).^3+6.7783*CY(1,i).^2-2.6277*CY(1,i)+0.0002 ; % z coord. fit
Magn=sqrt(abs(X.^2+Y.^2+Z.^2));  % Magnitude of the translation vector
Curve1(1,i)=NoCurves+1+(i-1)*NoCurves;
Curve2(1,i)=2*NoCurves+(i-1)*NoCurves;
end


for i=1:n+1
    Translate(1,i)=Translate1(1,i);
    Translate(2,i)=X(1,i);
    Translate(3,i)=Y(1,i);
    Translate(4,i)=Z(1,i);
    Translate(5,i)=Magn(1,i);
    Translate(6,i)=Curve1(1,i);
    Translate(7,i)=Curve2(1,i);
end
CurveCount(6)=CurveCount(5)+(Nribs+1)*NoCurves;
TranslateStr= ['STRING sgm_transform_curve_created_ids[VIRTUAL]\n'...
'sgm_transform_translate_v1( "%1.0f", "curve", "< %1.5f %1.5f %1.5f >", %1.5f,@\n'...
'FALSE, "Coord 0", 1, TRUE, "Curve %1.0f:%1.0f",@\n'...
'sgm_transform_curve_created_ids )\n'...
'$? YES 38000217\n$? YESFORALL 1000034\n']; 

fprintf(fidw,TranslateStr,Translate);

%% Step 4: Delete all points

fprintf(fidw,'STRING asm_delete_any_deleted_ids[VIRTUAL]\n');
fprintf(fidw,'asm_delete_point( "Point 1:10000", @\n'); 
fprintf(fidw,'asm_delete_any_deleted_ids )\n'); 
fprintf(fidw,'repaint_graphics( )\n'); 

%% Step 5: Create Coord System on LE 
a1=1:n+1;
a2=CurveCount(5)+1:NoCurves:CurveCount(5)+1+(Nribs)*NoCurves;
k=2;
a=[k,n];
for i=1:n+1
a(1,i)=a1(1,i);
a(2,i)=a2(1,i);
end
Coord1=['STRING asm_create_cord_eul_created_ids[VIRTUAL]\n'...
'asm_const_coord_euler( "%1.0f", 3, 1, 3, 0., -90., 0., "Coord 0", 1, "Curve %1.0f.1",@\n'...
'asm_create_cord_eul_created_ids)\n'];
fprintf(fidw,Coord1,a);

%% Step 6: Create Points on Chord/4
b1=1:n+1;
b2=Scale2./4;
k=3;
for i=1:n+1
b(1,i)=b1(1,i);
b(2,i)=b2(1,i);
b(3,i)=b1(1,i);
end
PointsC4=['STRING asm_create_grid_xyz_created_ids[VIRTUAL]\n'...
    'asm_const_grid_xyz( "%1.0f", "[%1.5f 0 0]", "Coord %1.0f",@\n'...
    'asm_create_grid_xyz_created_ids)\n'];
fprintf(fidw,PointsC4,b);

%% Step 7: Create Coord Systems on Chord/4
c1=n+2:2*(n+1);
c2=1:n+1;
k=2;
c=[k,n];
for i=1:n+1
c(1,i)=c1(1,i);
c(2,i)=c2(1,i);
end
Coord2=['STRING asm_create_cord_eul_created_ids[VIRTUAL]\n'...
    'asm_const_coord_euler( "%1.0f", 3, 1, 3, 0., -90., 0., "Coord 0", 1, "Point %1.0f",@\n'...
'asm_create_cord_eul_created_ids)\n'];
fprintf(fidw,Coord2,c);

%% Step 8: Rotate around the y axis of the c/4 coord. system 
Rotate1=CurveCount(6)+1:NoCurves:CurveCount(6)+1+(Nribs)*NoCurves;
Rotate3=c1;
for i=1:Nribs+1
Rotate2(1,i)= 154.55*CY(1,i).^6-541.7*CY(1,i).^5+687.11*CY(1,i).^4-403.73*CY(1,i).^3+130.2*CY(1,i).^2-31.614*CY(1,i)+6.6293 ;

end
Rotate4=CurveCount(5)+1:NoCurves:CurveCount(5)+1+(Nribs)*NoCurves;
Rotate5=CurveCount(5)+NoCurves:NoCurves:CurveCount(5)+NoCurves+(Nribs)*NoCurves;
k=5;
Roatate=[k,n+1];
for i=1:n+1
Rotate(1,i)=Rotate1(1,i);
Rotate(2,i)=Rotate2(1,i);
Rotate(3,i)=Rotate3(1,i);
Rotate(4,i)=Rotate4(1,i);
Rotate(5,i)=Rotate5(1,i);
end
Rotation=['STRING sgm_transform_curve_created_ids[VIRTUAL]\n'...
        'sgm_transform_rotate( "%1.0f", "curve", "{[0 0 0][0 0 1]}", %1.5f, 0.,"Coord %1.0f",@\n'...
        '1, TRUE, "Curve %1.0f:%1.0f ", sgm_transform_curve_created_ids )\n$? YES 38000217\n'];
fprintf(fidw,Rotation,Rotate);

CurveCount(7)=CurveCount(6)+(Nribs+1)*NoCurves;

%% Delete all points
fprintf(fidw,'STRING asm_delete_any_deleted_ids[VIRTUAL]\n');
fprintf(fidw,'asm_delete_point( "Point 1:10000", @\n'); 
fprintf(fidw,'asm_delete_any_deleted_ids )\n'); 
fprintf(fidw,'repaint_graphics( )\n'); 

%% Step 9 : Create L.E. Curves
d1=CurveCount(7)+1:1:CurveCount(7)+1+Nribs-1;
d2=CurveCount(6)+1:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves;
d3=CurveCount(6)+1+NoCurves:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+NoCurves;
k=3;
d=[k,n+1];
for i=1:n
d(1,i)=d1(1,i);
d(2,i)=d2(1,i);
d(3,i)=d3(1,i);
end
LEpoints=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.1 ", "Curve %1.0f.1 ", 0, "", 50., 1, @\n'...
    'asm_line_2point_created_ids )\n'];
fprintf(fidw,LEpoints,d);

CurveCount(8)=CurveCount(7)+1+Nribs-1;

%% Step 10 : Create T.E. Curves
e1=CurveCount(8)+1:1:CurveCount(8)+1+Nribs-1;
e2=CurveCount(6)+1+1:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+1;
e3=CurveCount(6)+1+1+NoCurves:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+NoCurves+1;
k=3;
e=[k,n+1];
for i=1:n
e(1,i)=e1(1,i);
e(2,i)=e2(1,i);
e(3,i)=e3(1,i);
end
TEpoints=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.2 ", "Curve %1.0f.2 ", 0, "", 50., 1, @\n'...
    'asm_line_2point_created_ids )\n'];
fprintf(fidw,TEpoints,e);

CurveCount(9)=CurveCount(8)+1+Nribs-1;

%% Step 11 : Create Rear Spar Upper Curve
f1=CurveCount(9)+1:1:CurveCount(9)+1+Nribs-1;
f2=CurveCount(6)+1+5:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+5;
f3=CurveCount(6)+1+5+NoCurves:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+NoCurves+5;
k=3;
f=[k,n+1];
for i=1:n
f(1,i)=f1(1,i);
f(2,i)=f2(1,i);
f(3,i)=f3(1,i);
end
RSUC=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.1 ", "Curve %1.0f.1 ", 0, "", 50., 1, @\n'...
    'asm_line_2point_created_ids )\n'];
fprintf(fidw,RSUC,f);

CurveCount(10)=CurveCount(9)+1+Nribs-1;

%% Step 12 : Create Rear Spar Lower Curve
g1=CurveCount(10)+1:1:CurveCount(10)+1+Nribs-1;
g2=CurveCount(6)+1+5:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+5;
g3=CurveCount(6)+1+5+NoCurves:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves+NoCurves+5;;
k=3;
g=[k,n+1];
for i=1:n
g(1,i)=g1(1,i);
g(2,i)=g2(1,i);
g(3,i)=g3(1,i);
end
RSLC=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.2 ", "Curve %1.0f.2 ", 0, "", 50., 1, @\n'...
    'asm_line_2point_created_ids )\n'];
fprintf(fidw,RSLC,g);

CurveCount(11)=CurveCount(10)+1+Nribs-1;

%% Step 13 : Create Front Spar Upper Curve
h1=CurveCount(11)+1:1:CurveCount(11)+1+Nribs-1;
h2=CurveCount(6)+1+4:NoCurves:CurveCount(6)+1+4+(Nribs-1)*NoCurves;
h3=CurveCount(6)+1+4+NoCurves:NoCurves:CurveCount(6)+1+4+(Nribs-1)*NoCurves+NoCurves;
k=3;
h=[k,n+1];
for i=1:n
h(1,i)=h1(1,i);
h(2,i)=h2(1,i);
h(3,i)=h3(1,i);
end
FSUC=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.1 ", "Curve %1.0f.1 ", 0, "", 50., 1, @\'...
    'nasm_line_2point_created_ids )\n'];
fprintf(fidw,FSUC,h);

CurveCount(12)=CurveCount(11)+1+Nribs-1;

%% Step 14 : Create Front Spar Lower Curve
i1=CurveCount(12)+1:1:CurveCount(12)+1+Nribs-1;
i2=CurveCount(6)+1+4:NoCurves:CurveCount(6)+1+4+(Nribs-1)*NoCurves;
i3=CurveCount(6)+1+4+NoCurves:NoCurves:CurveCount(6)+1+4+(Nribs-1)*NoCurves+NoCurves;
k=3;
I=[k,n+1];
for i=1:n
I(1,i)=i1(1,i);
I(2,i)=i2(1,i);
I(3,i)=i3(1,i);
end
FSLC=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.2 ", "Curve %1.0f.2 ", 0, "", 50., 1, @\'...
    'nasm_line_2point_created_ids )\n'];
fprintf(fidw,FSLC,I);

CurveCount(13)=CurveCount(12)+1+Nribs-1;

%% Step 15 : Create Stringer Curves 
for J=1:(UpperStringers)
st1=CurveCount(12+J)+1:1:CurveCount(12+J)+1+Nribs-1;
st2=CurveCount(6)+6+J:NoCurves:CurveCount(6)+6+J+(Nribs-1)*NoCurves;
st3=CurveCount(6)+6+J+NoCurves:NoCurves:CurveCount(6)+6+J+(Nribs-1)*NoCurves+NoCurves;
k=3;
I=[k,n+1];
for i=1:n
st(1,i)=st1(1,i);
st(2,i)=st2(1,i);
st(3,i)=st3(1,i);
end
StringerC=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
'asm_const_line_2point( " %1.0f ", "Curve %1.0f.2 ", "Curve %1.0f.2 ", 0, "", 50., 1, @\'...
'nasm_line_2point_created_ids )\n'];
CurveCount(13+J)=CurveCount(13+J-1)+1+Nribs-1;
fprintf(fidw,StringerC,st);
end

for J=(UpperStringers+1):(UpperStringers+LowerStringers)
st1=CurveCount(12+J)+1:1:CurveCount(12+J)+1+Nribs-1;
st2=CurveCount(6)+7+J:NoCurves:CurveCount(6)+7+J+(Nribs-1)*NoCurves;
st3=CurveCount(6)+7+J+NoCurves:NoCurves:CurveCount(6)+7+J+(Nribs-1)*NoCurves+NoCurves;
k=3;
I=[k,n+1];
for i=1:n
st(1,i)=st1(1,i);
st(2,i)=st2(1,i);
st(3,i)=st3(1,i);
end
StringerC=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
'asm_const_line_2point( " %1.0f ", "Curve %1.0f.2 ", "Curve %1.0f.2 ", 0, "", 50., 1, @\'...
'nasm_line_2point_created_ids )\n'];
CurveCount(13+J)=CurveCount(13+J-1)+1+Nribs-1;
fprintf(fidw,StringerC,st);
k=J;
end

%% Delete all points
fprintf(fidw,'STRING asm_delete_any_deleted_ids[VIRTUAL]\n');
fprintf(fidw,'asm_delete_point( "Point 1:10000", @\n'); 
fprintf(fidw,'asm_delete_any_deleted_ids )\n'); 
fprintf(fidw,'repaint_graphics( )\n'); 

%% Step : 16 Create Rib's additional curve to connect with stringers
for J=1:(UpperStringers+LowerStringers)/2
r1=CurveCount(13+(UpperStringers+LowerStringers)+J-1)+1:1:CurveCount(13+(UpperStringers+LowerStringers)+J-1)+1+Nribs;
r2=CurveCount(6)+7+J-1:NoCurves:CurveCount(6)+7+J-1+(Nribs+1)*NoCurves;
r3=CurveCount(6)+7+UpperStringers+J:NoCurves:CurveCount(6)+7+UpperStringers+J+(Nribs+1)*NoCurves;
R=[k,n+1];
for i=1:n+1
R(1,i)=r1(1,i);
R(2,i)=r2(1,i);
R(3,i)=r3(1,i);
end
RibStr=['STRING asm_line_2point_created_ids[VIRTUAL]\n'...
    'asm_const_line_2point( " %1.0f ", "Curve %1.0f.2 ", "Curve %1.0f.2 ", 0, "", 50., 1, @\'...
    'nasm_line_2point_created_ids )\n'];
fprintf(fidw,RibStr,R);

CurveCount(13+(UpperStringers+LowerStringers)+J)=CurveCount(13+(UpperStringers+LowerStringers)+J-1)+Nribs+1;

end

%% Step 17 : Create Main Rib Surfaces
dd=(UpperStringers+LowerStringers)/2+1;
for J=1:dd
j1=SurfaceCount(J)+1:1:SurfaceCount(J)+1+Nribs;
j2=CurveCount(6)+7+J-1:NoCurves:CurveCount(6)+7+J-1+(Nribs+1)*NoCurves;
j3=CurveCount(13+(UpperStringers+LowerStringers)+J-1)+1:1:CurveCount(13+(UpperStringers+LowerStringers)+J-1)+1+Nribs;
j4=CurveCount(6)+7+UpperStringers+J:NoCurves:CurveCount(6)+7+UpperStringers+J+(Nribs+1)*NoCurves;
j5=CurveCount(13+(UpperStringers+LowerStringers)+J-2)+1:1:CurveCount(13+(UpperStringers+LowerStringers)+J-2)+1+Nribs;
if J==1 
    j5=CurveCount(6)+5:NoCurves:CurveCount(6)+5+(Nribs+1)*NoCurves;
end

if J==(UpperStringers+LowerStringers)/2+1
    j3=CurveCount(6)+6:NoCurves:CurveCount(6)+6+(Nribs+1)*NoCurves;
end
k=5;
j=[k,n+1];
for i=1:n+1
j(1,i)=j1(1,i);
j(2,i)=j2(1,i);
j(3,i)=j3(1,i);
j(4,i)=j4(1,i);
j(5,i)=j5(1,i);

end
MRS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,MRS,j);
SurfaceCount(J+1)=SurfaceCount(J)+1+Nribs;
end

%% Step 18 : Create Main Upper Skin Surfaces
for J=1:dd
 
 j1=SurfaceCount(dd+J)+1:1:SurfaceCount(dd+J)+1+Nribs-1;
 j2=CurveCount(6)+7+J-1:NoCurves:CurveCount(6)+7+J-1+(Nribs)*NoCurves-1;
 j3=CurveCount(13+J-2)+1:1:CurveCount(13+J-2)+1+Nribs-1;
 j4=CurveCount(6)+7+NoCurves+J-1:NoCurves:CurveCount(6)+NoCurves+J-1+(Nribs)*NoCurves;
 j5=CurveCount(13+J)+1-Nribs:1:CurveCount(13+J)+1+Nribs-1-Nribs;
if J==1 
    j3=CurveCount(11)+1:1:CurveCount(11)+1+(Nribs);
end

if J==(UpperStringers+LowerStringers)/2+1
    j5=CurveCount(9)+1:1:CurveCount(9)+1+(Nribs)-1;
end
k=5;
j=[k,n];
for i=1:n
j(1,i)=j1(1,i);
j(2,i)=j2(1,i);
j(3,i)=j3(1,i);
j(4,i)=j4(1,i);
j(5,i)=j5(1,i);

end
MUSS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,MUSS,j);
SurfaceCount(dd+1+J)=SurfaceCount(dd+J)+Nribs;
end

%% Step 19 : Create Main Lower Skin Surfaces
for J=1:dd
 
 j1=SurfaceCount(2*dd+J)+1:1:SurfaceCount(2*dd+J)+1+Nribs-1;
 j2=CurveCount(6)+7+UpperStringers+1+J-1:NoCurves:CurveCount(6)+7+UpperStringers+1+J-1+(Nribs)*NoCurves-1;
 j3=CurveCount(13+UpperStringers+J-2)+1:1:CurveCount(13+UpperStringers+J-2)+1+Nribs-1;
 j4=CurveCount(6)+7+NoCurves+UpperStringers+1+J-1:NoCurves:CurveCount(6)+NoCurves+UpperStringers+1+J-1+(Nribs)*NoCurves;
 j5=CurveCount(13+UpperStringers+J)+1-Nribs:1:CurveCount(13+UpperStringers+J)+1+Nribs-1-Nribs;
if J==1 
    j3=CurveCount(12)+1:1:CurveCount(12)+1+(Nribs);
end

if J==dd
    j5=CurveCount(10)+1:1:CurveCount(10)+1+(Nribs)-1;
end
k=5;
j=[k,n];
for i=1:n
j(1,i)=j1(1,i);
j(2,i)=j2(1,i);
j(3,i)=j3(1,i);
j(4,i)=j4(1,i);
j(5,i)=j5(1,i);

end
MLSS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,MLSS,j);
SurfaceCount(2*dd+1+J)=SurfaceCount(2*dd+J)+Nribs;
end

%% Step 20 : Create Upper Front Skin Surfaces
SSTN=3*dd+1;%Surface Sections Till Now

j1=SurfaceCount(SSTN)+1:1:SurfaceCount(SSTN)+1+Nribs-1;
j2=CurveCount(6)+1:NoCurves:CurveCount(6)+1+(Nribs-1)*NoCurves;
j3=CurveCount(11)+1:1:CurveCount(11)+1+Nribs-1;
j4=CurveCount(7)+1:1:CurveCount(7)+1+Nribs-1;
j5=CurveCount(6)+NoCurves+1:NoCurves:CurveCount(6)+NoCurves+1+(Nribs-1)*NoCurves;
k=5;
j=[k,n+1];
for i=1:n
j(1,i)=j1(1,i);
j(2,i)=j2(1,i);
j(3,i)=j3(1,i);
j(4,i)=j4(1,i);
j(5,i)=j5(1,i);

end
UFSS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,UFSS,j);
SurfaceCount(SSTN+1)=SurfaceCount(SSTN)+1+Nribs-1;

%% Step 21 : Create Lower Front Skin Surfaces  
k1=SurfaceCount(SSTN+1)+1:1:SurfaceCount(SSTN+1)+1+Nribs-1;
k2=CurveCount(6)+3:NoCurves:CurveCount(6)+3+(Nribs-1)*NoCurves;
k3=CurveCount(12)+1:1:CurveCount(12)+1+Nribs-1;
k4=CurveCount(7)+1:1:CurveCount(7)+1+Nribs-1;
k5=CurveCount(6)+NoCurves+3:NoCurves:CurveCount(6)+NoCurves+3+(Nribs-1)*NoCurves;
K=5;
k=[k,n+1];
for i=1:n
k(1,i)=k1(1,i);
k(2,i)=k2(1,i);
k(3,i)=k3(1,i);
k(4,i)=k4(1,i);
k(5,i)=k5(1,i);

end
LFSS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,LFSS,k);
SurfaceCount(SSTN+2)=SurfaceCount(SSTN+1)+1+Nribs-1;

%% Step 22 : Create Upper Rear Skin Surfaces  
m1=SurfaceCount(SSTN+2)+1:1:SurfaceCount(SSTN+2)+1+Nribs-1;
m2=CurveCount(6)+2:NoCurves:CurveCount(6)+2+(Nribs-1)*NoCurves;
m3=CurveCount(9)+1:1:CurveCount(9)+1+Nribs-1;
m4=CurveCount(8)+1:1:CurveCount(8)+1+Nribs-1;
m5=CurveCount(6)+NoCurves+2:NoCurves:CurveCount(6)+NoCurves+2+(Nribs-1)*NoCurves;
k=5;
m=[k,n+1];
for i=1:n
m(1,i)=m1(1,i);
m(2,i)=m2(1,i);
m(3,i)=m3(1,i);
m(4,i)=m4(1,i);
m(5,i)=m5(1,i);

end
URSS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,URSS,m);
SurfaceCount(SSTN+3)=SurfaceCount(SSTN+2)+1+Nribs-1;

%% Step 23 : Create Lower Rear Skin Surfaces  
o1=SurfaceCount(SSTN+3)+1:1:SurfaceCount(SSTN+3)+1+Nribs-1;
o2=CurveCount(6)+4:NoCurves:CurveCount(6)+4+(Nribs-1)*NoCurves;
o3=CurveCount(10)+1:1:CurveCount(10)+1+Nribs-1;
o4=CurveCount(8)+1:1:CurveCount(8)+1+Nribs-1;
o5=CurveCount(6)+NoCurves+4:NoCurves:CurveCount(6)+NoCurves+4+(Nribs-1)*NoCurves;
k=5;
o=[k,n+1];
for i=1:n
o(1,i)=o1(1,i);
o(2,i)=o2(1,i);
o(3,i)=o3(1,i);
o(4,i)=o4(1,i);
o(5,i)=o5(1,i);

end
LRSS='STRING sgm_surface_4edge_created_ids[VIRTUAL]\nsgm_const_surface_4edge( " %1.0f ", "Curve %1.0f ", "Curve %1.0f ", "Curve %1.0f ", @\n"Curve %1.0f ", sgm_surface_4edge_created_ids )\n';
fprintf(fidw,LRSS,o);
SurfaceCount(SSTN+4)=SurfaceCount(SSTN+3)+1+Nribs-1;

%% Step 24 : Create Rib Front Surfaces
p1=SurfaceCount(SSTN+4)+1:1:SurfaceCount(SSTN+4)+1+Nribs;
p2=CurveCount(6)+1:NoCurves:CurveCount(6)+1+(Nribs)*NoCurves;
p3=CurveCount(6)+3:NoCurves:CurveCount(6)+3+(Nribs)*NoCurves;
p4=CurveCount(6)+5:NoCurves:CurveCount(6)+5+(Nribs)*NoCurves;

k=4;
p=[k,n+1];
for i=1:n+1
p(1,i)=p1(1,i);
p(2,i)=p2(1,i);
p(3,i)=p3(1,i);
p(4,i)=p4(1,i);
end
RIBSF=['STRING sgm_surface_3edge_created_ids[VIRTUAL]\n'...
'sgm_const_surface_3edge( "%1.0f", "Curve %1.0f", "Curve %1.0f", "Curve %1.0f",  @\n'...
'sgm_surface_3edge_created_ids )\n'];
fprintf(fidw,RIBSF,p);
SurfaceCount(SSTN+5)=SurfaceCount(SSTN+4)+1+Nribs;

%% Step 25 : Create Rib Rear Surfaces
pa1=SurfaceCount(SSTN+5)+1:1:SurfaceCount(SSTN+5)+1+Nribs;
pa2=CurveCount(6)+2:NoCurves:CurveCount(6)+2+(Nribs)*NoCurves;
pa3=CurveCount(6)+4:NoCurves:CurveCount(6)+4+(Nribs)*NoCurves;
pa4=CurveCount(6)+6:NoCurves:CurveCount(6)+6+(Nribs)*NoCurves;

k=4;
pa=[k,n+1];
for i=1:n+1
pa(1,i)=pa1(1,i);
pa(2,i)=pa2(1,i);
pa(3,i)=pa3(1,i);
pa(4,i)=pa4(1,i);
end
RIBSR=['STRING sgm_surface_3edge_created_ids[VIRTUAL]\n'...
'sgm_const_surface_3edge( "%1.0f", "Curve %1.0f", "Curve %1.0f", "Curve %1.0f",  @\n'...
'sgm_surface_3edge_created_ids )\n'];
fprintf(fidw,RIBSR,pa);
SurfaceCount(SSTN+6)=SurfaceCount(SSTN+5)+1+Nribs;

%% Step 26: Create Front Spar Surfaces
r1=SurfaceCount(SSTN+6)+1:1:SurfaceCount(SSTN+6)+1+Nribs-1;
r2=CurveCount(6)+5:NoCurves:CurveCount(6)+5+(Nribs-1)*NoCurves;
r3=CurveCount(12)+1:1:CurveCount(12)+1+Nribs-1;
r4=CurveCount(11)+1:1:CurveCount(11)+1+Nribs-1;
r5=CurveCount(6)+NoCurves+5:NoCurves:CurveCount(6)+NoCurves+5+(Nribs-1)*NoCurves;
k=5;
r=[k,n+1];
for i=1:n
r(1,i)=r1(1,i);
r(2,i)=r2(1,i);
r(3,i)=r3(1,i);
r(4,i)=r4(1,i);
r(5,i)=r5(1,i);
end

FSPAR=['STRING sgm_surface_4edge_created_ids[VIRTUAL]\n'...
'sgm_const_surface_4edge( "%1.0f", "Curve %1.0f", "Curve %1.0f", "Curve %1.0f",  @\n'...
'"Curve %1.0f", sgm_surface_4edge_created_ids )\n'];
fprintf(fidw,FSPAR,r);
SurfaceCount(SSTN+7)=SurfaceCount(SSTN+6)+Nribs;

%% Step 27: Create Rear Spar Surfaces
s1=SurfaceCount(SSTN+7)+1:1:SurfaceCount(SSTN+7)+1+Nribs-1;
s2=CurveCount(6)+6:NoCurves:CurveCount(6)+6+(Nribs-1)*NoCurves;
s3=CurveCount(9)+1:1:CurveCount(9)+1+Nribs-1;
s4=CurveCount(10)+1:1:CurveCount(10)+1+Nribs-1;
s5=CurveCount(6)+NoCurves+6:NoCurves:CurveCount(6)+NoCurves+6+(Nribs-1)*NoCurves;
k=5;
s=[k,n+1];
for i=1:n
s(1,i)=s1(1,i);
s(2,i)=s2(1,i);
s(3,i)=s3(1,i);
s(4,i)=s4(1,i);
s(5,i)=s5(1,i);
end

RSPAR=['STRING sgm_surface_4edge_created_ids[VIRTUAL]\n'...
'sgm_const_surface_4edge( "%1.0f", "Curve %1.0f", "Curve %1.0f", "Curve %1.0f",  @\n'...
'"Curve %1.0f", sgm_surface_4edge_created_ids )\n'];
fprintf(fidw,RSPAR,s);
SurfaceCount(SSTN+8)=SurfaceCount(SSTN+7)+Nribs;

%% Step 28: Delete all points and initial airfoil
PointCount=5000;
AirfoilCurve=14;
DeletePoints='STRING asm_delete_any_deleted_ids[VIRTUAL]\nasm_delete_point( "Point 1:%1.0f", asm_delete_any_deleted_ids )\n';
DeleteAirfoil='STRING asm_delete_curve_deleted_ids[VIRTUAL]\nasm_delete_curve( "Curve 1:%1.0f", asm_delete_curve_deleted_ids )\n';
fprintf(fidw,DeletePoints,PointCount);
fprintf(fidw,DeleteAirfoil,AirfoilCurve);

%% END OF GEOMETRY CREATION
% 
%% Step 29: Material Creation 
NoM=3; %Number of Materials
NoC=4; %Number of commands
MaterialType(1,1)=1; %aluminum
MaterialType(1,2)=2; % steel
MaterialType(1,3)=3; % titanium
Material=zeros(NoC,NoM);
for i=1:NoM
    Material(1,i)= MaterialType(1,i);    
end

    Material(2,1)=q20;
    Material(2,2)=q23;
    Material(2,3)=q26;
    Material(3,1)=q21;
    Material(3,2)=q24;
    Material(3,3)=q27;
    Material(4,1)=q22;
    Material(4,2)=q25;
    Material(4,3)=q28;

MaterialCommand=['material.create( "Analysis code ID", 1, "Analysis type ID", 1, "%1.0f", 0, @\n'...
'"Date: 14-Apr-11 Time: 16:25:54", "Isotropic", 1, "Directionality", @\n'...
'1, "Linearity", 1, "Homogeneous", 0, "Linear Elastic", 1, @\n'...
'"Model Options & IDs", ["", "", "", "", ""], [0, 0, 0, 0, 0], "Active Flag", @\n'...
'1, "Create", 10, "External Flag", FALSE, "Property IDs", ["Elastic Modulus", @\n'...
'"Poisson Ratio", "Density"], [2, 5, 16, 0], "Property Values", ["%1.5f", "%1.5f", @\n'...
'"%1.5f", ""] )\n'];

fprintf(fidw,MaterialCommand,Material);

%% Step 30: 2D Properties Creation, Mesh and Group  Creation (Only for surfaces)

ShellProperties=['elementprops_create( "%1.0f", 51, 25, 35, 1, 1, 20, [13, 20, 36, 4037, @\n'...
'4111, 4118, 4119], [5, 9, 1, 1, 1, 1, 1], ["m:%1.0f", "", "%1.5f", "", "", @\n'...
'"", ""], "Surface %s" )\n\n'];

Mesh=['ui_exec_function( "mesh_seed_display_mgr", "init" )\n'...
    'INTEGER fem_create_mesh_surfa_num_nodes\n'...
    'INTEGER fem_create_mesh_surfa_num_elems\n'...
    'STRING fem_create_mesh_s_nodes_created[VIRTUAL]\n'...
    'STRING fem_create_mesh_s_elems_created[VIRTUAL]\n'...
    'fem_create_mesh_surf_4( "IsoMesh", 49152, "Surface %s", 1, ["0.3"],  @\n'...
    '"Quad4", "#", "#", "Coord 0", "Coord 0", fem_create_mesh_surfa_num_nodes,  @\n'...
    'fem_create_mesh_surfa_num_elems, fem_create_mesh_s_nodes_created,  @\n'...
    'fem_create_mesh_s_elems_created )\n'...
    'fem_associate_elems_to_ep( "%1.0f", fem_create_mesh_s_elems_created,  @\n'...
    'fem_create_mesh_surfa_num_elems )\n'];

GroupCommand=['ga_group_create( "%1.0f" )\n'...
        'ga_group_entity_add( "%1.0f", "Surface %s")\n'];

% Skin Properties

for i=1:Sections
    
    P1=i;
    P2=1;
    P3=ThicknessesSkin(i);
    for j=1:4+(UpperStringers+1)+(LowerStringers+1)
       P4(1,j)=SurfaceCount(UpperStringers+1+j)+i;
    end
    P(1,1)=P1;
    P(1,2)=P2;
    P(1,3)=P3;
    P4=mat2str(P4);
    P4(P4=='[') = [];
    P4(P4==']') = [];

    fprintf(fidw,ShellProperties,P1,P2,P3,P4);
    fprintf(fidw,Mesh,P4,P1);
    fprintf(fidw,GroupCommand,P1,P1,P4);
    clear P4
end

% Ribs Properties

for i=1:Sections+1
    P1=Sections+i;
    P2=1;
    P3=ThicknessesRibs(i);
    for j= 1:UpperStringers+1+2
    if j==1
        P4(j)=i;
    elseif j==UpperStringers+1+1
        P4(j)=SurfaceCount(SSTN+4)+i;
    elseif j==UpperStringers+1+2
        P4(j)=SurfaceCount(SSTN+5)+i;
    else
        P4(j)=SurfaceCount(j)+i;
    end
    end
        P(1,1)=P1;
        P(1,2)=P2;
        P(1,3)=P3;
        P4=mat2str(P4);
        P4(P4=='[') = [];
        P4(P4==']') = [];
   
    fprintf(fidw,ShellProperties,P1,P2,P3,P4);
    fprintf(fidw,Mesh,P4,P1);
    fprintf(fidw,GroupCommand,P1,P1,P4);
       clear P4
end

% Front Spar

for i=1:Sections
    
    P1=2*Sections+1+i;
    P2=1;
    P3=ThicknessesFSpar(i);   
    P4=SurfaceCount(SSTN+6)+i;
    P(1,1)=P1;
    P(1,2)=P2;
    P(1,3)=P3;
    P4=mat2str(P4);
    P4(P4=='[') = [];
    P4(P4==']') = [];

fprintf(fidw,ShellProperties,P1,P2,P3,P4);
fprintf(fidw,Mesh,P4,P1);
fprintf(fidw,GroupCommand,P1,P1,P4);
       clear P4
end

% Rear Spar

for i=1:Sections
    
    P1=3*Sections+1+i;
    P2=1;
    P3=ThicknessesRSpar(i);
    P4=SurfaceCount(SSTN+7)+i;
    P(1,1)=P1;
    P(1,2)=P2;
    P(1,3)=P3;
    P4=mat2str(P4);
    P4(P4=='[') = [];
    P4(P4==']') = [];

fprintf(fidw,ShellProperties,P1,P2,P3,P4);
fprintf(fidw,Mesh,P4,P1);
fprintf(fidw,GroupCommand,P1,P1,P4);
       clear P4
end


%% Step 31: 1D Properties Creation
fprintf(fidw,'%s\n\n','beam_section_create("1", "L", ["`q6`", "`q7`", "`q8`", "`q9`"] )');
fprintf(fidw,'%s\n\n','beam_section_create( "2", "HAT", ["`q11`", "`q12`", "`q13`","`q14`"]) ');
% 
%% Step 32: Import Stringer Element Properties Commands

fid=fopen('StringerPropertiesCommands.txt','rt');
S = textscan(fid,'%s','delimiter','\n') ;
S = S{1} ;
fclose(fid);
fprintf(fidw, '%s\n',S{:});

%% Step 33: Meshing Stringers 

A(1,1)= CurveCount(11)+1;
B(1,1)= CurveCount(12);
A(1,2)= CurveCount(12)+1;
B(1,2)= CurveCount(13);
A(1,3)= CurveCount(9)+1;
B(1,3)= CurveCount(10);
A(1,4)= CurveCount(10)+1;
B(1,4)= CurveCount(11);
A(1,5)= CurveCount(13)+1;
B(1,5)= CurveCount(13+UpperStringers);
A(1,6)= CurveCount(13+UpperStringers)+1;
B(1,6)= CurveCount(13+UpperStringers+LowerStringers);

for i = 1 :6
   ALL(1,i)=A(1,i);
   ALL(2,i)=B(1,i);
   ALL(3,i)=5000+i;
end

% Command=['INTEGER fem_create_mesh_curve_num_nodes\n'...
% 'INTEGER fem_create_mesh_curve_num_elems\n'...
% 'STRING fem_create_mesh_c_nodes_created[VIRTUAL]\n'...
% 'STRING fem_create_mesh_c_elems_created[VIRTUAL]\n'...
% 'fem_create_mesh_curv_1( "Curve %1.0f:%1.0f", 16384, 0.2, "Bar2", "#", "#", @\n'...
% '"Coord 0", "Coord 0", fem_create_mesh_curve_num_nodes, @\n'...
% 'fem_create_mesh_curve_num_elems, fem_create_mesh_c_nodes_created, @\n'...
% 'fem_create_mesh_c_elems_created )\n'...
% 'fem_associate_elems_to_ep( "%1.0f", fem_create_mesh_c_elems_created,  @\n'...
% 'fem_create_mesh_curve_num_elems )\n'];
% fprintf(fidw,Command,ALL);


%% Step 31: Group Creation for Stringers

Group(1,1)= CurveCount(9)+1;
Group(1,2)= CurveCount(13+UpperStringers+LowerStringers);
GroupCommand=['ga_group_create( "5000" )\n'...
'ga_group_entity_add( "5000", "Curve %1.0f:%1.0f" )\n'];
fprintf(fidw,GroupCommand,Group);

%% Step 32: Verify Equivalance

fprintf(fidw,'%s\n','mesh_seed_display_mgr.erase( )');
fprintf(fidw,'%s\n','REAL fem_equiv_all_x_equivtol_ab');
fprintf(fidw,'%s\n','INTEGER fem_equiv_all_x_segment');
fprintf(fidw,'%s\n','fem_equiv_all_group4( [" "], 0, "", 1, 1, 0.0049999999, FALSE, @');
fprintf(fidw,'%s\n','fem_equiv_all_x_equivtol_ab, fem_equiv_all_x_segment )');
fprintf(fidw,'%s\n','bv_group_reorganize( 0, ["Dummy_group_name"], [0, 0, 0, 0, 1, 1, 0], [1, 1, 1,1] )');

%% Step 33: Apply B.C. Fix

for i= 1:UpperStringers+1+2
    if i==1
        fix(i)=1;
    elseif i==UpperStringers+1+1
         fix(i)=SurfaceCount(SSTN+4)+1;
    elseif i==UpperStringers+1+2
        fix(i)=SurfaceCount(SSTN+5)+1;
    else
        fix(i)=SurfaceCount(i)+1;
    end
end
fix=mat2str(fix);
fix(fix=='[') = [];
fix(fix==']') = [];
fixcommand=['loadsbcs_create2( "Fix", "Displacement", "Nodal", "", "Static", ["Surface %s"], @\n'...
'"Geometry", "Coord 0", "1.", ["<0 0 0>", "<0 0 0>", "< >", "< >"], [ @\n'...
'"", "", "", ""] )\n'];
fprintf(fidw,fixcommand,fix);

%% Step 34: Apply B.C. Force
for i= 1:UpperStringers+1+2
    if i==1
        force(i)=1+q1;
    elseif i==UpperStringers+1+1
         force(i)=SurfaceCount(SSTN+4)+1+q1;
    elseif i==UpperStringers+1+2
        force(i)=SurfaceCount(SSTN+5)+1+q1;
    else
        force(i)=SurfaceCount(i)+1+q1;
    end
end
force=mat2str(force);
force(force=='[') = [];
force(force==']') = [];
forcecommand=['loadsbcs_create2( "Force", "Force", "Nodal", "", "Static", ["Surface %s"], @\n'...
'"Geometry", "Coord 0", "1.", ["< 300 0 3000 >", "< 300 0 300 >", "< >", @\n'...
'"< >"], ["", "", "", ""] )\n'];
fprintf(fidw,forcecommand,force);

%% Group creation of structural nodes for splining

% spline with skin 

% for i=2:Sections
%     sg(i-1)=i;
% end
% i=1;
% j=Sections-1
% spline with spars 

for i=2*Sections+1+2:3*Sections+1+Sections
    sg(i-2*Sections-2)=i;
end
i=2*Sections+1+1;
j=2*Sections-1;

str=string(sg);
new=mat2str(str);
new(new=='[') = [];
new(new==']') = [];
command='\nau_boolean_groups.main2( 1, ["%1.0f"], %1.0f, [%s], "SG", "or", TRUE, FALSE, FALSE )\n';
fprintf(fidw,command,i,j,new);
fprintf(fidw,'%s\n','bv_group_reorganize( 1, ["SG"], [1, 1, 1, 1, 0, 1, 1], [0, 0, 0, 0] )');

fprintf(fidw,'%s\n','sys_poll_option( 2 )');
fprintf(fidw,'%s\n','ga_group_create( "SPL" )');
fprintf(fidw,'%s\n','ga_group_entity_add( "SPL", "Node 2276:2340:3 1:63:3" )');
fprintf(fidw,'%s\n','ga_group_current_set( "SPL" )');
fprintf(fidw,'%s\n','sys_poll_option( 0 )');

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

% %% _____________________Set up the analysis______________________ %%
% 
% %% Load Cases Creation
% 
% %constraints
% fprintf(fidw,'loadcase_create2( "Constraints", "Static", "", 1., ["Fix"], [0], [1.], "", 0., TRUE )\n');
% 
% %% Switch to aeroelasticity
% 
% fprintf(fidw,'uil_pref_analysis.set_analysis_preference( "MSC.Nastran", "Aeroelasticity", ".bdf", ".op2", "No Mapping" )\n');
% 
% %% Flat plate aero modelling
% 
% fprintf(fidw,'flat_plate_surf_create( "ls_wing_1st", [0., 0., 0.], [0., 0., 0.], 0., 0., 100001, 1, 0, "None", 0, ["empty"], 9, 5, [0., 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.], [0., 0.25, 0.5, 0.75, 1.], FALSE, "Surface 100001", 0, TRUE)\n');
% fprintf(fidw,'flat_plate_surf_create( "ls_wing_2nd", [0., 0., 0.], [0., 0., 0.], 0., 0., 200001, 1, 0, "None", 0, ["empty"], 9, 5, [0., 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.], [0., 0.25, 0.5, 0.75, 1.], FALSE, "Surface 100002", 0, TRUE)\n');
% 
% % Splines
% 
% fprintf(fidw,'flds_spline_create( "sp_wing_1", "Finite Plate", ["General", "Rigid Attach", "10", "10"], "", ["SG"], "", ["ls_wing_1st", "ls_wing_2nd"] )\n');
% 
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


%% Closing Patran after runnning ses file

fclose(fidw);

fid=fopen('Begining_Nastran_1.ses.txt','rt');
S = textscan(fid,'%s','delimiter','\n') ;
S = S{1} ;
fclose(fid);
fidw = fopen('PCL.ses.txt', 'a+');
fprintf(fidw, '%s\n',S{:});

% fprintf(fidw,'%s\n','gm_write_image( "JPEG", "uCRM.txt", "Increment", 0., 0., 1., 1., 1, "Viewport" )');
fprintf(fidw,'%s\n','uil_file_close.go(  )');
fprintf(fidw,'%s\n','uil_file_close.goquit(  )');

fclose(fidw);

%% Running Patran 

% use -b if you want to run on batch mode -ans yes 

% proc = System.Diagnostics.Process(); 
% proc.StartInfo.FileName = 'patran.exe';
% proc.StartInfo.Arguments = ' -ifile init_fld.pcl -skin -db uCRM  -sfp PCL.ses.txt';
% proc.StartInfo.UseShellExecute = false;
% proc.StartInfo.RedirectStandardInput = true;
% proc.Start();
% pid = proc.Id();

% %% Waiting for Patran to execute 
% 
% % MATLAB will continue execution once EXE is launched
% disp('MATLAB continues after calling EXE')
% 
% % Check to see if the EXE process exists
% flag = true;
% while flag
%     disp('EXE still running');   
%     flag = isprocess('patran.exe'); % isprocess is the function attached. Place it on the MATLAB path.
%     pause(1) % check every 1 second
% end
% 
% disp('EXE Done')
% disp('continuing with MATLAB script')
% 
% 
% end
end
% toc

