# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

'''
find_maxes.py
DWEL project.
douglase@bu.edu.
Jan. 2013.
v0.1

Purpose:
a branch of the first field campaigns combine.py
code which finds the maximum value of waveforms in a HDF5 file,
displays a preview image in DS9,
and saves a fits format 2-D image for future display.
'''
import time
import sys
import os
import numpy as np
import h5py
import matplotlib.pyplot as plt
from scipy.interpolate import griddata
#from mpl_toolkits.basemap import Basemap
import pyfits
import cloud #picloud Cloud Computing package
import scipy.stats
import scipy.ndimage

# <codecell>

# the HDF5 File to be analyzed, also need the matching encoder value, 
#this script be made into a function or called with commandline argumenta
hdf5file = h5py.File("/Users/edouglas/Downloads/November27_lambertian4_not_niced.hdf5",'r+')


#cloudkey=open('picloudkey.txt').readline() #this is user specific picloud key.
#cloud.setkey(4665,cloudkey)

localbit=1 #if True then don't use picloud and run locally

#assuming the file is good, get the important variables:
waveforms = hdf5file.get("1064 Waveform Data")

times = hdf5file.get("Time")
#hdf5file.get("Packet Test Dataset")[...].shape
numel =times.shape[0]/2+1 #the number of waveforms in file
#times = times[::20]
#waveforms = waveforms[::20]
waveform_stats=hdf5file.require_dataset("Waveform Statistics",
                                        ((waveforms.shape[0]),4),
                                        exact=True,dtype='f8') #max,where(max),sum,time
deltat1=times[1:times.shape[0]]-times[0:times.shape[0]-1]
plt.hist(deltat1,bins=100,range=(0.0004,0.0008))
print(deltat1[0])
hdf5file.close()

# <codecell>


# <codecell>


# the HDF5 File to be analyzed, also need the matching encoder value, this script be made into a function or called with commandline argumenta
hdf5fileranges = h5py.File("/Users/edouglas/Downloads/November27_lambertianRanges_InstStationary3.bin.hdf5",'r+')

#cloudkey=open('picloudkey.txt').readline() #this is user specific picloud key.
#cloud.setkey(4665,cloudkey)

localbit=1 #if True then don't use picloud and run locally

#assuming the file is good, get the important variables:
waveforms = hdf5fileranges.get("1064 Waveform Data")

times = hdf5fileranges.get("Time")
#hdf5file.get("Packet Test Dataset")[...].shape
numel =times.shape[0]/2+1 #the number of waveforms in file
#times = times[::20]
#waveforms = waveforms[::20]
waveform_stats=hdf5fileranges.require_dataset("Waveform Statistics",((waveforms.shape[0]),4),exact=True,dtype='f8') #max,where(max),sum,time
deltat=times[1:times.shape[0]]-times[0:times.shape[0]-1]
plt.hist(deltat,bins=75,range=(0.00050,0.0008),label='nice -20')
#plt.hist(deltat1,bins=75,range=(0.00050,0.0008),alpha=0.25,label='usual ./read call')
plt.legend()
print(deltat[0])
hdf5fileranges.close()

# <codecell>

hdf5fileranges.items

# <codecell>


# the HDF5 File to be analyzed, also need the matching encoder value, 
#this script be made into a function or called with commandline argumenta
hdf5file = h5py.File("/Users/edouglas/Downloads/November27_lambertianRanges_InstStationary3.bin.hdf5",'r+')


#cloudkey=open('picloudkey.txt').readline() #this is user specific picloud key.
#cloud.setkey(4665,cloudkey)

#assuming the file is good, get the important variables:
waveforms = hdf5file.get("1548 Waveform Data")

times = hdf5file.get("Time")
#hdf5file.get("Packet Test Dataset")[...].shape
numel =times.shape[0] #the number of waveforms in file
#times = times[::20]
#waveforms = waveforms[::20]
waveform_stats=hdf5file.require_dataset("Waveform Statistics 1548",
                                        ((waveforms.shape[0]),4),
                                        exact=True,dtype='f8') #max,where(max),sum,time

