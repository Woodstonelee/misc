## -*- coding: utf-8 -*-
#"""
#Created on Thu Jun  6 12:48:32 2013
#
#@author: kuravih
#
#Revised on Sun May 4 9:46 2014 by Zhan
#"""
##1073741809

import h5py
import numpy as np
import os
import logging
import time
import sys

logging.basicConfig(format='%(asctime)s.%(msecs)d %(message)s',datefmt='%H:%M:%S',level=logging.INFO)


def logTime(mesg,tNow = None):
    if tNow == None:
        logging.info(mesg)
    else:
        tNow = time.time() - tNow
        logging.info(mesg+' : Duration = %f s',tNow)
        tNow = time.time()
        return tNow
    
    
def getWaveform(fileObj,nth):
    
    startByteNo = nLasers*2*waveSize16*nth # beacause seek goes by bytes
    fileObj.seek(startByteNo)
    
    dgram = np.fromfile(fileObj,dtype=np.uint16,count=nLasers*waveSize16)
    time1 = (dgram[0] + (2**16)*dgram[1]) + (dgram[2] + (2**16)*dgram[3])*1E-9
    laser1 = dgram[4]
    laser1waveno = dgram[5]
    waveform1 = dgram[6:waveSize16]
    time2 = (dgram[waveSize16] + 65536*dgram[waveSize16+1]) + (dgram[waveSize16+2] + 65536*dgram[waveSize16+3])*1E-9
    laser2 = dgram[waveSize16+4]
    laser2waveno = dgram[waveSize16+5]
    waveform2 = dgram[waveSize16+6:2*waveSize16]
    
    if (laser1):
        waveform1064 = waveform2
        waveform1548 = waveform1
        time = time1
        pulseNumber = laser1waveno
    else:
        waveform1064 = waveform1
        waveform1548 = waveform2
        time = time2
        pulseNumber = laser2waveno
        
    waveForm = {'Time':time, 'Pulse No':pulseNumber, '1064 Waveform Data':waveform1064, '1548 Waveform Data':waveform1548}
    return waveForm
  
  
def appendWaveform(hdffile,waveForm):
    dSet1064 = hdffile.get('1064 Waveform Data')
    length = dSet1064.shape[0]
    dSet1064.resize(length+1, axis=0)
    dSet1064[length,:] = waveForm['1064 Waveform Data']
    
    dSet1548 = hdffile.get('1548 Waveform Data')
    dSet1548.resize(length+1, axis=0)
    dSet1548[length,:] = waveForm['1548 Waveform Data']
    
    dSetTime = hdffile.get('Time')
    dSetTime.resize(length+1, axis=0)
    dSetTime[length:] = waveForm['Time']

    dSetPulseN = hdffile.get('Pulse No')
    dSetPulseN.resize(length+1, axis=0)
    dSetPulseN[length:] = waveForm['Pulse No']

        
def getWaveforms(fileObj,nthchunk,pulseCount):
    #global tNow1
    waveForms = []
    startByteNo = nLasers*2*waveSize16*pulseCount*nthchunk # beacause seek goes by bytes
    fileObj.seek(startByteNo)
    strm = np.fromfile(fileObj,dtype=np.uint16,count=pulseCount*2*waveSize16)
    for pulseNo in range(0, len(strm), nLasers*waveSize16):
        dgram1 = strm[pulseNo:pulseNo+waveSize16]
        dgram2 = strm[pulseNo+waveSize16:pulseNo+2*waveSize16]
        if (dgram1[4]):
            waveform1064 = dgram1[6:]
            waveform1548 = dgram2[6:]
            time = (dgram2[0]+65536*dgram2[1])+(dgram2[2]+65536*dgram2[3])*1E-9
            pulseNumber = dgram2[5]
        else:
            waveform1548 = dgram1[6:]
            waveform1064 = dgram2[6:]
            time = (dgram1[0]+65536*dgram1[1])+(dgram1[2]+65536*dgram1[3])*1E-9
            pulseNumber = dgram1[5]
    
        waveForm = {'Time':time, 'Pulse No':pulseNumber, '1064 Waveform Data':waveform1064, '1548 Waveform Data':waveform1548}
        waveForms.append(waveForm)
        
    #tNow1 = logTime(str(fileObj.tell())+' entries in',tNow1)
    return waveForms



