# -*- coding: utf-8 -*-
"""
Created on Thu Apr  3 16:55:10 2014

@author: kuravih
"""

import h5py
import numpy as np
import sys





def processAngles(fileName):
#    fileName = '/home/kuravih/Dropbox/newDwel/data/compass_2014-04-16-20-50-22'
    hdfFileName = fileName+'.hdf5'    
    
    with open(fileName, 'r') as anglebinfile:
        lines = anglebinfile.readlines()
        anglebinfile.close()
        
    dataLength = len(lines)
    
    hdf5file = h5py.File(hdfFileName,'w')
    encvalDataset = hdf5file.create_dataset("Compass", (dataLength,4),np.dtype('f8'),maxshape=(None,5))

    for index,line in enumerate(lines):
        dataLine = line[1:-7].split(", '")
        times = float(dataLine[0])
        angles = dataLine[1].split(",")
        encvalDataset[index,:]=[times,float(angles[0]),float(angles[1]),float(angles[2])]
        #print([times,float(angles[0]),float(angles[1]),float(angles[2])])
        
    hdf5file.flush()
    hdf5file.close()        
        

#processAngles('')
    
def main():
    print('angle binary file :'+sys.argv[1])
    processAngles(sys.argv[1])


if __name__ == '__main__':
    main()    