time_array = times  #np.array([np.array(times[i][0] + 1.0e-9*times[i][1]) for i in range(numel)])
print('FIRST TIME STAMP in dataset: '+str(time_array[0])+'last time stamp:'+str(time_array[numel-1]))
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
	
	#assemble waveforms in xxx long chunks and send to picloud for processing
	if localbit==0:
		xxx=1000
		chunksize=xxx*np.ones(int(np.floor(numel/xxx)),dtype='i')
		ti=time.time()
		print('sending to cloud'+str(int(np.floor(numel/xxx)))
              +'chunks of'+str(chunksize)+' now. At: '+str(time.time()))
		nchunks=int(np.floor(numel/xxx))
		njobs=nchunks
		j=0
		jobs=cloud.map(maxwhere_chunked,
                       [waveforms[i*xxx+j*xxx:xxx+i*xxx+j*xxx] for i in range(nchunks)],chunksize)
		for i, z in enumerate(cloud.iresult(jobs)):
			waveform_stats[i*xxx+j*xxx:i*xxx+j*xxx+xxx,0:2]=z
		print("that took",time.time()-ti,"seconds")
		
	#otherwise do same thing locally:
	if localbit == 1:
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
			

# <codecell>

waveform_stats[:,1]

# <codecell>

subplot(311)

plot(waveform_stats[:300000,1])
ylim([300,700])
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
meter_per_bin=1.0/3.0/2./2.
for aslice in slices:
    #    print(aslice)
    plot(aslice[0]*ones(600),np.arange(600),'-.')
    plot(aslice[1]*ones(600),np.arange(600),'--')
    avgrange.append(np.mean(waveform_stats[aslice[0]:aslice[1],1])*meter_per_bin)
    stdrange.append(np.std(waveform_stats[aslice[0]:aslice[1],1])*meter_per_bin)
    avgmax.append(np.mean(waveform_stats[aslice[0]:aslice[1],0]))
    stdmax.append(np.std(waveform_stats[aslice[0]:aslice[1],0]))
    
xlabel("Shot Number")
ylabel("Range")
subplot(312)
plot(waveform_stats[:300000,0])
xlabel("Shot Number")
ylabel("AUD")
subplot(313)
plt.errorbar(np.array(avgrange)-np.min(avgrange),avgmax,xerr=np.array(stdrange),yerr=stdmax)
title("max intensity error:"+str(round(np.max(stdmax),2))
      +'[ADU], max range error:'+str(round(np.max(stdrange),2))+" [bins]",size=6)
xlabel("Meters")
ylabel("Power")
xlim([0,30])
tight_layout ()
savefig('1548_nov27_test3.png')

# <markdowncell>

