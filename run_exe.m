function run_exe(executable,argument)
% use -b if you want to run on batch mode -ans yes 

proc = System.Diagnostics.Process(); 
proc.StartInfo.FileName = executable;
proc.StartInfo.Arguments = argument ;
proc.StartInfo.UseShellExecute = false;
proc.StartInfo.RedirectStandardInput = true;
proc.StartInfo.CreateNoWindow = true;
proc.Start();
pid = proc.Id();
