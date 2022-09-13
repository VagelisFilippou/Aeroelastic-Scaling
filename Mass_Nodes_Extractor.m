function [Nodes]=Mass_Nodes_Extractor(Attach_Points,Nribs)
bdf_file='uCRM.bdf';
[~,RS] = gridpoint_extractor(bdf_file);
% bdf_file='uCRM_FrontSpar.bdf';
% [~,FS] = gridpoint_extractor(bdf_file);

gridpoints=RS;

FU(:,1)=Attach_Points.X.FU;
FU(:,2)=Attach_Points.Y.FU;
FU(:,3)=Attach_Points.Z.FU;

FL(:,1)=Attach_Points.X.FL;
FL(:,2)=Attach_Points.Y.FL;
FL(:,3)=Attach_Points.Z.FL;

RU(:,1)=Attach_Points.X.RU;
RU(:,2)=Attach_Points.Y.RU;
RU(:,3)=Attach_Points.Z.RU;

RL(:,1)=Attach_Points.X.RL;
RL(:,2)=Attach_Points.Y.RL;
RL(:,3)=Attach_Points.Z.RL;

PQ=zeros(length(gridpoints),3);
ID=gridpoints(:,1);
PQ(:,1)=gridpoints(:,2);
PQ(:,2)=gridpoints(:,3);
PQ(:,3)=gridpoints(:,4);

[FU_ID,D1] = dsearchn(PQ,FU);
[FL_ID,D2] = dsearchn(PQ,FL);
[RU_ID,D3] = dsearchn(PQ,RU);
[RL_ID,D4] = dsearchn(PQ,RL);

% figure(1)
% hold on
% axis equal
% plot3(PQ(:,1),PQ(:,2),PQ(:,3),'.')
% 
% plot3(FU(:,1),FU(:,2),FU(:,3),'*g')
% plot3(FL(:,1),FL(:,2),FL(:,3),'*g')
% plot3(RU(:,1),RU(:,2),RU(:,3),'*g')
% plot3(RL(:,1),RL(:,2),RL(:,3),'*g')
% 
% plot3(PQ(FU_ID,1),PQ(FU_ID,2),PQ(FU_ID,3),'*r')
% plot3(PQ(FL_ID,1),PQ(FL_ID,2),PQ(FL_ID,3),'*r')
% plot3(PQ(RU_ID,1),PQ(RU_ID,2),PQ(RU_ID,3),'*r')
% plot3(PQ(RL_ID,1),PQ(RL_ID,2),PQ(RL_ID,3),'*r')
% 
% figure(2)
% hold on
% plot(D1)
% plot(D2)
% plot(D3)
% plot(D4)

%% Reorganize Nodes For Each Mass

for i=1:Nribs

    Nodes.Mass_ID(i)=i;
    Nodes.LFU(i)= gridpoints(FU_ID(i));
    Nodes.LFL(i)= gridpoints(FL_ID(i));
    Nodes.LRU(i)= gridpoints(RU_ID(i));
    Nodes.LRL(i)= gridpoints(RL_ID(i));

    Nodes.RFU(i)= gridpoints(FU_ID(i+1));
    Nodes.RFL(i)= gridpoints(FL_ID(i+1));
    Nodes.RRU(i)= gridpoints(RU_ID(i+1));
    Nodes.RRL(i)= gridpoints(RL_ID(i+1));
    
end


