"""
CalibrationEst_Correction.py
zhanli86@bu.edu

Purpose: estimate the calibration constand and telescope efficiency parameters
in a given model with Monte Carlo method along with Differential Evolutionary optimization. 
The optimization is from Sherpa module from Harvard University. 
Input data points: range, return intensity and target reflectance.
Two models are used here: 1) EVI model with its own telescope efficiency model;
2) DWEL model with the telescope efficiency model from Ewan Douglas.

This script is to calibrate NSF DWEL with stationary data collected from UML CAR
hallway on 20140812

Last modified: 20141112

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
wavelength = 1548
CalFileName='/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/cal_nsf_20140812_panel_returns_refined_stats_1548_for_calest.txt'
panelrefl = np.array([0.984,0.349,0.245,0.041])

# wavelength = 1064
# CalFileName='/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/cal_nsf_20140812_panel_returns_refined_stats_1064_for_calest.txt'
# panelrefl = np.array([0.987, 0.436, 0.320, 0.041])

# number of panels in the input csv filel
numpanels = 3

# the file name for writing calibration fitting results.
outputfilename = 'CalibrationEst_Output_NSF_20140812_'+str(wavelength)+'.txt'
# end of inputs section
# ******************************************************************************

# ******************************************************************************
# read and prepare data for fitting calibration models
# read calibration data from csv file
# file name of the calibrationd data. 
caldata = []
with open(CalFileName, 'rb') as calfile:
  calreader = csv.reader(calfile)
  next(calreader) # skip the first line of column names
  for row in calreader:
    caldata.append(map(float, row))
caldata = np.array(caldata)
# prepare four vectors for fitting calibration models:
# ranges, reflectances, return intensity in DN and standard deviation of return
# power in DN.
npts = caldata.size
for c in range(0, 4):
  tmpnpts = np.count_nonzero(caldata[:,c*numpanels+np.arange(0,numpanels)])
  if tmpnpts < npts:
    npts = tmpnpts
ranges = np.zeros(npts)
refls = np.zeros(npts)
ret_ints = np.zeros(npts)
ret_ints_sd = np.zeros(npts)
panelind = np.zeros(npts)
rangeind = np.zeros(npts)
ptsind = 0
for p in range(0, numpanels):
  for r in range(0, caldata.shape[0]):
    tmprg = caldata[r, p]
    tmpint = caldata[r, p+6]
    tmpint_sd = caldata[r, p+9]
    if tmprg != 0 and tmpint !=0 and tmpint_sd !=0:
      ranges[ptsind] = tmprg
      refls[ptsind] = panelrefl[p]
      ret_ints[ptsind] = tmpint
      ret_ints_sd[ptsind] = tmpint_sd
      panelind[ptsind] = p
      rangeind[ptsind] = r
      ptsind = ptsind + 1
    if ptsind >= npts:
      break

tmpflag = panelind != 0
ranges = ranges[tmpflag]
refls = refls[tmpflag]
ret_ints = ret_ints[tmpflag]
ret_ints_sd = ret_ints_sd[tmpflag]
panelind = panelind[tmpflag]
rangeind = rangeind[tmpflag]
    
# remove some not-so-good data points according to log analysis of far range
# data.
oldranges = ranges
oldrefls = refls
oldret_ints = ret_ints
oldret_ints_sd = ret_ints_sd
oldpanelind = panelind
oldrangeind = rangeind

# if wavelength == 1548:
#   tmpflag = np.logical_or(np.logical_or(panelind == 0, ranges<6.0), np.logical_and(ranges > 34.5, ranges < 40.5))
# else:
#   tmpflag = np.logical_or(panelind == 0, ranges<6.0)

if wavelength == 1548:
  tmpflag = np.logical_or(panelind == 0, np.logical_and(ranges > 34.5, ranges < 40.5))
else:
  tmpflag = np.logical_or(panelind == 0)

ranges = ranges[np.logical_not(tmpflag)]
refls = refls[np.logical_not(tmpflag)]
ret_ints = ret_ints[np.logical_not(tmpflag)]
ret_ints_sd = ret_ints_sd[np.logical_not(tmpflag)]
panelind = panelind[np.logical_not(tmpflag)]
rangeind = rangeind[np.logical_not(tmpflag)]
if wavelength == 1064:
  b0 = 1.856080 # 2 
  c0 = np.exp(10.557476) # 58590.853
if wavelength == 1548:
  b0 = 1.588007 #1.620258# 2 
  c0 = np.exp(10.26548) #np.exp(10.257597) # 102950.366 

# end of data preparation
# ******************************************************************************

# import pdb; pdb.set_trace();

# ******************************************************************************
# explore the calibration data to see possibilities of math models to fit.
# plot P_r*d^2/rho against range, this should be the curve of telescope
# efficiency scaled by a calibration constant
c_kd = ret_ints * ranges**2 / refls
#fig2 = plt.figure()
tmpind = np.argsort(ranges)
#plt.plot(ranges[tmpind], c_kd[tmpind], '-o')
#plt.show(block=False)
# ******************************************************************************
#import pdb; pdb.set_trace();
    
# ******************************************************************************
# define EVI model.
class EVI_FUN(ArithmeticModel): 
# class EVI_FUN is inheritated from a sherpa model 'ArithmeticModel'
# this is a user-defined model that sherpa's fitting function can take
  def __init__(self, name='simple_overfilling'):
       self.amplitude = Parameter(name, 'amplitude', c0, min=0) # p[0], calibration constant
       self.b = Parameter(name, 'b', 2, min=0) # p[1], range factor
       self.Ck = Parameter(name,'Ck',1, min=0) # p[2], telescope efficiency parameter
       # self.Cb = Parameter(name, 'Cb', 1) # p[3], background noise
       # ArithmeticModel.__init__(self, name, (self.amplitude, self.b, self.Ck, self.Cb))
       ArithmeticModel.__init__(self, name, (self.amplitude, self.b, self.Ck))
       
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs): 
    # the definition of the function 'calc' here follows the fashion of the
    # class 'sherpa.models.Model'.  In this way, this user-defined function can
    # be taken by sherpa's fitting function.  x0, x1, two ndarry of domain
    # values (according to
    # http://pysherpa.blogspot.com/2010/11/user-defined-model-and-fit-statistic.html).
    # EVI model has two variables: range given by x0 and reflectance given by
    # x1.
    #print x0
    #print x1
    #print p
    # ret_power=(p[0]*x1/x0**p[1])*(1-np.array(map(exp,-x0**2/p[2]))) + p[3]
    ret_power=(p[0]*x1/x0**p[1])*(1-np.array(map(exp,-x0**2/p[2])))
    #print ret_power
    return ret_power
# end of EVI model definition
# ******************************************************************************

# ******************************************************************************
# define an alternate EVI model with range factor fixed at 2. 
class EVI_FUN_alt(ArithmeticModel): 
# class EVI_FUN is inheritated from a sherpa model 'ArithmeticModel'
# this is a user-defined model that sherpa's fitting function can take
  def __init__(self, name='simple_overfilling'):
       self.amplitude = Parameter(name, 'amplitude', c0, min=0) # p[0], calibration constant
       self.Ck = Parameter(name,'Ck', 1, min=0) # p[1], telescope efficiency parameter
       # self.b = Parameter(name, 'b', 2, min=1, max=3) # p[2], range factor
       # self.Cb = Parameter(name, 'Cb', 1) # background noise
       # ArithmeticModel.__init__(self, name, (self.amplitude, self.Ck, self.Cb))
       ArithmeticModel.__init__(self, name, (self.amplitude, self.Ck))
       
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs): 
    # the definition of the function 'calc' here follows the fashion of the class 'sherpa.models.Model'.
    # In this way, this user-defined function can be taken by sherpa's fitting function. 
    # x0, x1, two ndarry of domain values (according to http://pysherpa.blogspot.com/2010/11/user-defined-model-and-fit-statistic.html).
    # EVI model has two variables: range given by x0 and reflectance given by x1.
#    x1=1 # x1 is reflectance, now it's fixed at 1 from Lambertian panel. 
    ret_power=(p[0]*x1/x0**2)*(1-np.array(np.exp(-x0**2/p[1])))
    return ret_power
# end of alternate EVI model definition
# ******************************************************************************

# ******************************************************************************
# define a DWEL model by Ewan
class DWEL_FUN(ArithmeticModel):
  def __init__(self, name='simple_overfilling'):
	  self.C0 = Parameter(name, 'C0', c0, min=0)
	  self.C1 = Parameter(name, 'C1', 1, min=0)
	  self.C2 = Parameter(name, 'C2', 1, min=0)
	  # self.C3 = Parameter(name, 'C3', 0)
	  # ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2, self.C3))
          ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2))
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs):
    # the definition of the function 'calc' here follows the fashion of the
    # class 'sherpa.models.Model'.  In this way, this user-defined function can
    # be taken by sherpa's fitting function.  x0, x1, two ndarry of domain
    # values (according to
    # http://pysherpa.blogspot.com/2010/11/user-defined-model-and-fit-statistic.html).
    # EVI model has two variables: range given by x0 and reflectance given by
    # x1.
	  ret_power =(p[0]*x1/x0**2)*(1.-np.exp(-(p[2]*x0)**2/((p[1]+x0)**2)))
	  return ret_power

class DWEL_FUN_alt(ArithmeticModel):
# alternate DWEL model include an extra parameter of range factor
  def __init__(self, name='simple_overfilling'):
    self.C0 = Parameter(name, 'C0', c0, min=0)
    self.C1 = Parameter(name, 'C1', 1, min=0)
    self.C2 = Parameter(name, 'C2', 1, min=0)
    self.b = Parameter(name, 'b', b0, min=0)
#    self.C3 = Parameter(name, 'C3', 0)
#    ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2, self.b, self.C3))
    ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2, self.b))
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs):
  # ret_power =(p[0]*x1/x0**p[3])*(1.-np.exp(-(p[2]*x0)**2/((p[1]+x0)**2))) + p[4]
    ret_power =(p[0]*x1/x0**p[3])*(1.-np.exp(-(p[2]*x0)**2/((p[1]+x0)**2)))
    return ret_power

class DWEL_FUN_GM(ArithmeticModel):
# the calibration model David found for Oz DWEL now.
# It's from growth modelling literature that offers more flexibility to fit a
# sigmoid function. 
  def __init__(self, name='growth_modelling'):
	  self.C0 = Parameter(name, 'C0', c0)
	  self.C1 = Parameter(name, 'C1', 0)
	  self.C2 = Parameter(name, 'C2', 0)
	  self.C3 = Parameter(name, 'C3', 0)
       	  self.C4 = Parameter(name, 'C4', 0)
	  self.b = Parameter(name, 'b', b0, min=0)
	  ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2,
                                                self.C3, self.C4, self.b))
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs):
	  ret_power =(p[0]*x1/x0**p[5])*(1.0+p[1]*np.exp(-1*p[2]*(x0+p[3])))**(-1*p[4])
	  return ret_power

# end of DWEL model definition by Ewan
# ******************************************************************************

# ******************************************************************************
# define a telescope efficiency model, kd
class DWEL_KD(ArithmeticModel):
# alternate DWEL model include an extra parameter of range factor
  def __init__(self, name='DWEL_K_d'):
	  self.C1 = Parameter(name, 'C1', 3.96, min=0)
	  self.C2 = Parameter(name, 'C2', 2.614, min=0)
# values larger than one
	  ArithmeticModel.__init__(self, name, (self.C1, self.C2))
  def calc(self, p, x, xhi=None, *args, **kwargs):
	  kd = 1.-np.exp(-(p[1]*x)**2/((p[0]+x)**2))
	  return kd
# ******************************************************************************

# ******************************************************************************
# define a telescope efficiency model from growth modelling, kd
class DWEL_KD_GM(ArithmeticModel):
# alternate DWEL model include an extra parameter of range factor
  def __init__(self, name='DWEL_K_d_GM'):
	  # self.C1 = Parameter(name, 'C1', 0)
	  # self.C2 = Parameter(name, 'C2', 0)
          # self.C3 = Parameter(name, 'C3', 0)
          # self.C4 = Parameter(name, 'C4', 0)
	  self.C1 = Parameter(name, 'C1', 2.33)
	  self.C2 = Parameter(name, 'C2', 0.60)
          self.C3 = Parameter(name, 'C3', 0.75)
          self.C4 = Parameter(name, 'C4', 7.13)
	  ArithmeticModel.__init__(self, name, (self.C1, self.C2, self.C3,
                                                self.C4))
  def calc(self, p, x, xhi=None, *args, **kwargs):
          kd = (1.0+p[0]*np.exp(-1*p[1]*(x+p[2])))**(-1*p[3])
	  return kd
# ******************************************************************************
  
# ******************************************************************************
# define a telescope efficiency model from EVI, kd
class EVI_KD(ArithmeticModel):
# alternate DWEL model include an extra parameter of range factor
  def __init__(self, name='EVI_K_d'):
	  self.C1 = Parameter(name, 'C1', 1, min=1)
# values larger than one
	  ArithmeticModel.__init__(self, name, (self.C1))
  def calc(self, p, x, xhi=None, *args, **kwargs):
          kd = 1 - np.exp(-1*x**2/p[0])
	  return kd
# ******************************************************************************
  
# ******************************************************************************
# create calibration models
print("start fitting to evi model ...")
evi = EVI_FUN('EVI')
print("start fitting to alternate evi model ...")
evi_alt = EVI_FUN_alt('EVI_alt')
print("start fitting to dwel model ...")
dwel = DWEL_FUN('DWEL')
print("start fitting to alternate dwel model")
dwel_alt = DWEL_FUN_alt('DWEL_alt')
print("start fitting to Oz dwel model from growth modelling")
dwel_gm = DWEL_FUN_GM('DWEL_GM')
# ******************************************************************************

# output results to an ASCII file
outputfile =  open(outputfilename, 'w')

# ******************************************************************************
# fit with std error of dependent variable, return power
data = Data2D('NSF20140812', ranges, refls, ret_ints,
              staterror=ret_ints_sd)
# import pdb; pdb.set_trace();
# fit without std error of dependent variable makes no difference here. no results are output or plot here. 
# data = Data2D('Ewan',ranges[:-2], np.ones(len(ranges[:-2])), power[:-2]) 
f_evi = Fit(data, evi, stat=Chi2DataVar(), method=MonCar())
f_evi_alt = Fit(data, evi_alt, stat=Chi2DataVar(), method=MonCar())
f_dwel = Fit(data, dwel, stat=Chi2DataVar(), method=MonCar())
f_dwel_alt = Fit(data, dwel_alt, stat=Chi2DataVar(), method=MonCar())
f_dwel_gm = Fit(data, dwel_gm, stat=Chi2DataVar(), method=MonCar())

# import pdb; pdb.set_trace()
# get the fitting results
evi_fit = f_evi.fit()
evi_alt_fit = f_evi_alt.fit()
dwel_fit = f_dwel.fit()
dwel_alt_fit = f_dwel_alt.fit()
dwel_gm_fit = f_dwel_gm.fit()
print("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), NSF stationary scan 20140812:")
print evi_fit.format()
print("Fitting to alternate EVI model, three parameters (C_0, C_k, C_b), NSF stationary scan 20140812:")
print evi_alt_fit.format()
print("Fitting to DWEL model, four parameters (C_0, C_1, C_2, C_3), NSF stationary scan 20140812:")
print dwel_fit.format()
print("Fitting to alternate DWEL model, five parameters (C_0, C_1, C_2, C_3, b), NSF stationary scan 20140812:")
print dwel_alt_fit.format()
print("Fitting to DWEL model from growth modelling, SIX parameters (C_0, C_1, C_2, C_3, C_4, b), NSF stationary scan 20140812:")
print dwel_gm_fit.format()
# write results to output file
outputfile.write("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), NSF stationary scan 20140812:\n")
outputfile.write(evi_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to alternate EVI model, three parameters (C_0, C_k, C_b), NSF stationary scan 20140812:\n")
outputfile.write(evi_alt_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to DWEL model, four parameters (C_0, C_1, C_2_C_3), NSF stationary scan 20140812:\n")
outputfile.write(dwel_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to alternate DWEL model, five parameters (C_0, C_1, C_2, C_3, b), NSF stationary scan 20140812:\n")
outputfile.write(dwel_alt_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to DWEL model from growth modelling, SIX parameters(C_0, C_1, C_2, C_3, C_4, b), NSF stationary scan 20140812:")
outputfile.write(dwel_gm_fit.format())
outputfile.write("\n")

#import pdb; pdb.set_trace()

fig2 = plt.figure(figsize=(18, 9), dpi=96)
plt.subplot(121)
# plot calibration estimate results for each panel separately
xlim_plt = (0, 70)
ylim_plt = (0, 600)
colorstr = ['red', 'green', 'blue']
for p in range(0, numpanels):
  range_samples = np.array(np.array(range(1000))*0.075)
  refl_samples = np.ones(len(range_samples))*panelrefl[p]

  # get the data points of this panel
  tmpflag = oldpanelind == p
  # sort the ranges
  tmpind = np.argsort(oldranges[tmpflag])
  # plot calibration data points against range
  plt.errorbar(oldranges[tmpflag][tmpind], oldret_ints[tmpflag][tmpind],
             yerr=oldret_ints_sd[tmpflag][tmpind], color=colorstr[p],
             label="Measured")   
  # plot modeled power against range
  dwel_power_samples = dwel(range_samples, refl_samples)
  plt.plot(range_samples, dwel_power_samples, linestyle='-', lw=1, alpha=0.8,
           color=colorstr[p], label="DWEL four param fit w/ bg const")

plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU after preprocessing and laser power variation correction",fontsize=10)
plt.title('Ewan_2 model, $P_r ='
          '\\frac{C_0*\\rho}{r^2}*(1-\\exp(-\\frac{(C_2*r)^2}{(C_1+r)^2}))$, NSF 20140812, '+str(wavelength)+' nm')
# scatter plot between modeled return intensity and measured intensity
# also calculate r-square of the fitting
plt.subplot(122)
oldret_ints_model = dwel(oldranges, oldrefls)
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', linestyle='None',
         label='all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')
ret_ints_model = dwel(ranges, refls)
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', linestyle='None',
         label='$R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')
plt.axis('equal')
plt.xlabel('measured return intensity')
plt.ylabel('modeled return intensity')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('Scatter plot between measured and modeled')
plt.savefig('Scatter_plot_modeled_return_intensity_Ewan_dwel_2_nsf_20140812_'+str(wavelength)+'.png')
#plt.show(block=False)
#plt.close(fig2)

# import pdb; pdb.set_trace()

fig3 = plt.figure(figsize=(18, 9), dpi=96)
# plot calibration estimate results for each panel separately
plt.subplot(121)
xlim_plt = (0, 70)
ylim_plt = (0, 600)
colorstr = ['red', 'green', 'blue']
for p in range(0, numpanels):
  range_samples = np.array(np.array(range(1000))*0.075)
  refl_samples = np.ones(len(range_samples))*panelrefl[p]
  # # get the data points of this panel
  # tmpflag = data.x1 == panelrefl[p]
  # # sort the ranges
  # tmpind = np.argsort(data.x0[tmpflag])
  # # plot calibration data points
  # plt.errorbar(data.x0[tmpflag][tmpind], data.y[tmpflag][tmpind],
  #              yerr=data.get_yerr()[tmpflag][tmpind], color=colorstr[p],
  #              label="Measured")  

  # get the data points of this panel
  tmpflag = oldpanelind == p
  # sort the ranges
  tmpind = np.argsort(oldranges[tmpflag])
  # plot calibration data points against range
  plt.errorbar(oldranges[tmpflag][tmpind], oldret_ints[tmpflag][tmpind],
             yerr=oldret_ints_sd[tmpflag][tmpind], color=colorstr[p],
             label="Measured")   

  # plot modeled power against range
  evi_power_samples = evi(range_samples, refl_samples)
  plt.plot(range_samples, evi_power_samples, linestyle=':', lw=1, alpha=0.8,
           color=colorstr[p],label="EVI four param fit w/ b, w/ bg const")
  
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU after preprocessing and laser power variation correction",fontsize=10)
plt.title('EVI_b model, $P_r = \\frac{C_0*\\rho}{r^b}*(1-\\exp(-\\frac{r^2}{C_k}))$, NSF 20140812, '+str(wavelength)+' nm')
# scatter plot between modeled return intensity and measured intensity
# also calculate r-square of the fitting
plt.subplot(122)
oldret_ints_model = evi(oldranges, oldrefls)
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', linestyle='None',
         label='all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')

ret_ints_model = evi(ranges, refls)
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', linestyle='None',
         label='$R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')
plt.axis('equal')
plt.xlabel('measured return intensity')
plt.ylabel('modeled return intensity')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('Scatter plot between measured and modeled')
plt.savefig('Scatter_plot_modeled_return_intensity_evi_b_nsf_20140812_'+str(wavelength)+'.png')

fig4 = plt.figure(figsize=(18, 9), dpi=96)
# plot calibration estimate results for each panel separately
plt.subplot(121)
xlim_plt = (0, 70)
ylim_plt = (0, 600)
colorstr = ['red', 'green', 'blue']
for p in range(0, numpanels):
  range_samples = np.array(np.array(range(1000))*0.075)
  refl_samples = np.ones(len(range_samples))*panelrefl[p]
  # # get the data points of this panel
  # tmpflag = data.x1 == panelrefl[p]
  # # sort the ranges
  # tmpind = np.argsort(data.x0[tmpflag])
  # # plot calibration data points
  # plt.errorbar(data.x0[tmpflag][tmpind], data.y[tmpflag][tmpind],
  #              yerr=data.get_yerr()[tmpflag][tmpind], color=colorstr[p],
  #              label="Measured")
  
  # get the data points of this panel
  tmpflag = oldpanelind == p
  # sort the ranges
  tmpind = np.argsort(oldranges[tmpflag])
  # plot calibration data points against range
  plt.errorbar(oldranges[tmpflag][tmpind], oldret_ints[tmpflag][tmpind],
             yerr=oldret_ints_sd[tmpflag][tmpind], color=colorstr[p],
             label="Measured")   

  # plot modeled power against range
  evi_alt_power_samples = evi_alt(range_samples, refl_samples)
  plt.plot(range_samples, evi_alt_power_samples, linestyle='-.', lw=1,
           alpha=0.8, color=colorstr[p],label="EVI three param fit w/ bg const")
  
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU after preprocessing and laser power variation correction",fontsize=10)
plt.title('EVI_2 model, $P_r = \\frac{C_0*\\rho}{r^2}*(1-\\exp(-\\frac{r^2}{C_k}))$, NSF 20140812, '+str(wavelength)+' nm')
# scatter plot between modeled return intensity and measured intensity
# also calculate r-square of the fitting
plt.subplot(122)
oldret_ints_model = evi_alt(oldranges, oldrefls)
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', linestyle='None',
         label='all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')

ret_ints_model = evi_alt(ranges, refls)
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', linestyle='None',
         label='$R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')
plt.axis('equal')
plt.xlabel('measured return intensity')
plt.ylabel('modeled return intensity')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('Scatter plot between measured and modeled')
plt.savefig('Scatter_plot_modeled_return_intensity_evi_2_nsf_20140812_'+str(wavelength)+'.png')

fig5 = plt.figure(figsize=(18, 9), dpi=96)
# plot calibration estimate results for each panel separately
plt.subplot(121)
xlim_plt = (0, 70)
ylim_plt = (0, 600)
colorstr = ['red', 'green', 'blue']
for p in range(0, numpanels):
  range_samples = np.array(np.array(range(1000))*0.075)
  refl_samples = np.ones(len(range_samples))*panelrefl[p]
  # # get the data points of this panel
  # tmpflag = data.x1 == panelrefl[p]
  # # sort the ranges
  # tmpind = np.argsort(data.x0[tmpflag])
  # # plot calibration data points
  # plt.errorbar(data.x0[tmpflag][tmpind], data.y[tmpflag][tmpind],
  #              yerr=data.get_yerr()[tmpflag][tmpind], color=colorstr[p],
  #              label="Measured")  

  # get the data points of this panel
  tmpflag = oldpanelind == p
  # sort the ranges
  tmpind = np.argsort(oldranges[tmpflag])
  # plot calibration data points against range
  plt.errorbar(oldranges[tmpflag][tmpind], oldret_ints[tmpflag][tmpind],
             yerr=oldret_ints_sd[tmpflag][tmpind], color=colorstr[p],
             label="Measured")   

  # plot modeled power against range
  dwel_alt_power_samples = dwel_alt(range_samples, refl_samples)
  plt.plot(range_samples, dwel_alt_power_samples, linestyle='--', lw=1,
           alpha=0.8, color=colorstr[p], label="DWEL five param fit w/ b, w/ bg const")
  
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU after preprocessing and laser power variation correction",fontsize=10)
plt.title('Ewan_b DWEL model, $P_r ='
'\\frac{C_0*\\rho}{r^b}*(1-\\exp(-\\frac{(C_2*r)^2}{(C_1+r)^2}))$, NSF 20140812, '+str(wavelength)+' nm')
# scatter plot between modeled return intensity and measured intensity
# also calculate r-square of the fitting
plt.subplot(122)
oldret_ints_model = dwel_alt(oldranges, oldrefls)
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', linestyle='None',
         label='all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')

ret_ints_model = dwel_alt(ranges, refls)
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', linestyle='None',
         label='$R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')
plt.axis('equal')
plt.xlabel('measured return intensity')
plt.ylabel('modeled return intensity')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('Scatter plot between measured and modeled')
plt.savefig('Scatter_plot_modeled_return_intensity_dwel_b_nsf_20140812_'+str(wavelength)+'.png')

fig = plt.figure(figsize=(18, 9), dpi=96)
# plot calibration estimate results for each panel separately
plt.subplot(121)
xlim_plt = (0, 70)
ylim_plt = (0, 600)
colorstr = ['red', 'green', 'blue']
for p in range(0, numpanels):
  range_samples = np.array(np.array(range(1000))*0.075)
  refl_samples = np.ones(len(range_samples))*panelrefl[p]
  # # get the data points of this panel
  # tmpflag = data.x1 == panelrefl[p]
  # # sort the ranges
  # tmpind = np.argsort(data.x0[tmpflag])
  # # plot calibration data points
  # plt.errorbar(data.x0[tmpflag][tmpind], data.y[tmpflag][tmpind],
  #              yerr=data.get_yerr()[tmpflag][tmpind], color=colorstr[p],
  #              label="Measured")  

  # get the data points of this panel
  tmpflag = oldpanelind == p
  # sort the ranges
  tmpind = np.argsort(oldranges[tmpflag])
  # plot calibration data points against range
  plt.errorbar(oldranges[tmpflag][tmpind], oldret_ints[tmpflag][tmpind],
             yerr=oldret_ints_sd[tmpflag][tmpind], color=colorstr[p],
             label="Measured")   

  # plot modeled power against range
  dwel_gm_power_samples = dwel_gm(range_samples, refl_samples)
  plt.plot(range_samples, dwel_gm_power_samples, linestyle='--', lw=1,
           alpha=0.8, color=colorstr[p], label="DWEL from growth modelling SIX param fit w/ b, w/o bg const")  
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU after preprocessing and laser power variation correction",fontsize=10)
plt.title('David_GM model, $P_r = \\frac{C_0*\\rho}{r^b}*\\frac{1}{(1+C_1*\\exp(-C_2*(r+C_3)))^C_4}$, NSF 20140812, '+str(wavelength)+' nm')
plt.savefig('calibration_fitting_with_std_error_dwel_gm_nsf_20140812_'+str(wavelength)+'.png')
# scatter plot between modeled return intensity and measured intensity
# also calculate r-square of the fitting
plt.subplot(122)
oldret_ints_model = dwel_gm(oldranges, oldrefls)
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', linestyle='None',
         label='all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')

ret_ints_model = dwel_gm(ranges, refls)
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', linestyle='None',
         label='$R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red',
         label='one-to-one line')
plt.axis('equal')
plt.xlabel('measured return intensity')
plt.ylabel('modeled return intensity')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('Scatter plot between measured and modeled')
plt.savefig('Scatter_plot_modeled_return_intensity_dwel_gm_nsf_20140812_'+str(wavelength)+'.png')

# fit specifically to K_d model
kd = ret_ints * ranges**b0/(c0*refls)
# create k_d model
print("start fitting to DWEL K_d model ...")
dwel_kd = DWEL_KD('DWEL_K_d')
evi_kd = EVI_KD('EVI_K_d')
dwel_kd_gm = DWEL_KD_GM('DWEL_K_d_GM')

# import pdb; pdb.set_trace();

data = Data1D('NSF20140812', ranges, kd)
f_dwel_kd = Fit(data, dwel_kd, stat=Chi2DataVar(), method=MonCar())
f_evi_kd = Fit(data, evi_kd, stat=Chi2DataVar(), method=MonCar())
# if wavelength == 1064:
#   data = Data1D('NSF20140812', np.concatenate([ranges, np.array([0])]),
#                 np.concatenate([kd, np.array([0.0014827519])]))
f_dwel_kd_gm = Fit(data, dwel_kd_gm, stat=Chi2DataVar(), method=MonCar())
# get the fitting results
dwel_kd_fit = f_dwel_kd.fit()
evi_kd_fit = f_evi_kd.fit()
dwel_kd_gm_fit = f_dwel_kd_gm.fit()
print(dwel_kd_fit.format())
print(evi_kd_fit.format())
print(dwel_kd_gm_fit.format())
outputfile.close()
outputfile =  open(outputfilename, 'a')
outputfile.write('\n')
outputfile.write('K_d separate fit\n')
outputfile.write('Ewan kd\n')
outputfile.write(dwel_kd_fit.format())
outputfile.write('\n')
outputfile.write('EVI kd\n')
outputfile.write(evi_kd_fit.format())
outputfile.write('\n')
outputfile.write('David GM kd\n')
outputfile.write(dwel_kd_gm_fit.format())
outputfile.write('\n')
# calculate r-square of kd fit
kd_model = dwel_kd(ranges)
s_tot = np.sum((kd-np.mean(kd))**2)
s_res = np.sum((kd-kd_model)**2)
dwel_kd_rsq = 1-s_res/s_tot
kd_model = evi_kd(ranges)
s_tot = np.sum((kd-np.mean(kd))**2)
s_res = np.sum((kd-kd_model)**2)
evi_kd_rsq = 1-s_res/s_tot
kd_model = dwel_kd_gm(ranges)
s_tot = np.sum((kd-np.mean(kd))**2)
s_res = np.sum((kd-kd_model)**2)
dwel_kd_gm_rsq = 1-s_res/s_tot
# plot k_d results
rg_samples = np.arange(0, np.max(ranges), 0.1)
kd_model = dwel_kd(rg_samples)
evi_kd_model = evi_kd(rg_samples)
dwel_kd_gm_model = dwel_kd_gm(rg_samples)
plt.figure(figsize=(10, 8), dpi=96)
plt.plot(ranges, kd, linestyle='None', marker='o', label="kd values from log fitting to far range data")
plt.plot(rg_samples, kd_model, linestyle='--', color='red', label="Ewan kd model"+"$R^2=$"+str(dwel_kd_rsq))
plt.plot(rg_samples, evi_kd_model, linestyle='-', color='green', label="EVI empirical kd model"+"$R^2=$"+str(evi_kd_rsq))
plt.plot(rg_samples, dwel_kd_gm_model, linestyle=':', color='blue',
         label="David kd model from growth modelling"+"$R^2=$"+str(dwel_kd_gm_rsq))
plt.plot([0, np.max(rg_samples)], [1, 1], '--k')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('DWEL K_d separate fit, NSF 20140812, '+str(wavelength)+' nm')
plt.savefig('dwel_Kd_nsf_20140812_'+str(wavelength)+'.png')

# plot modeled return intensity results
fig6 = plt.figure(figsize=(18, 9), dpi=96)
# plot calibration estimate results for each panel separately
plt.subplot(121)
xlim_plt = (0, 70)
ylim_plt = (0, 600)
colorstr = ['red', 'green', 'blue']
pnamestr = ['lambertian', 'gray 1', 'gray 2']
for p in range(0, numpanels):
  range_samples = np.array(np.array(range(1000))*0.075)
  refl_samples = np.ones(len(range_samples))*panelrefl[p]
  # get the data points of this panel
  tmpflag = oldpanelind == p
#  import pdb; pdb.set_trace()
  # sort the ranges
  tmpind = np.argsort(oldranges[tmpflag])
  # plot calibration data points against range
  plt.errorbar(oldranges[tmpflag][tmpind], oldret_ints[tmpflag][tmpind],
             yerr=oldret_ints_sd[tmpflag][tmpind], color=colorstr[p],
             label="Measured")   
  # plot modeled power against range
  kd_samples = dwel_kd(range_samples)
  evi_kd_samples = evi_kd(range_samples)
  dwel_kd_gm_samples = dwel_kd_gm(range_samples)
  dwel_power_samples = c0*refl_samples*kd_samples/range_samples**b0
  dwel_power_samples_evi = c0*refl_samples*evi_kd_samples/range_samples**b0
  dwel_power_samples_gm = c0*refl_samples*dwel_kd_gm_samples/range_samples**b0
  plt.plot(range_samples, dwel_power_samples, linestyle='--', lw=1,
           alpha=0.8, color=colorstr[p], label=pnamestr[p]+", Ewan K_d separate fit")
  plt.plot(range_samples, dwel_power_samples_evi, linestyle='-', lw=1,
           color=colorstr[p], label=pnamestr[p]+", EVI empirical k_d separate fit")
  plt.plot(range_samples, dwel_power_samples_gm, linestyle=':', lw=1,
           color=colorstr[p], label=pnamestr[p]+", David GM  k_d separate fit")
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU after preprocessing and laser power variation correction",fontsize=10)
plt.title('DWEL Calibration model, K_d separate fit, NSF 20140812, '+str(wavelength)+' nm')
plt.savefig('calibration_fitting_dwel_kd_sep_fit_nsf_20140812_'+str(wavelength)+'.png')
# scatter plot between modeled return intensity and measured intensity
# also calculate r-square of the fitting
plt.subplot(122)
oldret_ints_model = c0*oldrefls*dwel_kd(oldranges)/oldranges**b0
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', color='red', linestyle='None',
         label='Ewan_b, all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red')

ret_ints_model = c0*refls*dwel_kd(ranges)/ranges**b0
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
dwel_kd_power_rsq = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', color='red', linestyle='None',
         label='Ewan_b DWEL model, $R^2=$'+str(dwel_kd_power_rsq))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='black')

oldret_ints_model = c0*oldrefls*dwel_kd_gm(oldranges)/oldranges**b0
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', color='blue', linestyle='None',
         label='David_GM, all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red')

ret_ints_model = c0*refls*dwel_kd_gm(ranges)/ranges**b0
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
dwel_kd_gm_power_rsq = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', color='blue', linestyle='None',
         label='David_GM DWEL growth modelling, $R^2=$'+str(dwel_kd_gm_power_rsq))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='black')

oldret_ints_model = c0*oldrefls*evi_kd(oldranges)/oldranges**b0
s_tot = np.sum((oldret_ints - np.mean(oldret_ints))**2)
s_res = np.sum((oldret_ints_model-oldret_ints)**2)
r_square = 1 - s_res/s_tot
plt.plot(oldret_ints, oldret_ints_model, marker='x', color='green', linestyle='None',
         label='EVI_b, all ranges including within 6 m, $R^2=$'+str(r_square))
tmpmin = np.min(np.concatenate([oldret_ints, oldret_ints_model]))
tmpmax = np.max(np.concatenate([oldret_ints, oldret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='red')

ret_ints_model = c0*refls*evi_kd(ranges)/ranges**b0
s_tot = np.sum((ret_ints - np.mean(ret_ints))**2)
s_res = np.sum((ret_ints_model-ret_ints)**2)
evi_kd_power_rsq = 1 - s_res/s_tot
plt.plot(ret_ints, ret_ints_model, marker='o', color='green', linestyle='None',
         label='EVI_b model, $R^2=$'+str(evi_kd_power_rsq))
tmpmin = np.min(np.concatenate([ret_ints, ret_ints_model]))
tmpmax = np.max(np.concatenate([ret_ints, ret_ints_model]))
plt.plot([tmpmin, tmpmax], [tmpmin, tmpmax], linestyle='-', color='black')

plt.axis('equal')
plt.xlabel('measured return intensity')
plt.ylabel('modeled return intensity')
plt.legend(prop={'size':8}, loc='lower right')
plt.title('Scatter plot between measured and modeled')
plt.savefig('Scatter_plot_modeled_return_intensity_dwel_kd_sep_fit_nsf_20140812_'+str(wavelength)+'.png')

plt.show(block=False)
outputfile.close()

import pdb; pdb.set_trace()


