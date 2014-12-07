# -*- coding: utf-8 -*-
"""
Created on Mon Jun 24 03:06:02 2013

@author: kuravih
"""

import sys
import os
import numpy as np
import h5py
import matplotlib.pyplot as plt


def angleInterp(x,xp,fp):
    temp1 = np.zeros(fp.size)
    
    for i in range(fp.size-1):
        temp1[i+1] = -int((fp[i+1]-fp[i]) > (2**5))
    stepfp = (2**19)*np.cumsum(temp1)
    newfp = stepfp+fp
    intfp = np.interp(x, xp, newfp)
    resfp = np.zeros(intfp.size)
    
    for j in range(intfp.size):
        resfp[j] = intfp[j]%(2**19)

    return resfp
    
    
def temporaryFix(fp):
    tempfp0 = np.zeros(fp.size)
    temp0 = 0
    
    for i in range(fp.size-1):
        if ((fp[i+1]-fp[i]) > (2**8)):
            temp0 -= fp[i+1]-fp[i]
        elif ((fp[i+1]-fp[i]) < -(2**8)):
            temp0 -= fp[i+1]-fp[i]
        else:
            pass
        tempfp0[i+1] = temp0      
        
    newfp = ((2**19)-(2**16))+fp+tempfp0
    
    return newfp
    


def combine(hdf5filestr1,hdf5filestr2):
    if (os.path.getsize(hdf5filestr1) > os.path.getsize(hdf5filestr2)):
        hdf5filestrA = hdf5filestr1
        hdf5filestrB = hdf5filestr2
    else:
        hdf5filestrA = hdf5filestr2
        hdf5filestrB = hdf5filestr1

    waveformFileStr = hdf5filestrA #'June16_05.hdf5'
    angleFileStr = hdf5filestrB #'angledata_2013-06-16-13-17-38.hdf5'
    
    waveformHDF5file = h5py.File(waveformFileStr,'r+')
    angleHDF5file = h5py.File(angleFileStr,'r')
    
    wavTime = waveformHDF5file.get('Time')[:,0]#list(waveformHDF5file)[0]
    encTime = angleHDF5file.get('Encoders')[:-1,0]
    azmVals = angleHDF5file.get('Encoders')[:-1,1]
    altVals = angleHDF5file.get('Encoders')[:-1,2]
    # encPeriod=0.0098435*3
    # encTime = np.arange(wavTime[0],wavTime[0]+encPeriod*azmVals.size-0.5*encPeriod,encPeriod)
    
    intAltVals = angleInterp(wavTime, encTime, altVals)
    #intAzmVals = angleInterp(wavTime, encTime, azmVals)
    newazmVals = temporaryFix(azmVals)
    intAzmVals = angleInterp(wavTime, encTime, newazmVals)
    
    waveformHDF5file.create_dataset('Interpolated angles (Alt, Azm)', data = np.append([intAltVals],[intAzmVals],axis=0).T)

    fig = plt.figure()
    ax = fig.add_subplot(111)
    line1 = ax.plot(encTime[:int(encTime.size/10)],azmVals[:int(encTime.size/10)], marker = '', markersize=4)
    line2 = ax.plot(encTime[:int(encTime.size/10)],altVals[:int(encTime.size/10)], marker = '', markersize=4)
    line3 = ax.plot(wavTime[:int(wavTime.size/10)],intAzmVals[:int(wavTime.size/10)],ls='', marker = '.', markersize=4)
    line4 = ax.plot(wavTime[:int(wavTime.size/10)],intAltVals[:int(wavTime.size/10)],ls='', marker = '.', markersize=4)
    plt.show()
    
    waveformHDF5file.flush()
    waveformHDF5file.close()
    
    angleHDF5file.flush()
    angleHDF5file.close()


# combine('/Users/kuravih/Downloads/working/waveform_2014-05-31-17-18.hdf5','/Users/kuravih/Downloads/working/encoder_2010-01-02-22-27-37.hdf5')

def main():
    print('file 1 :'+sys.argv[1]+' and file 2 :'+sys.argv[2])
    combine(sys.argv[1],sys.argv[2])


if __name__ == '__main__':
    main()




 