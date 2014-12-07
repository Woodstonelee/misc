## -*- coding: utf-8 -*-
#"""
#Created on Wed Mar 27 12:26:57 2013
#
#@author: kuravih
#"""

import PyQt4
import matplotlib
matplotlib.use('Qt4Agg')
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.widgets import Slider
import numpy as np
from scipy.signal import correlate
import scipy.fftpack
import time
import logging
import sys

global waveSize16, headerSize16, headerSize32, pulsesPerScan, tNow, nLasers, laser1550, laser1064
nLasers = 2
laser1064 = 0
laser1550 = 1
headerSize16 = 6
headerSize32 = headerSize16/2
waveSize16 = 1600
waveSize32 = waveSize16/2
pulsesPerScan = 3050
tNow = time.time()


logging.basicConfig(format='%(asctime)s.%(msecs)d %(message)s',datefmt='%H:%M:%S',level=logging.INFO)


def logTime(mesg,tNow = None):
    if tNow == None:
        logging.info(mesg)
    else:
        tNow = time.time() - tNow
        logging.info(mesg+' : Duration = %f s',tNow)
        tNow = time.time()
        return tNow

def getPeriod(x):
    fft_x = scipy.fftpack.fft(x)
    n = len(fft_x)
    freq = scipy.fftpack.fftfreq(n, 1)
    half_n = np.ceil(n/2.0)
    fft_x_half = (2.0 / n) * fft_x[:half_n]
    freq_half = freq[:half_n]
    freqs = np.abs(fft_x_half)[1:]
    return 1/freq_half[freqs.argmax()+1]
    
    
def initialChunk(fileObject,measurement,nPulses):
#    startByteNo = 2*waveSize16*10000 # beacause seek goes by bytes
#    fileObject.seek(startByteNo)
    fileObject.seek(0)
    datastrm16 = np.fromfile(fileObject,dtype=np.uint16,count=nLasers*waveSize16*nPulses)
    chunkMeasurement = measurement(datastrm16,laser1550)
    return chunkMeasurement    
    
def waveforms(strm,laser=0):
    return [strm[pulseNo+headerSize16:pulseNo+waveSize16-1] for pulseNo in range(laser*waveSize16, len(strm), nLasers*waveSize16)]
    
def maxIntensity(strm,laser=0):
    if laser == 0:
        return [strm[pulseNo+headerSize16+260:pulseNo+waveSize16-1].max() if strm[pulseNo+4] else strm[pulseNo+headerSize16+260-waveSize16:pulseNo+waveSize16-1-waveSize16].max() for pulseNo in range(laser*waveSize16, len(strm), nLasers*waveSize16)]
    if laser == 1:
        return [strm[pulseNo+headerSize16+260-waveSize16:pulseNo+waveSize16-1-waveSize16].max() if strm[pulseNo+4] else strm[pulseNo+headerSize16+260:pulseNo+waveSize16-1].max() for pulseNo in range(laser*waveSize16, len(strm), nLasers*waveSize16)]
    
def maxTime(strm,laser=0):
    return [130+0.5*strm[pulseNo+headerSize16+260:pulseNo+waveSize16-1].argmax() for pulseNo in range(laser*waveSize16, len(strm), nLasers*waveSize16)]
    
def firstScan(fileObject,measurement,nthScan,laser=laser1550):
    startByteNo = 2*nLasers*waveSize16*pulsesPerScan*nthScan # beacause seek goes by bytes
    fileObject.seek(startByteNo)
#    fileObject.seek(0)
    datastrm16 = np.fromfile(fileObject,dtype=np.uint16,count=nLasers*waveSize16*pulsesPerScan)
    scanOne = measurement(datastrm16,laser)
    m = max(scanOne)
    maxlist = [i for i, j in enumerate(scanOne) if j == m]
    zenithShift = pulsesPerScan - maxlist[0] - int((maxlist[-1]-maxlist[0])/2)
    return scanOne, zenithShift
    
def generateScan(fileObject,measurement,nthScan,laser=laser1550):
    
    startByteNo = 2*nLasers*waveSize16*pulsesPerScan*nthScan # beacause seek goes by bytes
    fileObject.seek(startByteNo)
    datastrm16 = np.fromfile(fileObject,dtype=np.uint16,count=nLasers*waveSize16*pulsesPerScan)
    scanN = measurement(datastrm16,laser)
    
    yield scanN
        
def rollCorrelate(A,B):
    convResult = []
    for i in range(1,len(B)):
        convResult.append(np.convolve(A,np.roll(B,i), 'valid')[0])
    return np.array(convResult)

