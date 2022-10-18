"""
Script for geometry parametrization in Hypermesh.

Evangelos Filippou, Octomber 2022
"""

# import libraries and modules needed
import math
import matplotlib.pyplot as plt
import numpy as np
from read_airfoil import read_airfoil
from run_arg import run_argument
from delete_files import delete_files

# ################# Delete Previous Files: ##################

delete_files()

# ################# User Defined Values: ##################

# Define Wing's Parameters:
SemiSpan = 29.38
TR_1 = 0.4
TR_2 = 0.2
AR = 9
Dihedral = 3  # Degrees
Sweep_LE = 25  # Degrees
Root_Torsion = -5  # Degrees
Tip_Torsion = 2  # Degrees
YB_percent = 0.37  # Percent of Semispan

# Define .dat file's url
selig_url = 'https://m-selig.ae.illinois.edu/ads/coord/falcon.dat'
# Define a path to save coordinates of the airfoil
selig_path = 'Resources/falcon-selig.dat'
coordinates, airfoil_x, airfoil_z = read_airfoil(selig_url, selig_path)

# Define Wing's Structural Parameters
N_ribs = 50

# ################# Derived Parameters: ##################


# Yehudi Break
Yehudi = SemiSpan * YB_percent

# Chords in root and tip

TR = TR_1 * TR_2
Chord_Root = 2 * SemiSpan / (AR * (1 + TR))
Chord_Yehudi = TR_1 * Chord_Root
Chord_Tip = TR_2 * Chord_Yehudi

# Sweep of the leading edge in rads
# Sweep_LE=math.atan((math.tan(Sweep25*math.pi/180)+(1-TR)/(AR*(1+TR))))
Sweep_LE = Sweep_LE * math.pi / 180

# Define ribs spacing,
Ribs_Spacing = SemiSpan / (N_ribs - 1)

# Convert torsion to rads
Root_Torsion = (Root_Torsion * math.pi / 180)
Tip_Torsion = (Tip_Torsion * math.pi / 180)

# Define scaling, coords of origin and torsion
Scaling = np.zeros((1, N_ribs))
Origin = np.zeros((3, N_ribs))
Torsion = np.zeros((1, N_ribs))

for i in range(0, N_ribs):
    Origin[0, i] = i * Ribs_Spacing * math.tan(Sweep_LE)
    Origin[1, i] = i * Ribs_Spacing * math.tan(Dihedral * math.pi / 180)
    Origin[2, i] = i * Ribs_Spacing

breakrib = 0
for i in range(0, N_ribs):

    if 0 < i < N_ribs - 1:
        if Origin[2, i - 1] < Yehudi < Origin[2, i + 1]:
            Origin[2, i] = Yehudi
            Origin[0, i] = Origin[2, i] * math.tan(Sweep_LE)
            Origin[1, i] = Origin[2, i] * math.tan(Dihedral * math.pi / 180)
            breakrib = i

Torsion[0, :] = np.interp(Origin[2, :], [0, SemiSpan],
                          [Root_Torsion, Tip_Torsion])
Scaling[0, :] = np.interp(Origin[2, :], [0, Yehudi, SemiSpan],
                          [Chord_Root, Chord_Yehudi, Chord_Tip])

"""
################## Writing in Command file: ##################
"""

# Initialization of counters
curvecounter = np.zeros(100)