# The instrument records the intensity of returns, which depend both on the target composition and the range. 
# The receiving telescope focal length, focus and photodetector size are fixed, such that at near ranges the beam overfills the detector, while in the far field, the field-of-view and beam divergence are constant and the return power falls off by the inverse square law.
# 
# For a flat target, much larger than the outgoing beam,  with albedo $A_t$, scattering an incident beam of power $P_0$ isotropically into $2\pi$, the power received at the telescope is
# 
# \begin{equation}
# P_{Rx}= A_t P_0  \frac{K(d)}{2\pi d^2}
# \end{equation}    
# 
#  $K(d)$ is a correction term to account for variations in telescope FOV with range which will be derived below.  Reflectivity and calibration are extraneous and combined into a single constant $P_0$. For simplicity we will neglect atmospheric attenuation. [REALLY? 1550...!]
# The first generation EVI instrument employed a correction to the range of the form, 
# 
# \begin{equation}
# K(d)=(1-\exp(\frac{-d^2}{k})) 
# \end{equation}  
# This function proved effective for correction of near field effects in EVI, however EVI has a large far-FOV of 10mrad. EVI employed an anodizing filter which generated a top-hat like beam profile in the near field and a complicated Fresnel diffraction pattern in the mid-field which becomes the classic Fraunhofer Airy function diffraction pattern in the far-field limit. Since the beam was significantly larger ( complicated effects occurred 
# 
# DWEL on employs the spatially robust Gaussian beam profile and has a telescope far-FOV, $\approx 5mrad$, that is closely matched to the outgoing profile widths (1-5mrad).
# The half angle field-of-view of the DWEL telescope is defined by the ratio of the photodiode radius, $R$, and the system focal length, $f_{sys}$. The outgoing beam profile is an axially-symmetric ($ M < 1.1 $) 2-D Gaussian function characterized by $\sigma=\sigma+d*\theta$ where $d$ is distance, or range, to the target and $\theta$ is the beam divergence. $\sigma_0$ is the initial beam diameter or waist in laser optics parlance.
# In polar coordinates the return power striking the detector is given by the definite integral of the two-dimensional Gaussian function:
# 
# \begin{equation}
# P_{Rx} =\frac{P_0 A_t}{ 2*\pi d^2} \int_0^{2\pi} \int_0^y e^{-(r^2(\cos^2\phi \sin^2\phi))/2\sigma^2} r dr d\phi 
# \end{equation}
# where y is the field-of-view at the range of interest, \(y=Rd/f_{sys}\).
# Integrating over all angles and to the edge of the detector field-of-view in terms of $y$ gives the dependence of the return power on range
# 
# \begin{equation}
# P_{Rx} =(\frac{P_0 A_t}{ 2*\pi d^2})(2\pi \sigma^2 )(1-\exp[{-\frac{y^2}{2\sigma^2}}])
# \end{equation}
# 
# \begin{equation}
# P_{Rx}=(\frac{P_0 A_t}{ 2*\pi d^2})( \sigma_0+d*\theta)^2 (1-\exp [{-\frac{(Rd/f_{sys})^2}{2(\sigma_0+d*\theta)^2}]})
# \end{equation}
# 
# 
# if $\sigma_0>>\theta d$ then
#  \begin{equation}
# P_r =\frac{P_0 A_t\sigma_0}{ 2*\pi d^2}(1-\exp(\frac{-R^2d^2}{(2\sigma_0f_{sys})^2}))  
# \end{equation}  
# This is the EVI function, where $k=(\sigma_0f_{sys}/R)^2$.
# 
# Re-arranging Eq. \ref{eq:bigone} into a functional form suitable for parametric fitting 
# \begin{equation}
# P_r =(\frac{C_0}{d^2})( \frac{\sigma_0}{\theta}+d)^2 (1-\exp[\frac{-(\frac{Rd}{\theta f_{sys}})^2}{2(\frac{\sigma_0}{\theta}+d)^2}])
# \end{equation}  
# \begin{equation}
# P_r =(\frac{C_0}{d^2})( C_1+d)^2 (1-\exp[\frac{-(C_2d)^2}{(C_1+d)^2}])
# \end{equation}  
# where 
# $C_0=\frac{P_0 A_t\theta}{2\pi}$,
# $C_1=\frac{\sigma_0}{\theta}$,
# and $C_2=\frac{R}{2\theta f_{sys}}$.
# 
# 
# Functional form to fit, 3 constants:
# \begin{equation}
# P_r =(\frac{C_0}{d^2})( C_1+d)^2 (1-\exp[\frac{-(C_2d)^2}{(C_1+d)^2}])
# \end{equation}  
# 
# $C_0=\frac{P_0 A_t\theta}{2\pi}$ a proxy for the zeropoint amplitude
# 
# $C_1=\frac{\sigma_0}{\theta}$ beam width/divergence [mm/radian]
# 
# 
# $C_2=\frac{R}{\sqrt{2}\theta f_{sys}}$
# 
# $FWHM=2.354\sigma=1.18(W_{1/e^2})\rightarrow\sigma=1.18/2.354*W_{1/e^2}$
# 
# $\sigma_0=1.18/2.354*7mm=3.5mm$
# 
# expected: $C_1=\frac{3.5mm}{.0025rad }=1.4 meters/radian$
# 
# expected: $C_2=.0005m/(\sqrt{2}*.0025rad*.153m)=0.9 [1/rad] $ 
# 
# 

# <codecell>

from sherpa.models import ArithmeticModel, Parameter,PowLaw1D
from sherpa.data import Data1D
from sherpa.models import PowLaw1D
from sherpa.models import Gauss1D
from sherpa.stats import Chi2DataVar
from sherpa.stats import LeastSq
from sherpa.optmethods import LevMar
from sherpa.optmethods import MonCar
from sherpa.optmethods import NelderMead
from sherpa.fit import Fit

import numpy as np

sigma0=14.0
class EVI_FUN(ArithmeticModel):
  def __init__(self, name='simple_overfilling'):
       # p[0]
       self.amplitude= Parameter(name, 'amplitude', 1)
       self.k=Parameter(name,'k',1)
       # p[2]
       #self.Hm = Parameter(name, 'Hm', 1)

       ArithmeticModel.__init__(self, name, (self.amplitude,self.k))
       

  def calc(self, p, xlo, xhi=None, *args, **kwargs):
    ret_power=(p[0]/xlo**2)*(1-exp(-xlo**2/p[1]))
      #  print(p)
    return ret_power

