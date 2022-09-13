clear all 
close all 
clc

%% Target nodes extraction
bdf_file='uCRM.bdf';
bdf_file_reference='Reference_Analysis/uCRM.bdf';
scale=1;
scale_reference=1;
[NearestID] = Target_Node(bdf_file,scale,1);
[NearestID_reference] = Target_Node(bdf_file_reference,scale_reference,2);

%% Displacement Objective
h5=h5extract('ucrm.h5');
Displ.Scaled.T(:,1)=h5.NASTRAN.RESULT.NODAL.DISPLACEMENT.X(NearestID);
Displ.Scaled.T(:,2)=h5.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y(NearestID);
Displ.Scaled.T(:,3)=h5.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z(NearestID);
Displ.Scaled.R(:,1)=h5.NASTRAN.RESULT.NODAL.DISPLACEMENT.RX(NearestID);
Displ.Scaled.R(:,2)=h5.NASTRAN.RESULT.NODAL.DISPLACEMENT.RY(NearestID);
Displ.Scaled.R(:,3)=h5.NASTRAN.RESULT.NODAL.DISPLACEMENT.RZ(NearestID);

h5_reference=h5extract('Reference_Analysis/ucrm.h5');
Displ.Ref.T(:,1)=h5_reference.NASTRAN.RESULT.NODAL.DISPLACEMENT.X(NearestID_reference);
Displ.Ref.T(:,2)=h5_reference.NASTRAN.RESULT.NODAL.DISPLACEMENT.Y(NearestID_reference);
Displ.Ref.T(:,3)=h5_reference.NASTRAN.RESULT.NODAL.DISPLACEMENT.Z(NearestID_reference);
Displ.Ref.R(:,1)=h5_reference.NASTRAN.RESULT.NODAL.DISPLACEMENT.RX(NearestID_reference);
Displ.Ref.R(:,2)=h5_reference.NASTRAN.RESULT.NODAL.DISPLACEMENT.RY(NearestID_reference);
Displ.Ref.R(:,3)=h5_reference.NASTRAN.RESULT.NODAL.DISPLACEMENT.RZ(NearestID_reference);

Displ.Diff.T(:,1)=-Displ.Scaled.T(:,1)/scale+Displ.Ref.T(:,1);
Displ.Diff.T(:,2)=-Displ.Scaled.T(:,2)/scale+Displ.Ref.T(:,2);
Displ.Diff.T(:,3)=-Displ.Scaled.T(:,3)/scale+Displ.Ref.T(:,3);

Displ.Diff.R(:,1)=-Displ.Scaled.R(:,1)/scale+Displ.Ref.R(:,1);
Displ.Diff.R(:,2)=-Displ.Scaled.R(:,2)/scale+Displ.Ref.R(:,2);
Displ.Diff.R(:,3)=-Displ.Scaled.R(:,3)/scale+Displ.Ref.R(:,3);

Square=zeros(length(NearestID),3);

for i=1:length(NearestID)
    for j=1:3
    Square(i,j)=(Displ.Diff.T(i,j)/Displ.Ref.T(i,j))^2+(Displ.Diff.R(i,j)/Displ.Ref.R(i,j))^2;
    end
end

TF = isnan(Square);
Square(TF)=0;
Deflection_Objective = sqrt(sum(Square,'all'));
RMSE_Def=rms(Displ.Diff.T(:));

% End of Displacement Objective 

%% Modal Objective

h5_modal=h5extract('ucrm_sol_103.h5');
h5_reference_modal=h5extract('Reference_Analysis/ucrm_sol_103.h5');

NoModes=length(h5_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.MODE);
i=NoModes;
j=length(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.X)/NoModes;

Vector.Scaled.T{1}(:,:)=Target_Mode(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.X,j,i,NearestID);
Vector.Scaled.T{2}(:,:)=Target_Mode(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.Y,j,i,NearestID);
Vector.Scaled.T{3}(:,:)=Target_Mode(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.Z,j,i,NearestID);

for i=1:NoModes
    Max_Scaled(i)=max(sqrt(Vector.Scaled.T{1}(:,i).^2+Vector.Scaled.T{2}(:,i).^2+Vector.Scaled.T{3}(:,i).^2));
    Vector.Scaled.T{1}(:,i)=Vector.Scaled.T{1}(:,i)/Max_Scaled(i);
    Vector.Scaled.T{2}(:,i)=Vector.Scaled.T{2}(:,i)/Max_Scaled(i);
    Vector.Scaled.T{3}(:,i)=Vector.Scaled.T{3}(:,i)/Max_Scaled(i);

    Vector_Scale{i}(:,1)=Vector.Scaled.T{1}(:,i);
    Vector_Scale{i}(:,2)=Vector.Scaled.T{2}(:,i);
    Vector_Scale{i}(:,3)=Vector.Scaled.T{3}(:,i);