def generateAdjustedScan(fileObject,measurement,nthScan,adjustTo,zenithShift,laser=laser1550):
    
    scanN = list(generateScan(fileObject,measurement,nthScan,laser))[0]
    
    #B = np.array(scanN)
    #B -= B.mean(); B /= B.std()
    
    #coreResult = rollCorrelate(adjustTo, B)
    #shift = coreResult.argmax()
    #coreResultM = rollCorrelate(adjustTo,B[::-1])
    
    #if (coreResultM.max() > coreResult.max()):
    #    B = B[::-1]
    #    scanN = scanN[::-1]
    #    shift = coreResultM.argmax()
    #else:
    #    shift = coreResult.argmax()

    #scanN = np.roll(scanN,shift+zenithShift)
    #scanN = np.roll(scanN,zenithShift)
    yield scanN
        
        
        
def straighten(mat,FB = None):
    if FB == None or FB == 'F':
        return np.array(np.rot90(mat[:,:pulsesPerScan/2],1))
    else:
        return np.array(np.rot90(mat[:,pulsesPerScan/2:],3))



def updateImage(*args):
    global n, tNow, waveMaxMat1064, waveMaxMat1550, scanOne1064, scanOne1550, zShift1064, zShift1550
    n += 1
    
    # try:
    waveMaxMat1064 = np.delete(waveMaxMat1064,0, axis=0)
    waveMaxMat1064 = np.append(waveMaxMat1064,np.array(list(generateAdjustedScan(fileObject,maxIntensity,n,scanOne1064,zShift1064,laser1064))), axis=0)
    waveMaxMat1550 = np.delete(waveMaxMat1550,0, axis=0)
    waveMaxMat1550 = np.append(waveMaxMat1550,np.array(list(generateAdjustedScan(fileObject,maxIntensity,n,scanOne1550,zShift1550,laser1550))), axis=0)
    # except Exception:
    #     print('reached the end')
    #     n -= 1
        
    # scanOne1064 = waveMaxMat1064[-1]
    # scanOne1550 = waveMaxMat1550[-1]
    
    # if (n%500 == 0):
    #     scanA1064, zShift1064 = firstScan(fileObject,maxIntensity,laser1064)
    #     scanOne1064 = np.array(scanA1064)
    #     scanOne1064 -= scanOne1064.mean(); scanOne1064 /= scanOne1064.std()
    #     scanA1550, zShift1550 = firstScan(fileObject,maxIntensity,laser1550)
    #     scanOne1550 = np.array(scanA1550)
    #     scanOne1550 -= scanOne1550.mean(); scanOne1550 /= scanOne1550.std()

    # if (n%50 == 0):
    #     scanA1064,zShift1064  = firstScan(fileObject,maxIntensity,n,laser1064)
    #     zShift1064 = zShift1064+1000
    #     scanOne1064 = np.array(scanA1064)
    #     scanOne1064 -= scanOne1064.mean(); scanOne1064 /= scanOne1064.std()
    #     scanA1550, zShift1550 = firstScan(fileObject,maxIntensity,n,laser1550)
    #     zShift1550 = zShift1064
    #     scanOne1550 = np.array(scanA1550)
    #     scanOne1550 -= scanOne1550.mean(); scanOne1550 /= scanOne1550.std()

    
    im1.set_data(waveMaxMat1064)
    im2.set_data(waveMaxMat1550)
    tNow = logTime('loop '+repr(n),tNow)
    return im1,im2
    

def updateWaveform(*args):
    global n, tNow
    n += 1
    
    sPPS.on_changed(update)
    x = np.arange(pulsesPerScan)
    ax.set_xlim(0, pulsesPerScan)

    try:
        line1.set_data(x,np.array(list(generateScan(fileObject,maxIntensity,n,laser1064))))
        line2.set_data(x,np.array(list(generateScan(fileObject,maxIntensity,n,laser1550))))
        if len(line1.get_data()[1][0]) != pulsesPerScan: raise Exception
    except Exception:
#        print('Waiting for data')
        n -= 1
        
    tNow = logTime('loop '+repr(n),tNow)
    return line1, line2,    
 

def updatePolar(*args):
    global n, tNow
    n += 1
    
    sPPS.on_changed(update)
    r = np.arange(0,2*np.pi,2*np.pi/pulsesPerScan)
    theta = np.arange(0,2*np.pi,2*np.pi/pulsesPerScan)
    
    try:
        line1.set_data(theta,np.array(list(generateScan(fileObject,maxTime,n,laser1064))))
        line2.set_data(theta,np.array(list(generateScan(fileObject,maxTime,n,laser1550))))
        if len(line1.get_data()[1][0]) != pulsesPerScan: raise Exception
    except Exception:
        n -= 1
        