# <markdowncell>


# <codecell>



class g2(ArithmeticModel):
  def __init__(self, name='simple_overfilling'):
       # p[0]
       self.c0= Parameter(name, 'c1', 1) 
       #p[1]
       self.c1 = Parameter(name, 'c2', 1)
       #p[2]
       self.c2=Parameter(name,'c3',1) #extra parameter
       ArithmeticModel.__init__(self, name, (self.c0,self.c1,self.c2))
       

  def calc(self, p, xlo, xhi=None, *args, **kwargs):
    d=xlo    
    ret_power =(p[0]/d**2)*( p[1]+d)**2 *(1.-np.exp(-(p[2]*d)**2/((p[1]+d)**2)))
    #ret_power=p[0]/(p[1]+p[2]*d)**2*(1.0-exp(-(p[1]+p[2]*d)**2/d**2)) #old, questionable equation posted to blog
    return ret_power

# <codecell>


#import sherpa.astro.ui 
from sherpa.data import Data1D
from sherpa.models import PowLaw1D
from sherpa.models import Gauss1D
from sherpa.stats import Chi2DataVar
from sherpa.stats import LeastSq
from sherpa.optmethods import LevMar
from sherpa.optmethods import MonCar
from sherpa.optmethods import NelderMead
from sherpa.fit import Fit
#from dwelfitting import gauss
from sherpa.models import Gauss1D
ranges=np.array(avgrange)-np.min(avgrange)
power=np.array(avgmax)
dpower=np.array(stdmax)+0.1
data = Data1D('radar',ranges[:-2] ,power[:-2],dpower[:-2])

# <codecell>



#define and constrain model to fit
sc2= g2('sc2')
plaw= PowLaw1D('powerlaw')
evi= EVI_FUN('evi')
evi.k=.5
'''
sc2.amplitude= 5500.0 
sc2.sigma=10.0
sc2.c0=0.1

sc2.amplitude.max =  1e7# numpy.max(NE)
sc2.sigma.max = 1000.0#  sc1.Hm     # 100 #km
sc2.c0.max=1000

sc2.amplitude.min =  0.001# 
sc2.sigma.min = 0.001#  sc1.Hm     # 100 #km
sc2.c0.min = 0.00001
'''
#actually do the fit:
f = Fit(data, sc2, Chi2DataVar(),MonCar())
f_p_law = Fit(data, plaw, Chi2DataVar(),MonCar())

f_evi = Fit(data, evi, Chi2DataVar(),MonCar())

sresult = f.fit()
sresult2 = f_p_law.fit()
sresult3 = f_evi.fit()

print("FOV function:")
print sresult.format()

print("p-law function:")
print sresult2.format()

print("EVI function:")

print sresult3.format()

plt.plot(data.x,sc2(data.x),'--',lw=3, color='k',\
         label="FOV function,$C_0=$"+str(round(sc2.c0.val,2))+", $C_1=$"+str(round(sc2.c1.val,2))\
        +", $C_2=$"+str(round(sc2.c2.val,2)))

plt.plot(data.x,plaw(data.x),lw=3, alpha=0.6,color='r',label="Power Law fit,$"+str(round(plaw.ampl.val,1))+"x^{-"+str(round(plaw.gamma.val,3))+"}$")
plt.plot(data.x,evi(data.x),lw=1, alpha=0.6,color='g',label="EVI Exponent fit,$k={"+str(round(evi.k.val,3))+"}$")

plt.errorbar(data.x,data.y,yerr=data.get_yerr(),label="Measured")
plt.legend(fontsize=13)
plt.xlabel("Range",fontsize=16)
plt.ylabel("ADU",fontsize=16)
plt.savefig("RangeFunc.png")

# <codecell>

i=0
meanwav=mean(waveforms[slices[i][0]:slices[i][1]],axis=0)
stdwav=std(waveforms[slices[i][0]:slices[i][1]],axis=0)
xax=np.arange(np.shape(meanwav)[0])*meter_per_bin
errorbar(xax-np.min(avgrange),meanwav,yerr=stdwav)
plot(xax-np.min(avgrange),meanwav)
xlabel("Meters",fontsize=14)
ylabel("ADU",fontsize=14)
ylim([500,520])
xlim([0,100])

savefig('examplemeanwaveform.png')

# <codecell>


# <codecell>


# <codecell>


# <codecell>


# <codecell>


# <codecell>