def appendWaveforms(hdffile,waveForms):
    m = len(waveForms)
    dSet1064 = hdffile.get('1064 Waveform Data')
    length = dSet1064.shape[0]
    dSet1064.resize(length+m, axis=0)
    dSet1064[length:length+m,:] = [waveForms[pulseNo]['1064 Waveform Data'] for pulseNo in range(0, m)]

    dSet1548 = hdffile.get('1548 Waveform Data')
    dSet1548.resize(length+m, axis=0)
    dSet1548[length:length+m,:] = [waveForms[pulseNo]['1548 Waveform Data'] for pulseNo in range(0, m)]
    
    dSetTime = hdffile.get('Time')
    dSetTime.resize(length+m, axis=0)
    dSetTime[length:length+m,0] = [waveForms[pulseNo]['Time'] for pulseNo in range(0, m)]
 
    dSetPulseN = hdffile.get('Pulse No')
    dSetPulseN.resize(length+m, axis=0)
    dSetPulseN[length:length+m,0] = [waveForms[pulseNo]['Pulse No'] for pulseNo in range(0, m)]   
    
global tNow1, tNow2
tNow1 = time.time()

nLasers = 2

headerSize16 = 6
waveSize16 = 1600

def processBinary(binFile, hdfFile):
    # binFile = 'June6_04'
    # hdfFile = binFile+'.hdf5'
    binFileObj = open(binFile,'r')

    chunkSize = 10000

    byteCount = os.path.getsize(binFile)/2
    NWaveforms = byteCount/1600

    Nloop = int(np.floor(os.path.getsize(binFile)/(2*2*1600*chunkSize)))

    hdf5waveforms = h5py.File(hdfFile,'w')

    hdf5waveforms.create_dataset('Time', (0,1) ,maxshape=(None,1), dtype=np.float64 )
    hdf5waveforms.create_dataset('Pulse No', (0,1) ,maxshape=(None,1), dtype=np.float64 )
    hdf5waveforms.create_dataset('1064 Waveform Data', (0, waveSize16-headerSize16), maxshape=(None, waveSize16-headerSize16), dtype=np.uint16)
    hdf5waveforms.create_dataset('1548 Waveform Data', (0, waveSize16-headerSize16), maxshape=(None, waveSize16-headerSize16), dtype=np.uint16)
    hdf5waveforms.flush()
    hdf5waveforms.close()


    hdf5waveforms = h5py.File(hdfFile,'r+')
    tNow2 = time.time()

    for i in range(Nloop):
        appendWaveforms(hdf5waveforms,getWaveforms(binFileObj,i,chunkSize))

    for j in range(Nloop*chunkSize+1,int(np.floor(os.path.getsize(binFile)/(2*2*1600)))):
        appendWaveform(hdf5waveforms,getWaveform(binFileObj,j))

    tNow2 = logTime('Processed '+repr( int(np.floor(os.path.getsize(binFile)/(2*2*1600))) )+' entries',tNow2)

    hdf5waveforms.flush()
    hdf5waveforms.close()

def main():
    print('binary file :'+sys.argv[1])
    print('output hdf5 file:'+sys.argv[2])
    processBinary(sys.argv[1], sys.argv[2])


if __name__ == '__main__':
    main()

#hdf5waveforms = h5py.File(hdfFile,'r+')
#
#tNow1 = time.time()
#
#for i in range(1000):
#    appendWaveform(hdf5waveforms,getWaveform(binFileObj,i))
#
#tNow1 = logTime('takes',tNow1)
#
#    
#hdf5waveforms.flush()
#hdf5waveforms.close()
    
    
    
