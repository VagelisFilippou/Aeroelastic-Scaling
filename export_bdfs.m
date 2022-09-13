function export_bdfs

delete patran.ses.02
delete patran.ses.03
delete patran.ses.04
delete patran.ses.05
delete uCRM_FrontSpar.bdf
delete uCRM_Ribs.bdf
delete uCRM_Skin.bdf
delete uCRM_RearSpar.bdf

% Read the file data 
fid = fopen('Input_Data\Export_Indivd_BDF.ses.jou','rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;

idx = contains(S,'$#') ;
S(idx) = [] ;

fid = fopen('Structural.ses.txt','w') ;
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);
%Skin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["Skin"] )']);
fprintf(fid,'%s\n',S{:});
% fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
%     '["FrontSpar", "RearSpar", "Ribs", "SPL", "Skin", "Stringers_Caps"] )']);
% 
% old{1}= "uCRM_Skin";
% new{1}= "uCRM_Skin";
% old{2}="Skin";
% new{2}="Skin";
% S_New = replace(S,old{1},new{1});
% S_New = replace(S_New,old{2},new{2});
% fprintf(fid,'%s\n',S_New{:});
% clear S_New


%FrontRib
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["FrontRib"] )']);
old{1}= "uCRM_Skin";
new{1}= "uCRM_FrontRib";
old{2}="Skin";
new{2}="FrontRib";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
clear S_New

%FSpar
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["FrontSpar"] )']);
new{1}= "uCRM_FrontSpar";
new{2}="FrontSpar";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);
%RSpar
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["RearSpar"] )']);
new{1}= "uCRM_RearSpar";
new{2}="RearSpar";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);
%Rear Rib
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["RearRib"] )']);
new{1}= "uCRM_RearRib";
new{2}="RearRib";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

%MainRib
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["MainRib"] )']);
new{1}= "uCRM_MainRib";
new{2}="MainRib";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

% Front upper skin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["FrontUpperSkin"] )']);
new{1}= "uCRM_FrontUpperSkin";
new{2}="FrontUpperSkin";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

% Front Lower skin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["FrontLowerSkin"] )']);
new{1}= "uCRM_FrontLowerSkin";
new{2}="FrontLowerSkin";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

% UpperMainSkin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["UpperMainSkin"] )']);
new{1}= "uCRM_UpperMainSkin";
new{2}="UpperMainSkin";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

% LowerrMainSkin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["LowerMainSkin"] )']);
new{1}= "uCRM_LowerMainSkin";
new{2}="LowerMainSkin";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);
% RearUpperSkin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["RearUpperSkin"] )']);
new{1}= "uCRM_RearUpperSkin";
new{2}="RearUpperSkin";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

% RearLowerSkin
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 1, ["RearLowerSkin"] )']);
new{1}= "uCRM_RearLowerSkin";
new{2}="RearLowerSkin";
% S_New = replace(S,old{1},new{1});
S_New = replace(S,old{2},new{2});
fprintf(fid,'%s\n',S_New{:});
fprintf(fid,'%s\n',['uil_viewport_post_groups.posted_groups( "default_viewport", 28, ' ...
    '["FrontSpar", "RearSpar","UpperMainSkin","LowerMainSkin",' ...
    '"FrontUpperSkin","RearUpperSkin","RearLowerSkin","FrontLowerSkin","FrontRib","RearRib","MainRib", "Stringers_Caps"] )']);

fclose(fid) ;