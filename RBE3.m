function[rbe,mn,ap]=RBE3(figure_counter)
% clear all 
h5=h5extract('ucrm.h5');
G=h5.NASTRAN.INPUT.NODE.GRID.X(:,h5.NASTRAN.INPUT.ELEMENT.RBE3.G.ID); 
N_Masses=length(h5.NASTRAN.INPUT.ELEMENT.CONM2.G);

for i=1:N_Masses
k(i)=find(h5.NASTRAN.INPUT.NODE.GRID.ID==h5.NASTRAN.INPUT.ELEMENT.CONM2.G(i));
end

Mass_Nodes=h5.NASTRAN.INPUT.NODE.GRID.X(:,k); 

for i=1:N_Masses
    RBE{i}=G(:,8*(i-1)+1:8*i);
end

figure(figure_counter)
hold on

for j=1:N_Masses
for i=1:8
    RBE_PLT{i,j}(1:3,1)=RBE{1,j}(:,i);
    RBE_PLT{i,j}(1:3,2)=Mass_Nodes(:,j);
    rbe=plot3(RBE_PLT{i,j}(1,:),RBE_PLT{i,j}(2,:),RBE_PLT{i,j}(3,:),Color=[255,102,178]/255,LineWidth=1);
    ap=plot3(RBE_PLT{i,j}(1,1),RBE_PLT{i,j}(2,1),RBE_PLT{i,j}(3,1), ...
        Color=[255,102,102]/255,Marker=".",LineStyle="none",MarkerSize=10);
end
end
D=transpose(h5.NASTRAN.INPUT.ELEMENT.CONM2.M/max(h5.NASTRAN.INPUT.ELEMENT.CONM2.M));
for i=1:N_Masses
mn=plot3(Mass_Nodes(1,i),Mass_Nodes(2,i),Mass_Nodes(3,i), ...
Color=[0,204,102]/255,Marker=".",LineStyle="none",MarkerSize=100*D(i));
end
