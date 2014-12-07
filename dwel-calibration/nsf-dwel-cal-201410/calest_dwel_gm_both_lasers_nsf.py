"""
calest_dwel_gm_both_lasers.py
zhanli86@bu.edu

Purpose: estimate the calibration constand and telescope efficiency parameters
in a given model with Monte Carlo method along with Differential Evolutionary optimization. 
The optimization is from Sherpa module from Harvard University. 

Input data points: range, return intensity and target reflectance.

DWEL model by David Jupp from growth modelling is used here.

The calibration parameters for the two lasers are put together for fitting and
estimation. The power of range is forced to be the same for the two lasers.

This script is to calibrate NSF DWEL with stationary data collected from UML CAR
hallway on 20140812

Last modified: 20141118

"""

import sys
import os
from math import exp
import numpy as np # numpy package
import csv # csv package to read csv file of calibration data
import matplotlib
import matplotlib.pyplot as plt # module to plot data
# import h5py
# import module components from sherpa for optimization
# the code below is mostly copied from Ewan Douglas's code.
# Still need to work on how to use sherpa functions.
from sherpa.models import ArithmeticModel, Parameter,PowLaw1D
from sherpa.data import Data1D
from sherpa.data import Data2D
from sherpa.stats import Chi2DataVar
# from sherpa.stats import LeastSq
# from sherpa.optmethods import LevMar
from sherpa.optmethods import MonCar
# from sherpa.optmethods import NelderMead
from sherpa.fit import Fit

# ******************************************************************************
# Some inputs
CalFileName1548='/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/cal_nsf_20140812_panel_returns_refined_stats_1548_for_calest.txt'
panelrefl1548 = np.array([0.984,0.349,0.245,0.041])

CalFileName1064='/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/cal_nsf_20140812_panel_returns_refined_stats_1064_for_calest.txt'
panelrefl1064 = np.array([0.987, 0.436, 0.320, 0.041])

# number of panels in the input csv filel
numpanels = 3

# the file name for writing calibration fitting results.
outputfilename = 'CalibrationEst_Output_DWEL_GM_Both_Lasers_NSF_20140812.txt'
# end of inputs section
# ******************************************************************************

# ******************************************************************************
# read and prepare data for fitting calibration models
# read calibration data from csv file
# file name of the calibrationd data. 
caldata1064 = []
with open(CalFileName1064, 'rb') as calfile:
  calreader = csv.reader(calfile)
  next(calreader) # skip the first line of column names
  for row in calreader:
    caldata1064.append(map(float, row))
caldata1064 = np.array(caldata1064)
# prepare four vectors for fitting calibration models:
# ranges, reflectances, return intensity in DN and standard deviation of return
# power in DN.
npts = caldata1064.size
for c in range(0, 4):
  tmpnpts = np.count_nonzero(caldata1064[:,c*numpanels+np.arange(0,numpanels)])
  if tmpnpts < npts:
    npts = tmpnpts
ranges1064 = np.zeros(npts)
refls1064 = np.zeros(npts)
ret_ints1064 = np.zeros(npts)
ret_ints_sd1064 = np.zeros(npts)
panelind1064 = np.zeros(npts)
rangeind1064 = np.zeros(npts)
ptsind = 0
for p in range(0, numpanels):
  for r in range(0, caldata1064.shape[0]):
    tmprg = caldata1064[r, p]
    tmpint = caldata1064[r, p+6]
    tmpint_sd = caldata1064[r, p+9]
    if tmprg != 0 and tmpint !=0 and tmpint_sd !=0:
      ranges1064[ptsind] = tmprg
      refls1064[ptsind] = panelrefl1064[p]
      ret_ints1064[ptsind] = tmpint
      ret_ints_sd1064[ptsind] = tmpint_sd
      panelind1064[ptsind] = p
      rangeind1064[ptsind] = r
      ptsind = ptsind + 1
    if ptsind >= npts:
      break
# remove some not-so-good data points according to log analysis of far range
# data.
oldranges1064 = ranges1064
oldrefls1064 = refls1064
oldret_ints1064 = ret_ints1064
oldret_ints_sd1064 = ret_ints_sd1064
oldpanelind1064 = panelind1064
oldrangeind1064 = rangeind1064
tmpflag = (panelind1064 == 0)
ranges1064 = ranges1064[np.logical_not(tmpflag)]
refls1064 = refls1064[np.logical_not(tmpflag)]
ret_ints1064 = ret_ints1064[np.logical_not(tmpflag)]
ret_ints_sd1064 = ret_ints_sd1064[np.logical_not(tmpflag)]
panelind1064 = panelind1064[np.logical_not(tmpflag)]
rangeind1064 = rangeind1064[np.logical_not(tmpflag)]

# read and prepare data for fitting calibration models
# read calibration data from csv file
# file name of the calibrationd data. 
caldata1548 = []
with open(CalFileName1548, 'rb') as calfile:
  calreader = csv.reader(calfile)
  next(calreader) # skip the first line of column names
  for row in calreader:
    caldata1548.append(map(float, row))
caldata1548 = np.array(caldata1548)
# prepare four vectors for fitting calibration models:
# ranges, reflectances, return intensity in DN and standard deviation of return
# power in DN.
npts = caldata1548.size
for c in range(0, 4):
  tmpnpts = np.count_nonzero(caldata1548[:,c*numpanels+np.arange(0,numpanels)])
  if tmpnpts < npts:
    npts = tmpnpts
