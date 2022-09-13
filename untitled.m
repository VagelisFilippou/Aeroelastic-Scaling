clear all

fid = fopen("Design_Points.txt",'rt') ;
S = textscan(fid,'%f','delimiter','\n') ;
fclose(fid);

NoEval=length(S{1, 1})/76;

X=S{1,1};
X=transpose(reshape(X,[76,NoEval]));
F=X(:,71);

for i=1:NoEval
G(i)=sum(X(i,72:76));
end

figure 
hold on
plot(F)
plot(G)

%% Objective Function
fid = fopen("MIDACO_SOLUTION.TXT",'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx =~contains(S,'f(X)');
S(idx) = [];
STR=extractAfter(S,'=');
F_X=str2double(STR(:,1));

%% Design Points in Obj Function
NoV=70;
NoEv=length(F_X);

fid = fopen("MIDACO_SOLUTION.TXT",'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx =~contains(S,'x(');
S(idx) = [];
S=transpose(reshape(S,[NoV,NoEv]));
S = extractBetween(S,"=",";"); 
X_ = str2double(S);

%% Eval
fid = fopen("MIDACO_SOLUTION.TXT",'rt') ;
S = textscan(fid,'%s','delimiter','\n') ;
fclose(fid);
S = S{1} ;
idx =~contains(S,'EVAL');
S(idx) = [];
S(1)=[];
Eval=extractBetween(S,':',',');
Eval(:,2)=[];
Eval=str2double(Eval);
% F_X=str2double(STR(:,1));

x=X_(end,:);
% figure(2)
plot(Eval,F_X)
figure(2)
plot(abs(X_(:,67)-X_(:,68)))

