"""Function that reads the desired airfoil from database."""

import numpy
import urllib.request
from matplotlib import pyplot


# Function for retrieving and saving airfoil to file.
def read_airfoil(selig_url, selig_path):
    """
    Parameters.

    ----------
    selig_url : The airfoil's url.
    selig_path : The path to store airfoil.

    Returns.
    -------
    coordinates : The pair of x,y coordinates of the airfoil.
    x : The x coordinates of the airfoil.
    y : The y coordinates of the airfoil.
    """
    urllib.request.urlretrieve(selig_url, selig_path)
    # Load coordinates from file.
    with open(selig_path, 'r') as infile:
        x, y = numpy.loadtxt(infile, unpack=True, skiprows=2)

    y[0] = 0
    y[-1] = 0
    x[0] = 1
    coordinates = [x, y]
    pyplot.plot(x, y, color='k', linestyle='-', linewidth=2)
    return coordinates, x, y
