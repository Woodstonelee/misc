# -*- coding: utf-8 -*-
"""
Created on Thu Apr  3 16:55:10 2014

@author: kuravih
"""

import h5py
import numpy as np
import sys


def parseSSIWord(ssiWords):
    #decode the ssi string and gets angle in digital units
    angleDu = [0,0]
    for i,val in enumerate(ssiWords):
        if len(val) == 10:
            binarystr = str(bin(int(val)))
            binary2 = binarystr[:2]+binarystr[2:].zfill(25)
            absval2=int(binary2[2:-5],2)
        if i < 2:
            angleDu[i]=absval2
        else:
            print('error, too many commas per return.')
            continue
    return angleDu





def processAngles(fileName, hdfFileName):
    #fileName = 'encoder_2010-02-06-23-11-43'
    # hdfFileName = fileName+'.hdf5'    
    
    with open(fileName, 'r') as anglebinfile:
        lines = anglebinfile.readlines()
        anglebinfile.close()
        
    dataLength = len(lines)
    
    hdf5file = h5py.File(hdfFileName,'w')
    encvalDataset = hdf5file.create_dataset("Encoders", (dataLength,3),np.dtype('f8'),maxshape=(None,4))

    for index,line in enumerate(lines):
        dataLine = line[1:-5].split(", '*0R0")
        times = float(dataLine[0])
        angles = parseSSIWord(dataLine[1].split(","))
        encvalDataset[index,:]=[times,angles[0],angles[1]]
        #print([times,angles[0],angles[1]])
        
    hdf5file.flush()
    hdf5file.close()        
        
    
def main():
    print('angle binary file :'+sys.argv[1])
    print('angle hdf5 file:'+sys.argv[2])
    processAngles(sys.argv[1], sys.argv[2])


if __name__ == '__main__':
    main()    
