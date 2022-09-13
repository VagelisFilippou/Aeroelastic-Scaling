%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
%     This is an example call of MIDACO 6.0
%     -------------------------------------
%
%     MIDACO solves Multi-Objective Mixed-Integer Non-Linear Problems:
%
%
%      Minimize     F_1(X),... F_O(X)  where X(1,...N-NI)   is CONTINUOUS
%                                      and   X(N-NI+1,...N) is DISCRETE
%
%      subject to   G_j(X)  =  0   (j=1,...ME)      equality constraints
%                   G_j(X) >=  0   (j=ME+1,...M)  inequality constraints
%
%      and bounds   XL <= X <= XU
%
%
%     The problem statement of this example is given below. You can use 
%     this example as template to run your own problem. To do so: Replace 
%     the objective functions 'F' (and in case the constraints 'G') given 
%     here with your own problem and follow the below instruction steps.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   MAIN PROGRAM   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 key = 'Spyridon_Kilimtzidis_(Univ_of_Patras)_[ACADEMIC-SINGLE-USER]';   
 problem.func = @problem_function; % Call is [f,g] = problem_function(x)        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 1: Problem definition     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% STEP 1.A: Problem dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
problem.o  =  1; % Number of objectives
problem.n  = 70; % Number of variables (in total)
problem.ni =  2; % Number of integer variables (0 <= ni <= n)
problem.m  =  5; % Number of constraints (in total)
problem.me =  0; % Number of equality constraints (0 <= me <= m)
     
% STEP 1.B: Lower and upper bounds 'xl' & 'xu'  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
problem.xl(1:11)    = 12; 
problem.xl(12:22)   = 10; 
problem.xl(23:33)   = 8; 
problem.xl(34:44)   = 7; 
problem.xl(45:55)   = 4; 
problem.xl(56:66)   = 2; 
problem.xl(67)      = 0.1;
problem.xl(68)      = 0.5;
problem.xl(69)      = 6;
problem.xl(70)      = 4;

problem.xu(1:11)    = 40; 
problem.xu(12:22)   = 32 ; 
problem.xu(23:33)   = 25 ; 
problem.xu(34:44)   = 20 ; 
problem.xu(45:55)   = 17 ; 
problem.xu(56:66)   = 15 ; 
problem.xu(67)      = 0.4;
problem.xu(68)      = 0.9;
problem.xu(69)      = 52;
problem.xu(70)      = 10;


% STEP 1.C: Starting point 'x'  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
problem.x=problem.xu;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 2: Choose stopping criteria and printing options    %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% STEP 2.A: Stopping criteria 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
option.maxeval  = 250;    % Maximum number of function evaluation (e.g. 1000000)
option.maxtime  = 2*60*60*24; % Maximum time limit in Seconds (e.g. 1 Day = 60*60*24)

% STEP 2.B: Printing options  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
option.printeval  = 1;     % Print-Frequency for current best solution (e.g. 1000)
option.save2file  = 1;     % Save SCREEN and SOLUTION to TXT-files [ 0=NO/ 1=YES]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 3: Choose MIDACO parameters (FOR ADVANCED USERS)    %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

option.param( 1) =  0.1;  % ACCURACY  
option.param( 2) =  1;    % SEED      
option.param( 3) =  5000; % FSTOP
option.param( 4) =  80;   % ALGOSTOP
option.param( 5) =  200;  % EVALSTOP  
option.param( 6) =  0;   % FOCUS
option.param( 7) =  0;    % ANTS
option.param( 8) =  0;    % KERNEL
option.param( 9) =  0;    % ORACLE    
option.param(10) =  0;    % PARETOMAX   
option.param(11) =  0;    % EPSILON   
option.param(12) =  0;    % BALANCE
option.param(13) =  0;    % CHARACTER  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 4: Choose Parallelization Factor   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

option.parallel = 0;  % Serial: 0 or 1, Parallel: 2,3,4,5,6,7,8...  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Call MIDACO solver   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ solution ] = midaco( problem, option, key);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   End of Example    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   OPTIMIZATION PROBLEM   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ f, g ] = problem_function( x )

[f,g]=Optimization_Run_1(x);

g(1)=g(1)-1;
g(2)=(280*10^6-g(2))/10^6;
g(3)=6-g(3);
g(4)=15-g(4);
g(5)=g(5)-1.2*221.7;

print=[x,f,g];
fid=fopen('Design_Points.txt','a+');
fprintf(fid,['%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n' ...
            '%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n' ...
            '%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n' ...
            '%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n' ...
            '%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n' ...
            '%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n' ...
            '%1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n %1.5f\n'],print); 
fclose(fid);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%   END OF FILE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