#    tNow = logTime('loop '+repr(n),tNow)
    return line1, line2,


def update(val):
    global pulsesPerScan
    pulsesPerScan = int(sPPS.val)
    

def previewBinary(binFile):
    global n, im1, im2, waveMaxMat1064, waveMaxMat1550, fileObject, scanOne1064, scanOne1550, zShift1064, zShift1550

    fileName = binFile
    fileObject = open(fileName,'rb')


    #initChunk = initialChunk(fileObject,maxIntensity,1000000)
    #pulsesPerScan = int(getPeriod(initChunk))
    pulsesPerScan = 3050

    print(pulsesPerScan)

    tNow = time.time()

    fig = plt.figure()



    waveMaxMat1064 = np.zeros(shape=(450,pulsesPerScan))
    waveMaxMat1550 = np.zeros(shape=(450,pulsesPerScan))
    ax1 = plt.subplot(211)
    ax2 = plt.subplot(212)
    im1 = ax1.imshow(waveMaxMat1064,vmin=500,vmax=750,interpolation='none',aspect='equal',extent=None)
    im2 = ax2.imshow(waveMaxMat1550,vmin=500,vmax=750,interpolation='none',aspect='equal',extent=None)
    ax1.set_title('1550')
    ax2.set_title('1064')
    ax1.set_xlabel("Shot No.")
    ax2.set_xlabel("Shot No.")
    ax1.set_ylabel("Rotation")
    ax2.set_ylabel("Rotation")
    cax1 = fig.add_axes([0.125, 0.53, 0.775, 0.025])
    fig.colorbar(im1, cax=cax1,orientation='horizontal')
    cax2 = fig.add_axes([0.125, 0.09, 0.775, 0.025])
    fig.colorbar(im2, cax=cax2,orientation='horizontal')
    n = 10
    scanA1064,zShift1064  = firstScan(fileObject,maxIntensity,20,laser1064)
    zShift1064 = zShift1064+1000
    scanOne1064 = np.array(scanA1064)
    scanOne1064 -= scanOne1064.mean(); scanOne1064 /= scanOne1064.std()
    scanA1550, zShift1550 = firstScan(fileObject,maxIntensity,20,laser1550)
    zShift1550 = zShift1064
    scanOne1550 = np.array(scanA1550)
    scanOne1550 -= scanOne1550.mean(); scanOne1550 /= scanOne1550.std()
    ani = animation.FuncAnimation(fig, updateImage, interval=0, blit=False, repeat=False)
    plt.show()
    # ax = fig.add_axes([0.2, 0.2, 0.6, 0.7], polar=True)
    # plt.subplots_adjust(bottom=0.2)
    # axPPS = plt.axes([0.2, 0.1, 0.65, 0.03])
    # sPPS = Slider(axPPS, 'PPS', pulsesPerScan-20, pulsesPerScan+20, valinit=pulsesPerScan, valfmt='%d')
    # ax.set_ylim(0, 400)
    # r = np.arange(0,2*np.pi,2*np.pi/pulsesPerScan)
    # theta = np.arange(0,2*np.pi,2*np.pi/pulsesPerScan)
    # line1, = ax.plot(theta, r, ls='', marker = '.', markersize=2)
    # line2, = ax.plot(theta, r, ls='', marker = '.', markersize=2)
    # n=0 
    # ani = animation.FuncAnimation(fig, updatePolar, interval=0, blit=False, repeat=False)
    # plt.show()
    


def main():
    print('binary file :'+sys.argv[1])
    previewBinary(sys.argv[1])


if __name__ == '__main__':
    main()




# ax = fig.add_subplot(111)
# plt.subplots_adjust(bottom=0.2)
# axPPS = plt.axes([0.2, 0.1, 0.65, 0.03])
# sPPS = Slider(axPPS, 'PPS', pulsesPerScan-200, pulsesPerScan+200, valinit=pulsesPerScan, valfmt='%d')
# line1, = ax.plot([],[],ls='', marker = '.', markersize=2)
# line2, = ax.plot([],[],ls='', marker = '.', markersize=2)
# x = np.arange(pulsesPerScan)
# ax.set_ylim(500, 1100)
# ax.set_xlim(0, pulsesPerScan)
# n=0    
# ani = animation.FuncAnimation(fig, updateWaveform, interval=0, blit=False, repeat=False)
# plt.show()