end

Vector.Scaled.R{1}(:,:)=Target_Mode(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.RX,j,i,NearestID);
Vector.Scaled.R{2}(:,:)=Target_Mode(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.RY,j,i,NearestID);
Vector.Scaled.R{3}(:,:)=Target_Mode(h5_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.RZ,j,i,NearestID);

NoModes_Ref=length(h5_reference_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.MODE);
i=NoModes_Ref;
j=length(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.X)/NoModes_Ref;

Vector.Ref.T{1}(:,:)=Target_Mode(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.X,j,i,NearestID);
Vector.Ref.T{2}(:,:)=Target_Mode(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.Y,j,i,NearestID);
Vector.Ref.T{3}(:,:)=Target_Mode(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.Z,j,i,NearestID);

for i=1:NoModes
    Max_Scaled_Ref(i)=max(sqrt(Vector.Ref.T{1}(:,i).^2+Vector.Ref.T{2}(:,i).^2+Vector.Ref.T{3}(:,i).^2));
    Vector.Ref.T{1}(:,i)=Vector.Ref.T{1}(:,i)/Max_Scaled_Ref(i);
    Vector.Ref.T{2}(:,i)=Vector.Ref.T{2}(:,i)/Max_Scaled_Ref(i);
    Vector.Ref.T{3}(:,i)=Vector.Ref.T{3}(:,i)/Max_Scaled_Ref(i);

    Vector_Ref{i}(:,1)=Vector.Ref.T{1}(:,i);
    Vector_Ref{i}(:,2)=Vector.Ref.T{2}(:,i);
    Vector_Ref{i}(:,3)=Vector.Ref.T{3}(:,i);
end

Vector.Ref.R{1}(:,:)=Target_Mode(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.RX,j,i,NearestID);
Vector.Ref.R{2}(:,:)=Target_Mode(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.RY,j,i,NearestID);
Vector.Ref.R{3}(:,:)=Target_Mode(h5_reference_modal.NASTRAN.RESULT.NODAL.EIGENVECTOR.RZ,j,i,NearestID);

for i=1:10
    for j=1:10
    MAC{1}(i,j)=Mac(Vector_Ref{i}(:,1),Vector_Scale{j}(:,1));
    MAC{2}(i,j)=Mac(Vector_Ref{i}(:,2),Vector_Scale{j}(:,2));
    MAC{3}(i,j)=Mac(Vector_Ref{i}(:,3),Vector_Scale{j}(:,3));
    end
end

MaC=(MAC{1}+MAC{2}+MAC{3})/3;
tr=trace(MaC);
Modal_Objective= (10-trace(MaC))/10;

for k=1:NoModes
    F_error(k)=((DesignVariables.Scaling_Factors.Frequency*h5_reference_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(k)- ...
    h5_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(k))/...
    h5_reference_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(k))^2;
end

