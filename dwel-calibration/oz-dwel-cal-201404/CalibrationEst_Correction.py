"""
# CalibrationEst.py
# zhanli86@bu.edu
#
# Purpose: estimate the calibration constand and telescope efficiency parameters
# in a given model with Monte Carlo method along with Differential Evolutionary optimization. 
# The optimization is from Sherpa module from Harvard University. 
# Input data points: range, return intensity and target reflectance.
# Two models are used here: 1) EVI model with its own telescope efficiency model;
# 2) DWEL model with the telescope efficiency model from Ewan Douglas. 
"""


import sys
import os
from math import exp
import numpy as np # numpy package
import csv # csv package to read csv file of calibration data
import matplotlib
import matplotlib.pyplot as plt # module to plot data
import h5py # hdf5 module to read hdf5 file of Ewan's range test data
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

###############################################################################################
# the HDF5 File to be analyzed, also need the matching encoder value, 
#this script be made into a function or called with commandline argumenta
hdf5file = h5py.File("/projectnb/echidna/lidar/Data_DWEL_TestCal/RangeTest_Ewan_Nov_2013/November27_lambertianRanges_InstStationary3.bin.hdf5", 'r+')

#assuming the file is good, get the important variables:
waveforms = hdf5file.get("1064 Waveform Data")

times = hdf5file.get("Time")
numel =times.shape[0] #the number of waveforms in file
#times = times[::20]
#waveforms = waveforms[::20]
waveform_stats=hdf5file.require_dataset("Waveform Statistics 1548",
                                        ((waveforms.shape[0]),4),
                                        exact=True,dtype='f8') #max,where(max),sum,time

time_array = times  #np.array([np.array(times[i][0] + 1.0e-9*times[i][1]) for i in range(numel)])
enc_interp=hdf5file.get("Interpolated Az,El")

#find waveform max and its index
def maxwhere(waveform):
	max_val=np.max(waveform[359:-1])
	max_ind=np.where(waveform==max_val)
	return max_val,int(max_ind[0][0])

#find waveform max and its index, working on multiple waveforms (for better picloud I/O)
def maxwhere_chunked(waveform_chunk,nwaves):
	stats=np.zeros([nwaves,2])
#	print(np.shape(waveform_chunk))
	for i in range(nwaves):
	#	print(i)
		waveform=waveform_chunk[i]
		max_val=np.max(waveform[339:-1])
		max_ind=np.where(waveform==max_val)
		stats[i,0:2]=[max_val,int(max_ind[0][0])]
	return stats

#if HDF5 file doesn't have waveform stats yet:
if (waveform_stats[0,1]==0) and (waveform_stats[0,2]==0):	
          print("Using local processor")
          start_range=250
          end_range=1600
          waveform_stats[:,0] = np.array([waveforms[i][start_range:end_range].max() for i in range(numel)])
          rangearray=np.zeros([numel])
          for i, maximum in enumerate(waveform_stats[:,0]):
                  therange=(np.array(np.where(waveforms[i][start_range:end_range] == maximum))+start_range)
                  #plt.plot(i,therange[0,0],'x')
                  #rangearray[i] = (therange[0,0]-360.583/2)*0.3
                  waveform_stats[i,1]= therange[0,0]
			
fig1 = plt.figure(figsize=(7.5, 10), dpi=96)
fig1.add_subplot(311)
plt.plot(waveform_stats[:300000,1])
plt.ylim([300,700])

slices=[[25000,35000],
        [50000,68000],
        [80000,110000],
        [120000,150000],
        [160000,170000],
        [185000,195000],
        [205000,210000],
        [220000,228000],
        [236000,245000],
        [256000,265000],
        [276000,285000],]

