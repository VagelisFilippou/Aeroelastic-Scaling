function wait_for_exe(process,executable)
%% Waiting for Patran to execute 

% MATLAB will continue execution once EXE is launched
disp('MATLAB continues after calling EXE')
% Check to see if the EXE process exists
flag = true;

while flag
    disp([process,' still running'])
    flag = isprocess(executable); % isprocess is the function attached. Place it on the MATLAB path.
    pause(1) % check every 1 second
    
end

disp([process,' is done'])
disp('continuing with MATLAB script')