Freq_Constraint=sum(F_error);
function mAc=Mac(Phi1,Phi2)
% This function calculates mac between phi1 and phi2
mAc= (abs(Phi1'*Phi2))^2/((Phi1'*Phi1)*(Phi2'*Phi2));
end

% Vector.Diff.T{1}(:,:)=-Vector.Scaled.T{1}(:,:)+Vector.Ref.T{1}(:,:);
% Vector.Diff.T{2}(:,:)=-Vector.Scaled.T{2}(:,:)+Vector.Ref.T{2}(:,:);
% Vector.Diff.T{3}(:,:)=-Vector.Scaled.T{3}(:,:)+Vector.Ref.T{3}(:,:);
% Vector.Diff.R{1}(:,:)=-Vector.Scaled.R{1}(:,:)+Vector.Ref.R{1}(:,:);
% Vector.Diff.R{2}(:,:)=-Vector.Scaled.R{2}(:,:)+Vector.Ref.R{2}(:,:);
% Vector.Diff.R{3}(:,:)=-Vector.Scaled.R{3}(:,:)+Vector.Ref.R{3}(:,:);
% 
% 
% for i=1:length(NearestID)
%     for j=1:3
%         for k=1:NoModes
%         Square_vector{j}(i,k)=(Vector.Diff.T{j}(i,k))^2;
%         end
%     end
% end
% 
% for j=1:3
% TF = isnan(Square_vector{j}(:,:));
% Square_vector{j}(TF)=0;
% end
% 
% for k=1:NoModes
% F_error(k)=((h5_reference_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(k)-h5_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(k))/...
% h5_reference_modal.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ(k))^2;
% end
% 
% F_sum=sum(F_error);
% vector_sum=sum(sum(Square_vector{1}(:,:))+sum(Square_vector{2}(:,:))+sum(Square_vector{3}(:,:)));
% 
% Modal_Objective=sqrt(F_sum+vector_sum);

function [Mode_out] = Target_Mode(Mode_in,j,i,NearestIDs)
Mode_out_0=reshape(Mode_in,[j,i]);
Mode_out=Mode_out_0(NearestIDs,:);
end

function [NearestID] = Target_Node(bdf_file,scale,figure_counter)

[~,gridpoints] = gridpoint_extractor(bdf_file);


N=20;
[Coords]=uCRM_MDO;
[x,Yu,Yl]=Profile(N);
A=ones(1,length(x));

for i=1:21
    for j=1:N
        Target.X(i,j)=((x(j)-0.25)*cosd(Coords.AoA(i))+0.25)*Coords.Chord(i)+Coords.X(i);
        Target.Y(i,j)= A(j)*Coords.Y(i);
        Target.Zu(i,j)=(Yu(j)+(x(j)-0.25)*sind(-Coords.AoA(i)))*Coords.Chord(i)+Coords.Z(i); 
        Target.Zl(i,j)=(Yl(j)+(x(j)-0.25)*sind(-Coords.AoA(i)))*Coords.Chord(i)+Coords.Z(i);    
    end
end

Target.X=Target.X(:);
Target.Y=Target.Y(:);
Target.Zu=Target.Zu(:);
Target.Zl=Target.Zl(:);

N_=length(Target.X);

P(1:N_,1)=Target.X;
P(N_+1:2*N_,1)=Target.X;
P(1:N_,2)=Target.Y;
P(N_+1:2*N_,2)=Target.Y;
P(1:N_,3)=Target.Zu;
P(N_+1:2*N_,3)=Target.Zl;
figure(figure_counter)
hold on
plot3(P(:,1),P(:,2),P(:,3),Marker="o",Color=[0,0,0]/255,LineStyle="none",MarkerSize=3.5,MarkerFaceColor=[255 0 0]/255);
plot3(gridpoints(:,2)*(1/scale),gridpoints(:,3)*(1/scale),gridpoints(:,4)*(1/scale),Marker="o",Color=[0,0,0]/255, ...
     LineStyle="none",MarkerSize=0.5,MarkerFaceColor=[0 0 255]/255);
axis equal 

[NearestID] = Spline_Points(P,bdf_file,scale);
[C,au,ia]=unique(NearestID,'last','legacy');
Same = ones(size(NearestID));
Same(ia) = 0;
Result = [NearestID Same];

plot3(gridpoints((NearestID(Same==1)),2)*(1/scale),gridpoints((NearestID(Same==1)),3) ...
    *(1/scale),gridpoints((NearestID(Same==1)),4)*(1/scale),Marker="o",Color=[0,0,0]/255, ...
     LineStyle="none",MarkerSize=4.5,MarkerFaceColor=[255 100 255]/255);

function [NearestID] = Spline_Points(P,bdf_file,scale)

[~,gridpoints] = gridpoint_extractor(bdf_file);



PQ=zeros(length(gridpoints),3);
ID=gridpoints(:,1);
PQ(:,1)=gridpoints(:,2)*(1/scale);
PQ(:,2)=gridpoints(:,3)*(1/scale);
PQ(:,3)=gridpoints(:,4)*(1/scale);

[k,dist] = dsearchn(PQ,P);

hold on
plot3(PQ(k,1),PQ(k,2),PQ(k,3),Marker="o",Color=[0,0,0]/255,LineStyle="none",MarkerSize=3.5,MarkerFaceColor=[0 76 153]/255);
axis equal
box on
axis off
ax = gca;
ax.Clipping = 'off';

offset=1:length(dist);
b = num2str(k); c = cellstr(b);
dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points



for i=1:length(k)
NearestID(i)=k(i);
end
end
end