avgrange=[]
avgmax=[]
stdrange=[]
stdmax=[]
# meter_per_bin=1.0/3.0/2./2. # where is this meter per bin from?
meter_per_bin=3.e8/2.e9/2.
for aslice in slices:
    plt.plot(aslice[0]*np.ones(600),np.arange(600),'-.')
    plt.plot(aslice[1]*np.ones(600),np.arange(600),'--')
    avgrange.append(np.mean(waveform_stats[aslice[0]:aslice[1],1])*meter_per_bin)
    stdrange.append(np.std(waveform_stats[aslice[0]:aslice[1],1])*meter_per_bin)
    avgmax.append(np.mean(waveform_stats[aslice[0]:aslice[1],0]))
    stdmax.append(np.std(waveform_stats[aslice[0]:aslice[1],0]))
    
plt.xlabel("Shot Number")
plt.ylabel("Range in bins")
fig1.add_subplot(312)
plt.plot(waveform_stats[:300000,0])
plt.xlabel("Shot Number")
plt.ylabel("Waveform max ADU")
fig1.add_subplot(313)
plt.errorbar(np.array(avgrange)-np.min(avgrange),avgmax,xerr=np.array(stdrange),yerr=stdmax)
plt.title("max intensity std error:"+str(round(np.max(stdmax),2))
      +'[ADU], max range std error:'+str(round(np.max(stdrange),2))+" [bins]",size=6)
plt.xlabel("Meters")
plt.ylabel("Power")
plt.xlim([0,30])
#tight_layout()
plt.savefig('1548_nov27_test3.png')
plt.close(fig1)
###############################################################################################


# define EVI model.
class EVI_FUN(ArithmeticModel): 
# class EVI_FUN is inheritated from a sherpa model 'ArithmeticModel'
# this is a user-defined model that sherpa's fitting function can take
  def __init__(self, name='simple_overfilling'):
       self.amplitude = Parameter(name, 'amplitude', 1e3, min=0) # p[0], calibration constant
       self.b = Parameter(name, 'b', 2, min=0, max=3) # p[1], range factor
       self.Ck = Parameter(name,'Ck',1, min=0) # p[2], telescope efficiency parameter
       self.Cb = Parameter(name, 'Cb', 1) # p[3], background noise
       ArithmeticModel.__init__(self, name, (self.amplitude, self.b, self.Ck, self.Cb))
       
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs): 
    # the definition of the function 'calc' here follows the fashion of the class 'sherpa.models.Model'.
    # In this way, this user-defined function can be taken by sherpa's fitting function. 
    # x0, x1, two ndarry of domain values (according to http://pysherpa.blogspot.com/2010/11/user-defined-model-and-fit-statistic.html).
    # EVI model has two variables: range given by x0 and reflectance given by x1.
    #print x0
    #print x1
    #print p
    ret_power=(p[0]*x1/x0**p[1])*(1-np.array(map(exp,-x0**2/p[2]))) + p[3]
    #print ret_power
    return ret_power

# define an alternate EVI model with range factor fixed at 2. 
class EVI_FUN_alt(ArithmeticModel): 
# class EVI_FUN is inheritated from a sherpa model 'ArithmeticModel'
# this is a user-defined model that sherpa's fitting function can take
  def __init__(self, name='simple_overfilling'):
       self.amplitude = Parameter(name, 'amplitude', 1e3, min=0) # p[0], calibration constant
       self.Ck = Parameter(name,'Ck', 1, min=0) # p[1], telescope efficiency parameter
       # self.b = Parameter(name, 'b', 2, min=1, max=3) # p[2], range factor
       self.Cb = Parameter(name, 'Cb', 1) # background noise
       ArithmeticModel.__init__(self, name, (self.amplitude, self.Ck, self.Cb))
       
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs): 
    # the definition of the function 'calc' here follows the fashion of the class 'sherpa.models.Model'.
    # In this way, this user-defined function can be taken by sherpa's fitting function. 
    # x0, x1, two ndarry of domain values (according to http://pysherpa.blogspot.com/2010/11/user-defined-model-and-fit-statistic.html).
    # EVI model has two variables: range given by x0 and reflectance given by x1.
#    x1=1 # x1 is reflectance, now it's fixed at 1 from Lambertian panel. 
    ret_power=(p[0]*x1/x0**2)*(1-np.array(map(exp,-x0**2/p[1]))) + p[2]
    return ret_power

