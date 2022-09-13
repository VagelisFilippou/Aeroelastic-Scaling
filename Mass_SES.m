function [Mass_Node]= Mass_SES(Mass_Coord,Mass_Attach_Nodes,Nribs,Fuel_Mass_kg)
fid = fopen('Lumped_Mass.ses.txt','w') ;
% Nodes Generation
for i=1:Nribs
    Mass_Node(1,i)=10000000+i;
end
Mass_Node(2,:)=Mass_Coord.X;
Mass_Node(3,:)=Mass_Coord.Y;
Mass_Node(4,:)=Mass_Coord.Z;

Command=['STRING fem_create_nodes__nodes_created[VIRTUAL]\n'...
        'STRING fem_create_nodes__nodes_created[VIRTUAL]\n'...
        'fem_create_nodes_1( "Coord 0", "Coord 0", 3, "%1.0f", "[%1.5f %1.5f %1.5f]",  @\n'...
        'fem_create_nodes__nodes_created )\n'];
fprintf(fid,Command,Mass_Node);

% Create MPC
for i=1:Nribs
    MPC(1,i)=i;
end

MPC(3,:)=Mass_Attach_Nodes.RFL;
MPC(4,:)=Mass_Attach_Nodes.RFU;
MPC(5,:)=Mass_Attach_Nodes.RRL;
MPC(6,:)=Mass_Attach_Nodes.RRU;
MPC(7,:)=Mass_Attach_Nodes.LFU;
MPC(8,:)=Mass_Attach_Nodes.LFL;
MPC(9,:)=Mass_Attach_Nodes.LRL;
MPC(10,:)=Mass_Attach_Nodes.LRU;
MPC(2,:)=Mass_Node(1,:);

% Command=['fem_create_mpc_nodal2(%1.0f , "RBE2", 0., 2, [TRUE, FALSE], ["0", "0"], [ @\n'...
%         '"Node %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f", "Node %1.0f"], ["UX,UZ,RX,RY,RZ", ""] )\n'];

Command=['fem_create_mpc_nodal2( %1.0f, "RBE3", 0., 9, [TRUE, FALSE, FALSE, FALSE, FALSE,  @\n'...
'FALSE, FALSE, FALSE, FALSE], ["0.", "1.0", "1.0", "1.0", "1.0", "1.0", "1.0",  @\n'...
'"1.0", "1.0"], ["Node %1.0f", "Node %1.0f", "Node %1.0f", "Node %1.0f", "Node %1.0f" @\n'...
', "Node %1.0f", "Node %1.0f", "Node %1.0f", "Node %1.0f"], ["UX,UY,UZ,RX,RY,RZ",  @\n'...
'"UX,UY,UZ", "UX,UY,UZ", "UX,UY,UZ", "UX,UY,UZ", "UX,UY,UZ", "UX,UY,UZ",  @\n'...
'"UX,UY,UZ", "UX,UY,UZ"] )\n'];

fprintf(fid,Command,MPC);


% Create Mass Property
M_0d(1,:)=1:1:Nribs;
M_0d(2,:)=Fuel_Mass_kg;
Command=['elementprops_create( "Mass_0D_%1.0f", 1, 25, 18, 27, 2, 20, [2069, 4001, 4024, 10,  @\n'...
'4026, 11, 4028, 4029, 12], [1, 9, 2, 1, 1, 1, 1, 1, 1], ["%1.5f", "Coord 0", "", @\n'...
 '"", "", "", "", "", ""], "" )\n'];
fprintf(fid,Command,M_0d);

% Create Point Element
El_0d(1,:)=10000000:1:10000000+Nribs-1;
El_0d(2,:)=Mass_Node(1,:);
El_0d(3,:)=M_0d(1,:);
El_0d(4,:)=El_0d(1,:);

Command=['STRING fem_create_elemen_elems_created[VIRTUAL]\n'...
 'fem_create_elems_1( "Point ", "Point", "%1.0f", "Standard", 3, "Node %1.0f", @\n'...
 '"", "", "", "", "", "", "", fem_create_elemen_elems_created )\n'...
 'fem_associate_elems_to_ep( "Mass_0D_%1.0f", "%1.0f", 1 )\n'];
fprintf(fid,Command,El_0d);

fclose(fid);