ranges1548 = np.zeros(npts)
refls1548 = np.zeros(npts)
ret_ints1548 = np.zeros(npts)
ret_ints_sd1548 = np.zeros(npts)
panelind1548 = np.zeros(npts)
rangeind1548 = np.zeros(npts)
ptsind = 0
for p in range(0, numpanels):
  for r in range(0, caldata1548.shape[0]):
    tmprg = caldata1548[r, p]
    tmpint = caldata1548[r, p+6]
    tmpint_sd = caldata1548[r, p+9]
    if tmprg != 0 and tmpint !=0 and tmpint_sd !=0:
      ranges1548[ptsind] = tmprg
      refls1548[ptsind] = panelrefl1548[p]
      ret_ints1548[ptsind] = tmpint
      ret_ints_sd1548[ptsind] = tmpint_sd
      panelind1548[ptsind] = p
      rangeind1548[ptsind] = r
      ptsind = ptsind + 1
    if ptsind >= npts:
      break
# remove some not-so-good data points according to log analysis of far range
# data.
oldranges1548 = ranges1548
oldrefls1548 = refls1548
oldret_ints1548 = ret_ints1548
oldret_ints_sd1548 = ret_ints_sd1548
oldpanelind1548 = panelind1548
oldrangeind1548 = rangeind1548
tmpflag = np.logical_or(panelind1548 == 0, np.logical_and(ranges1548 > 34.5, ranges1548 < 40.5))
ranges1548 = ranges1548[np.logical_not(tmpflag)]
refls1548 = refls1548[np.logical_not(tmpflag)]
ret_ints1548 = ret_ints1548[np.logical_not(tmpflag)]
ret_ints_sd1548 = ret_ints_sd1548[np.logical_not(tmpflag)]
panelind1548 = panelind1548[np.logical_not(tmpflag)]
rangeind1548 = rangeind1548[np.logical_not(tmpflag)]

import pdb; pdb.set_trace()

# end of data preparation
# ******************************************************************************

class DWEL_FUN_GM_DUAL(ArithmeticModel):
# the calibration model David found for Oz DWEL now.
# It's from growth modelling literature that offers more flexibility to fit a
# sigmoid function. 
  def __init__(self, name='dual growth_modelling'):
	  self.C0nir = Parameter(name, 'C0nir', 38464)
	  self.C1nir = Parameter(name, 'C1nir', 0)
	  self.C2nir = Parameter(name, 'C2nir', 0)
	  self.C3nir = Parameter(name, 'C3nir', 0)
       	  self.C4nir = Parameter(name, 'C4nir', 0)
       	  self.C0swir = Parameter(name, 'C0swir', 28724)
	  self.C1swir = Parameter(name, 'C1swir', 0)
	  self.C2swir = Parameter(name, 'C2swir', 0)
	  self.C3swir = Parameter(name, 'C3swir', 0)
       	  self.C4swir = Parameter(name, 'C4swir', 0)

	  self.b = Parameter(name, 'b', 2.0) # ind: 10
	  ArithmeticModel.__init__(self, name, (self.C0nir, self.C1nir,
                                                self.C2nir, self.C3nir, self.C4nir,
                                                self.C0swir, self.C1swir,
                                                self.C2swir, self.C3swir,
                                                self.C4swir, self.b))
          
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs):
	  ret_power = \
          (p[0]*x1/x0**p[10])*(1.0+p[1]*np.exp(-1*p[2]*(x0+p[3])))**(-1*p[4]) + \
	  (p[5]*x1/x0**p[10])*(1.0+p[6]*np.exp(-1*p[7]*(x0+p[8])))**(-1*p[9])
	  return ret_power

# # output results to an ASCII file
# outputfile =  open(outputfilename, 'w')

# # ******************************************************************************
# # fit with std error of dependent variable, return power
# ranges = np.concatenate([ranges1064, ranges1548])

# data = Data2D('NSF20140812', ranges, refls, ret_ints,
#               staterror=ret_ints_sd)
# # import pdb; pdb.set_trace();
# # fit without std error of dependent variable makes no difference here. no results are output or plot here. 
# # data = Data2D('Ewan',ranges[:-2], np.ones(len(ranges[:-2])), power[:-2]) 
# f_evi = Fit(data, evi, stat=Chi2DataVar(), method=MonCar())
# f_evi_alt = Fit(data, evi_alt, stat=Chi2DataVar(), method=MonCar())
# f_dwel = Fit(data, dwel, stat=Chi2DataVar(), method=MonCar())
# f_dwel_alt = Fit(data, dwel_alt, stat=Chi2DataVar(), method=MonCar())
# f_dwel_gm = Fit(data, dwel_gm, stat=Chi2DataVar(), method=MonCar())
# # get the fitting results
# evi_fit = f_evi.fit()
# evi_alt_fit = f_evi_alt.fit()
# dwel_fit = f_dwel.fit()
# dwel_alt_fit = f_dwel_alt.fit()
# dwel_gm_fit = f_dwel_gm.fit()
# print("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), NSF stationary scan 20140812:")
# print evi_fit.format()