# define a DWEL model
class DWEL_FUN(ArithmeticModel):
  def __init__(self, name='simple_overfilling'):
	  self.C0 = Parameter(name, 'C0', 1e3, min=0)
	  self.C1 = Parameter(name, 'C1', 1, min=1)
	  self.C2 = Parameter(name, 'C2', 1, min=0)
	  self.C3 = Parameter(name, 'C3', 1)
	  ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2, self.C3))
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs):
	  ret_power =(p[0]*x1/x0**2)*(1.-np.exp(-(p[2]*x0)**2/((p[1]+x0)**2))) + p[3]
	  return ret_power

class DWEL_FUN_alt(ArithmeticModel):
# alternate DWEL model include an extra parameter of range factor
  def __init__(self, name='simple_overfilling'):
	  self.C0 = Parameter(name, 'C0', 1e3, min=0)
	  self.C1 = Parameter(name, 'C1', 1, min=1)
	  self.C2 = Parameter(name, 'C2', 1, min=0)
	  self.C3 = Parameter(name, 'C3', 1)
	  self.b = Parameter(name, 'b', 2, min=0, max=3)
	  ArithmeticModel.__init__(self, name, (self.C0, self.C1, self.C2, self.C3, self.b))
  def calc(self, p, x0, x1, xhi=None, *args, **kwargs):
	  ret_power =(p[0]*x1/x0**p[4])*(1.-np.exp(-(p[2]*x0)**2/((p[1]+x0)**2))) + p[3]
	  return ret_power

##############################################################################
# read calibration data from csv file
CalFileName1548 = '/usr3/graduate/zhanli86/Programs/dwel-calibration/oz-dwel-cal-201404/DWEL_Calibration_ESP_1548.csv' # file name of the calibrationd data at 1548 nm. 
caldata1548 = []
with open(CalFileName1548, 'rb') as calfile1548:
  calreader = csv.reader(calfile1548)
  next(calreader)
  next(calreader)
  for row in calreader:
    caldata1548.append(map(float, row))
caldata1548 = np.array(caldata1548) # first col: range, second col: return power in DN, third col: reflectance
##############################################################################

# create an EVI model
print("start fitting to evi model ...")
evi = EVI_FUN('EVI')
print("start fitting to alternate evi model ...")
evi_alt = EVI_FUN_alt('EVI_alt')
print("start fitting to dwel model ...")
dwel = DWEL_FUN('DWEL')
print("start fitting to alternate dwel model")
dwel_alt = DWEL_FUN_alt('DWEL_alt')

# output results to an ASCII file
outputfilename = 'CalibrationEst_Correction_Output.txt'
outputfile =  open(outputfilename, 'w')

######################################################################################################
# Do the fitting from Ewan's range test, non-scanning mode.
ranges=np.array(avgrange)-np.min(avgrange)
power=np.array(avgmax)
dpower=np.array(stdmax)+0.1

import pdb; pdb.set_trace()

