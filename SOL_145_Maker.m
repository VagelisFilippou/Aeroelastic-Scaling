function SOL_145_Maker
fid = 'uCRM.bdf';
S = extractFileText(fid) ;
S=extractAfter(S,'PARAM   PRTMAXIM YES');
 
fid = 'SOL_145_Command.txt';
C = extractFileText(fid);

fid=fopen('uCRM_SOL_145.bdf','w');
fprintf(fid,'%s\n',C{:});
fprintf(fid,'%s\n',S{:});
fclose(fid);



