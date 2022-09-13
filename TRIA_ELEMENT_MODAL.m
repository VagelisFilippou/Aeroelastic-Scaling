function [CTRIA3]=TRIA_ELEMENT_MODAL(file,h5_file,C)
cx=C(1);
cy=C(2);
cz=C(3);

fid = fopen(file,'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx = ~contains(S,'CTRIA3') ;
S(idx) = [] ;
fid = fopen('Input_Data\Bdf_plot\CTRIA.txt','wt') ;
fprintf(fid,'%s\n',S{:,:});
fclose(fid);
fid = fopen('Input_Data\Bdf_plot\CTRIA.txt','rt+') ;
C = textscan(fid, '%s %f %f %f %f %f');
fclose(fid);

if isempty(C{1,1})==1
    ID=[];
    CTRIA3=[];
    Grid=[];
    Stress=[];
    Thickness=[];
    Displacement=[];
    disp(['No TRIA3 Elements in ',file])
    return
end

ID=C{1,2};
TRIA(:,1)=C{1,4};
TRIA(:,2)=C{1,5};
TRIA(:,3)=C{1,6};
[~,Grid] = gridpoint_extractor(file);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h5data=h5extract('ucrm.h5');
[~,gridpoints] = gridpoint_extractor('uCRM.bdf');
Grid_ID=gridpoints(:,1);
Grid_x=gridpoints(:,2);
Grid_y=gridpoints(:,3);
Grid_z=gridpoints(:,4);


h5Data   = h5extract(h5_file);
NoGrid=length(Grid_ID);
NoModes=length(h5Data.NASTRAN.RESULT.SUMMARY.EIGENVALUE.MODE);

vector_x=h5Data.NASTRAN.RESULT.NODAL.EIGENVECTOR.X;
vector_y=h5Data.NASTRAN.RESULT.NODAL.EIGENVECTOR.Y;
vector_z=h5Data.NASTRAN.RESULT.NODAL.EIGENVECTOR.Z;

i=NoModes;
j=length(vector_x)/NoModes;

vector_x = (reshape(vector_x,[j,i]));
vector_y = (reshape(vector_y,[j,i]));
vector_z = (reshape(vector_z,[j,i]));

parfor i=1:NoModes
dx{i}(:,:)= Grid_x(:,1)+cx*vector_x(:,i);
dy{i}(:,:)= Grid_y(:,1)+cy*vector_y(:,i);
dz{i}(:,:)= Grid_z(:,1)+cz*vector_z(:,i);
end

parfor i=1:NoModes
Grid_def_x{i}=dx{1,i}(Grid(:,1));
Grid_def_y{i}=dy{1,i}(Grid(:,1));
Grid_def_z{i}=dz{1,i}(Grid(:,1));
end

k=0;
linearIndices=zeros(max(Grid(:,1)),1);
parfor i =1:max(Grid(:,1))
   k=find(Grid(:,1)==i);
    if k~=0  
    linearIndices(i,1) = find(Grid(:,1)==i);
    idx(i,1)=1;
    else
    linearIndices(i,1) = 0;
    idx(i,1)=0;
    end
end

for k=1:NoModes
for i=1:size(TRIA,1)
for j = 1:3

CTRIA3.X{k}(i,j)=Grid_def_x{k}(linearIndices(TRIA(i,j)),1);
CTRIA3.Y{k}(i,j)=Grid_def_y{k}(linearIndices(TRIA(i,j)),1);
CTRIA3.Z{k}(i,j)=Grid_def_z{k}(linearIndices(TRIA(i,j)),1);
end
end
CTRIA3.X{k}=transpose(CTRIA3.X{k});
CTRIA3.Y{k}=transpose(CTRIA3.Y{k});
CTRIA3.Z{k}=transpose(CTRIA3.Z{k});
end


