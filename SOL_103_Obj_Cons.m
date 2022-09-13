function [Min_EigFreq]=SOL_103_Obj_Cons(h5_file)
h5data_103=h5extract(h5_file);
EigFreq=h5data_103.NASTRAN.RESULT.SUMMARY.EIGENVALUE.FREQ;  
Min_EigFreq=min(EigFreq);