'''
Just a quick and dirty piece of code to check if we successfully write waveforms
from ENVI cubes to SPD files. I've found sometimes it doesn't due to some
bugs. But now they should be all fixed. Just in case, use this code to check it
out.

Zhan Li, zhanli86@bu.edu
Created: 20140612
Last modified: 20141111
'''

import optparse
import sys
import os
import datetime
import numpy as np
from osgeo import gdal
# On GEO server after module load newer python or gdal version, the PYTHONPATH will be overwritten now
# To avoid the loss of the path to spdpy in the PYTHONPATH, include your own python package path here.
sys.path.append('/usr3/graduate/zhanli86/lib64/python2.6/site-packages')
import spdpy

import pdb; pdb.set_trace()

spdfile = spdpy.openSPDFileHeader('/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_ESP_Cal/Brisbane2013_ESP6m/July30_6m_1064_cube_NadirCorrect_Aligned.spd')

pulses = spdpy.readSPDPulsesRow(spdfile, 3)

print(pulses[999][0].received)

print('checkspd\n')
