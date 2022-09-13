clear all 
close all
clc
% Read the file data 
fid = fopen('SOL_103_Normal_Modes.ses.txt','rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
S = S{1} ;
fclose(fid) ;
% txt = extractFileText(fid);
% fclose(fid) ;
% c = regexprep(txt,{char(13),char(10)}, '');  % or replace with ' '
% size(c{1})  % =  1 x 204710
% txt_new = regexprep(txt,' +',' ');

idx = contains(S,'$#') ;
S(idx) = [] ;
% 
% idx = contains(S,'ga_view') ;
% S(idx) = [] ;
% 
% idx = contains(S,'uil') ;
% S(idx) = [] ;
% % write to file 

fid = fopen('SOL_103_Normal_Modes_1.ses.txt','wt') ;
fprintf(fid,'%s\n',S{:});
fclose(fid) ;