# Printing airfoil nodes
with open('Commands.tcl', 'w') as f:
    f.write('#----------Commands for wing geometry generation----------\n')
    # Now print nodes in this format: *createnode x y z system id 0 0
    X = np.zeros((N_ribs, len(airfoil_x)))
    Y = np.zeros((N_ribs, len(airfoil_x)))
    Z = np.zeros((N_ribs, len(airfoil_x)))

    for i in range(0, N_ribs):
        for j in range(0, len(airfoil_x)):
            x_init = airfoil_x[j] * math.cos(Torsion[0, i])\
                - airfoil_z[j] * math.sin(Torsion[0, i])

            X[i, j] = x_init * Scaling[0, i] + Origin[0, i]

            Y[i, j] = Origin[2, i]

            z_init = airfoil_z[j] * math.cos(Torsion[0, i])\
                + airfoil_x[j] * math.sin(Torsion[0, i])

            Z[i, j] = z_init * Scaling[0, i] + Origin[1, i]

            f.write('*createnode %.7f %.7f %.7f 0 0 0\n'
                    % (X[i, j], Y[i, j], Z[i, j]))

    # Print rib curves
    for i in range(0, 2 * N_ribs):
        n = int(len(airfoil_x) / 2)  # To use it indexing
        if (i % 2) == 0:
            my_list = list(range(1 + i * n, (1 + i) * n + 2))
        else:
            my_list = list(range(1 + i * n, (1 + i) * n + 1))
        my_str = ' '.join(map(str, my_list))
        cmd = "*createlist nodes 1 " + my_str
        f.write(cmd)
        f.write("\n*createvector 1 1 0 0\n*createvector 2 1 0 0\n"
                "*linecreatespline nodes 1 0 0 1 2\n")
        curvecounter[1] += 1

    curvecounter[2] = curvecounter[1]

    # Print rib surfaces
    for i in range(0, N_ribs):
        my_list = list(range(2 * i + 1, 2 * i + 3))
        my_str = ' '.join(map(str, my_list))
        f.write("*surfacemode 4\n")
        cmd = "*createmark lines 1 " + my_str
        f.write(cmd)
        f.write("\n*surfacesplineonlinesloop 1 1 1 67\n")
        curvecounter[2] += 2

    curvecounter[3] = curvecounter[2]

    # Print LE and TE curves
    for i in range(0, N_ribs - 1):
        my_list = [i * 2 * n + 1, (i + 1) * 2 * n + 1]
        my_str = ' '.join(map(str, my_list))
        cmd = "*createlist nodes 1 " + my_str
        f.write(cmd)
        f.write("\n*linecreatefromnodes 1 0 150 5 179\n")
        curvecounter[3] += 1

    curvecounter[4] = curvecounter[3]

    for i in range(0, N_ribs - 1):
        my_list = [i * 2 * n + n + 1, (i + 1) * 2 * n + n + 1]
        my_str = ' '.join(map(str, my_list))
        cmd = "*createlist nodes 1 " + my_str
        f.write(cmd)
        f.write("\n*linecreatefromnodes 1 0 150 5 179\n")
        curvecounter[4] += 1

    curvecounter[5] = curvecounter[4]

    for i in range(0, N_ribs - 1):
        my_list = [curvecounter[0] + 2*i + 1, curvecounter[0] + 2*i + 3,
                   curvecounter[2] + i + 1, curvecounter[3] + i + 1]
        my_str = ' '.join(map(str, my_list))
        cmd = "*createmark lines 1 " + my_str
        f.write("*surfacemode 4\n")
        f.write(cmd)
        f.write("\n*surfacesplineonlinesloop 1 0 0\n")

    for i in range(0, N_ribs - 1):
        my_list = [curvecounter[0] + 2*i + 2, curvecounter[0] + 2*i + 4,
                   curvecounter[2] + i + 1, curvecounter[3] + i + 1]
        my_str = ' '.join(map(str, my_list))
        cmd = "*createmark lines 1 " + my_str
        f.write("*surfacemode 4\n")
        f.write(cmd)
        f.write("\n*surfacesplineonlinesloop 1 0 0\n")

    f.write("\n*nodecleartempmark\n")
    f.write("\n*numbers 1\n*createmark lines 1 \"all\"\n"
            "*numbersmark lines 1 1\n")  # Show lines
    f.write("\n*drawlistresetstyle\n*createmark lines 1 \"all\""
            "\n*deletemark lines 1\n")

f.close()

ax = plt.axes(projection='3d')
fig_2 = plt.figure(figsize=(9, 6))
np.random.seed(3)

ax.scatter3D(X, Y, Z, color='red')
ax.set_title("Wing Sections", pad=25, size=15)
ax.set_xlabel("X")
ax.set_ylabel("Y")
ax.set_zlabel("Z")
plt.show()

# ################# Running the Command file: ##################

# Location of .tcl script
TCLScript = "C:/Users/Vagelis/Documents/UC3M_Internship/Python/"\
            "UC3M_Parametric_Design/Commands.tcl"

run_argument(TCLScript)