# fit with std error of dependent variable, return power
data = Data2D('Ewan', ranges[:-2], np.ones(len(ranges[:-2])), power[:-2], staterror=dpower[:-2])
# fit without std error of dependent variable makes no difference here. no results are output or plot here. 
# data = Data2D('Ewan',ranges[:-2], np.ones(len(ranges[:-2])), power[:-2]) 
f_evi = Fit(data, evi, stat=Chi2DataVar(), method=MonCar())
f_evi_alt = Fit(data, evi_alt, stat=Chi2DataVar(), method=MonCar())
f_dwel = Fit(data, dwel, stat=Chi2DataVar(), method=MonCar())
f_dwel_alt = Fit(data, dwel_alt, stat=Chi2DataVar(), method=MonCar())
# get the fitting results
evi_fit = f_evi.fit()
evi_alt_fit = f_evi_alt.fit()
dwel_fit = f_dwel.fit()
dwel_alt_fit = f_dwel_alt.fit()
print("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), Ewan's range test data:")
print evi_fit.format()
print("Fitting to alternate EVI model, three parameters (C_0, C_k, C_b), Ewan's range test data:")
print evi_alt_fit.format()
print("Fitting to DWEL model, four parameters (C_0, C_1, C_2, C_3), Ewan's range test data:")
print dwel_fit.format()
print("Fitting to alternate DWEL model, five parameters (C_0, C_1, C_2, C_3, b), Ewan's range test data:")
print dwel_alt_fit.format()
# write results to output file
outputfile.write("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), Ewan's range test data:\n")
outputfile.write(evi_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to alternate EVI model, three parameters (C_0, C_k, C_b), Ewan's range test data:\n")
outputfile.write(evi_alt_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to DWEL model, four parameters (C_0, C_1, C_2_C_3), Ewan's range test data:\n")
outputfile.write(dwel_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to alternate DWEL model, five parameters (C_0, C_1, C_2, C_3, b), Ewan's range test data:\n")
outputfile.write(dwel_alt_fit.format())
outputfile.write("\n")

####################################################################################################
# range_samples = np.array(np.array(range(int(round((max(data.x0)-min(data.x0))/0.075))))*0.075+min(data.x0))
# refl_samples = np.ones(len(range_samples))
range_samples = np.array(np.array(range(800))*0.075)
refl_samples = np.ones(len(range_samples))
# plot fitting results
xlim_plt = (0, 20)
ylim_plt = (500, 2500)
fig2 = plt.figure(figsize=(10, 7.5), dpi=96)
#fig2.add_subplot(221)
# plot calibration data points
plt.errorbar(data.x0, data.y, yerr=data.get_yerr(), label="Measured")
# plot modeled power against range
evi_power_samples = evi(range_samples, refl_samples)
evi_alt_power_samples = evi_alt(range_samples, refl_samples)
dwel_power_samples = dwel(range_samples, refl_samples)
dwel_alt_power_samples = dwel_alt(range_samples, refl_samples)
# plt.plot(range_samples, evi_power_samples, linestyle='-', lw=1, alpha=0.8, color='g',label="EVI four param fit w/ b, w/ bg const")
# plt.plot(range_samples, evi_alt_power_samples, linestyle=':', lw=1, alpha=0.8, color='g',label="EVI three param fit w/ bg const")
plt.plot(range_samples, dwel_power_samples, linestyle=':', lw=1, alpha=0.8, color='r', label="DWEL four param fit w/ bg const")
# plt.plot(range_samples, dwel_alt_power_samples, linestyle='-', lw=1, alpha=0.8, color='r', label="DWEL five param fit w/ b, w/ bg const")
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU",fontsize=10)
'''
# plot slope of power-range curve
fig2.add_subplot(223)
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<35)
slope_samples = (evi_power_samples[1:]-evi_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, EVI three param fit w/b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='g', label="EVI three param fit w/ b")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<35)
slope_samples = (evi_alt_power_samples[1:]-evi_alt_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, EVI two param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='g', label="EVI two param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_power_samples[1:]-dwel_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, DWEL three param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL three param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_alt_power_samples[1:]-dwel_alt_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, DWEL four param fit w/b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL four param fit w/ b")
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("power changing slope",fontsize=10)
# plot telescope efficiency
range_samples = np.array(np.array(range(800))*0.075)
refl_samples = np.ones(len(range_samples))
fig2.add_subplot(222)
evi_te_samples = 1-np.array(map(exp, -1*range_samples**2/evi.Ck.val))
evi_alt_te_samples = 1-np.array(map(exp, -1*range_samples**2/evi_alt.Ck.val))
dwel_te_samples = (1.-np.exp(-1*(dwel.C2.val*range_samples/(dwel.C1.val+range_samples))**2))
dwel_alt_te_samples = (1.-np.exp(-1*(dwel.C2.val*range_samples/(dwel.C1.val+range_samples))**2))
plt.plot(range_samples, evi_te_samples, linestyle='-', lw=1, alpha=0.6, color='g', label="EVI three param fit")
plt.plot(range_samples, evi_alt_te_samples, linestyle=':', lw=1, alpha=0.6, color='g', label="EVI two param fit")
plt.plot(range_samples, dwel_te_samples, \
		 linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL three param fit")
plt.plot(range_samples, dwel_alt_te_samples, \
		 linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL four param fit w/ b")
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("Telescope efficiency",fontsize=10)
# plot the slope of telescope efficiency v.s. range curve
fig2.add_subplot(224)
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<35)
slope_samples = (evi_te_samples[1:]-evi_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, EVI three param fit w/b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='g', label="EVI three param fit w/ b")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<35)
slope_samples = (evi_alt_te_samples[1:]-evi_alt_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, EVI two param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='g', label="EVI two param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_te_samples[1:]-dwel_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, DWEL three param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL three param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_alt_te_samples[1:]-dwel_alt_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, DWEL four param fit w/ b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL four param fit w/ b")
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("telescope efficiency changing slope",fontsize=10)
'''
plt.savefig('calibration_fitting_with_std_error_Ewan_Correction.png')
#plt.close(fig2)
plt.show()

######################################################################################################
outputfile.write("\n\nUsing ESP calibration scanning data:\n")
# do the fitting from ESP calibration scan
data = Data2D('ESP1548', caldata1548[:,0], caldata1548[:,2], caldata1548[:,1], staterror=None)
f_evi = Fit(data, evi, stat=Chi2DataVar(), method=MonCar())
f_evi_alt = Fit(data, evi_alt, stat=Chi2DataVar(), method=MonCar())
f_dwel = Fit(data, dwel, stat=Chi2DataVar(), method=MonCar())
f_dwel_alt = Fit(data, dwel_alt, stat=Chi2DataVar(), method=MonCar())
# get the fitting results
evi_fit = f_evi.fit()
evi_alt_fit = f_evi_alt.fit()
dwel_fit = f_dwel.fit()
dwel_alt_fit = f_dwel_alt.fit()
print("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), ESP panel scanning data:")
print evi_fit.format()
print("Fitting to alternate EVI model, three parameters (C_0, C_k, C_b), ESP panel scanning data:")
print evi_alt_fit.format()
print("Fitting to DWEL model, four parameters (C_0, C_1, C_2, C_3), ESP panel scanning data:")
print dwel_fit.format()
print("Fitting to alternate DWEL model, five parameters (C_0, C_1, C_2, C_3, b), ESP panel scanning data:")
print dwel_alt_fit.format()
# write results to output file
outputfile.write("Fitting to EVI model, four parameters (C_0, b, C_k, C_b), ESP panel scanning data:\n")
outputfile.write(evi_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to alternate EVI model, three parameters (C_0, C_k, C_b), ESP panel scanning data:\n")
outputfile.write(evi_alt_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to DWEL model, four parameters (C_0, C_1, C_2, C_3), ESP panel scanning data:\n")
outputfile.write(dwel_fit.format())
outputfile.write("\n")
outputfile.write("Fitting to alternate DWEL model, five parameters (C_0, C_1, C_2, C_3, b), ESP panel scanning data:\n")
outputfile.write(dwel_alt_fit.format())
outputfile.write("\n")

####################################################################################################
# range_samples = np.array(np.array(range(int(round((max(data.x0)-min(data.x0))/0.075))))*0.075+min(data.x0))
# refl_samples = np.ones(len(range_samples))
range_samples = np.array(np.array(range(800))*0.075)
refl_samples = np.ones(len(range_samples))
# plot fitting results
xlim_plt = (0, 20)
ylim_plt = (0, 5000)
fig2 = plt.figure(figsize=(10, 7.5), dpi=96)
# fig2.add_subplot(221)
# plot calibration data points
plt.errorbar(data.x0, data.y/data.x1, yerr=data.get_yerr(), marker='o', linestyle='None', label="Measured")
# plot modeled power against range
evi_power_samples = evi(range_samples, refl_samples)
evi_alt_power_samples = evi_alt(range_samples, refl_samples)
dwel_power_samples = dwel(range_samples, refl_samples)
dwel_alt_power_samples = dwel_alt(range_samples, refl_samples)
plt.plot(range_samples, evi_power_samples, linestyle='-', lw=1, alpha=0.6, color='g',label="EVI four param fit w/ b, w/ bg const")
plt.plot(range_samples, evi_alt_power_samples, linestyle=':', lw=1, alpha=0.6, color='g',label="EVI three param fit w/ bg const")
plt.plot(range_samples, dwel_power_samples, linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL four param fit, w/ bg const")
plt.plot(range_samples, dwel_alt_power_samples, linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL five param fit w/ b, w/ bg const")
plt.xlim(xlim_plt)
plt.ylim(ylim_plt)
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("ADU",fontsize=10)
'''
# plot slope of power-range curve
fig2.add_subplot(223)
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (evi_power_samples[1:]-evi_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, EVI three param fit w/b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='g', label="EVI three param fit w/ b")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (evi_alt_power_samples[1:]-evi_alt_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, EVI two param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='g', label="EVI two param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_power_samples[1:]-dwel_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, DWEL three param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL three param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_alt_power_samples[1:]-dwel_alt_power_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of power v.s. range, DWEL four param fit w/b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL four param fit w/ b")
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("power changing slope",fontsize=10)
# plot telescope efficiency
range_samples = np.array(np.array(range(800))*0.075)
refl_samples = np.ones(len(range_samples))
fig2.add_subplot(222)
evi_te_samples = 1-np.array(map(exp, -1*range_samples**2/evi.Ck.val))
evi_alt_te_samples = 1-np.array(map(exp, -1*range_samples**2/evi_alt.Ck.val))
dwel_te_samples = (1.-np.exp(-1*(dwel.C2.val*range_samples/(dwel.C1.val+range_samples))**2))
dwel_alt_te_samples = (1.-np.exp(-1*(dwel.C2.val*range_samples/(dwel.C1.val+range_samples))**2))
plt.plot(range_samples, evi_te_samples, linestyle='-', lw=1, alpha=0.6, color='g', label="EVI three param fit")
plt.plot(range_samples, evi_alt_te_samples, linestyle=':', lw=1, alpha=0.6, color='g', label="EVI two param fit")
plt.plot(range_samples, dwel_te_samples, \
		 linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL three param fit")
plt.plot(range_samples, dwel_alt_te_samples, \
		 linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL four param fit w/ b")
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("Telescope efficiency",fontsize=10)
# plot the slope of telescope efficiency v.s. range curve
fig2.add_subplot(224)
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (evi_te_samples[1:]-evi_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, EVI three param fit w/b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='g', label="EVI three param fit w/ b")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (evi_alt_te_samples[1:]-evi_alt_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, EVI two param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='g', label="EVI two param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_te_samples[1:]-dwel_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, DWEL three param fit:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle=':', lw=1, alpha=0.6, color='r', label="DWEL three param fit")
condlist = np.logical_and(range_samples[0:-1]>1, range_samples[0:-1]<15)
slope_samples = (dwel_alt_te_samples[1:]-dwel_alt_te_samples[0:-1])/(range_samples[1:]-range_samples[0:-1])
outputfile.write("Slope of telescope efficiency v.s. range, DWEL four param fit w/ b:\n")
#outputfile.write("Mean = "+np.mean(np.select(condlist, slope_samples))+", std = "+np.std(np.select(condlist, slope_samples)))
plt.plot(range_samples[0:-1], slope_samples, linestyle='-', lw=1, alpha=0.6, color='r', label="DWEL four param fit w/ b")
plt.legend(prop={'size':8})
plt.xlabel("Range",fontsize=10)
plt.ylabel("telescope efficiency changing slope",fontsize=10)
'''
plt.savefig('calibration_fitting_wo_std_error_ESP_Correction.png')
#plt.close(fig2)
plt.show()

outputfile.close()
