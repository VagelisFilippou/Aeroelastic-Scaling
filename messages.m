function messages(file)

fid = fopen(file,'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
S = S{1} ;

%% Find Information Messages
idx = contains(S,'USER INFORMATION MESSAGE') ;
Inf_Mess=S(idx);
display(Inf_Mess)

%% Find Fatal Messages
idx = contains(S,'USER FATAL MESSAGE') ;
Fatal_Mess=S(idx);
A=any(idx);
if A~=0
    display(Fatal_Mess)
    error('Fatal Messages')
end
fclose(fid);