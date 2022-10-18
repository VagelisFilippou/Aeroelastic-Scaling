"""Function that feeds the desired .tcl file to HyperMesh."""

import subprocess


def run_argument(TCLScript):
    # If you want to run in  batch mode use this path:
    # hmBatchLoc = "C:/Program Files/Altair/2019/hm/bin/win64/hmbatch.exe"
    hm_loc = "C:/Program Files/Altair/2019/hm/bin/win64/hmopengl.exe"
    arg = hm_loc + " -tcl " + TCLScript

    subprocess.call(arg)
