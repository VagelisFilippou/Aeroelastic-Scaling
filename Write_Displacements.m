clear all
close all
clc
Target_Points='Input_Data\Objective\uCRM_Full_Scale.rpt.01';
Nodes='uCRM.bdf';
h5_file='ucrm.h5';
Displ_txt='Input_Data\Objective\Full_Scale_Displacements.txt';
[D]=Nearest_ID_Displacement(Target_Points,Nodes,h5_file,Displ_txt);