function [CQUAD4]=QUAD_ELEMENT_MODAL(file,h5_file,C)
cx=C(1);
cy=C(2);
cz=C(3);

fid = fopen(file,'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx = ~contains(S,'CQUAD4') ;
S(idx) = [] ;
fid = fopen('Input_Data\Bdf_plot\CQUAD.txt','wt') ;
fprintf(fid,'%s\n',S{:,:});
fclose(fid);
fid = fopen('Input_Data\Bdf_plot\CQUAD.txt','rt+') ;
C = textscan(fid, '%s %f %f %f %f %f %f');
fclose(fid);
ID=C{1,2};
QUAD(:,1)=C{1,4};
QUAD(:,2)=C{1,5};
QUAD(:,3)=C{1,6};
QUAD(:,4)=C{1,7};
[~,Grid] = gridpoint_extractor(file);
Grid_ID=Grid(:,1);

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

for i=1:NoModes
dx{i}(:,:)= Grid_x(:,1)+cx*vector_x(:,i);
dy{i}(:,:)= Grid_y(:,1)+cy*vector_y(:,i);
dz{i}(:,:)= Grid_z(:,1)+cz*vector_z(:,i);
end

for i=1:NoModes
Grid_def_x{i}=dx{1,i}(Grid(:,1));
Grid_def_y{i}=dy{1,i}(Grid(:,1));
Grid_def_z{i}=dz{1,i}(Grid(:,1));
end

k=0;
linearIndices=zeros(max(Grid(:,1)),1);
for i =1:max(Grid(:,1))
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
for i=1:length(QUAD)
for j = 1:4

CQUAD4.X{k}(i,j)=Grid_def_x{k}(linearIndices(QUAD(i,j)),1);
CQUAD4.Y{k}(i,j)=Grid_def_y{k}(linearIndices(QUAD(i,j)),1);
CQUAD4.Z{k}(i,j)=Grid_def_z{k}(linearIndices(QUAD(i,j)),1);
IDs(i,j)=linearIndices(QUAD(i,j));
end
end
CQUAD4.X{k}=transpose(CQUAD4.X{k});
CQUAD4.Y{k}=transpose(CQUAD4.Y{k});
CQUAD4.Z{k}=transpose(CQUAD4.Z{k});
end




