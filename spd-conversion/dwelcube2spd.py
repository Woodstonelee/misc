#! /project/earth/packages/Python-2.7.5/bin python
"""
Create an SPD file from a DWEL scan cube file
John Armston, j.armston@uq.edu.au
SLOW SLOW SLOW

Revision and comment by
Zhan Li, zhanli86@bu.edu

Last modified: 
20140603, Zhan Li
"""

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
import envi_header

'''
Before use the gdal functions to open ENVI data cube for the first time, 
you need to register the ENVI data format with the following two functions
driver=gdal.GetDriverByName('ENVI')
driver.Register()
Once you've done it once, no need to do it second time. 
'''
        
def main(cmdargs):
    # debugging
    # import pdb; pdb.set_trace()
    
    driver=gdal.GetDriverByName('ENVI')
    driver.Register()
    """
    Read a DWEL ENVI file and write to SPD
    """    
    # Open the data cube files and read header
    cds = gdal.Open(cmdargs.cubefile, gdal.GA_ReadOnly)
    ads = gdal.Open(cmdargs.ancillaryfile, gdal.GA_ReadOnly)
    
    # Get basic metadata from the ENVI .hdr file
    metaStr = ads.GetMetadata('')
    # Get the ENVI header file name
    tmpstr = cmdargs.ancillaryfile.rsplit('.')
    if os.path.isfile(tmpstr[0]+'.hdr'):
      hdrname = tmpstr[0]+'.hdr'
    else:
      hdrname = cmdargs.ancillaryfile + '.hdr'
    # Get all metadata including EVI/DWEL defined metadata from the ENVI .hdr file
    hdr = envi_header.ENVI_HDR(hdrname, 'r')
    metaDict = hdr.getmetadata()

    # Open output SPD file
    spdoutfile = spdpy.createSPDFile(cmdargs.outfile)
    spdoutfile.setNumBinsX(cds.RasterXSize)
    spdoutfile.setNumBinsY(cds.RasterYSize)
    spdoutfile.setBinSize(1)
    spdwriter = spdpy.SPDPySeqWriter()
    spdwriter.open(spdoutfile, cmdargs.outfile)
    
    # Define the data present
    spdoutfile.setReceiveWaveformDefined(1)
    spdoutfile.setTransWaveformDefined(0)
    spdoutfile.setDecomposedPtDefined(0)
    spdoutfile.setDiscretePtDefined(0)
    spdoutfile.setOriginDefined(1)
    spdoutfile.setHeightDefined(0)
    spdoutfile.setRgbDefined(0)
    
    # Set header attributes
    spdoutfile.setSensorHeight(metaDict['evi_scan_info']['EVI Height'])
    spdoutfile.setTemporalBinSpacing(1.0 / metaDict['evi_scan_info']['Digitiser Sampling Rate'])
    spdoutfile.setBeamDivergence(metaDict['evi_scan_info']['Beam Divergence'] * 1e-3 / np.pi * 180.0) # unit: degree
    spdoutfile.setPulseIdxMethod(5)
    spdoutfile.setNumPulses(cds.RasterXSize*cds.RasterYSize)
    # The time of captured should be read from the header file later.
    # Now because the DWEL raw data does not give any meta data, the time of capture
    # is manually populated according to the name of field campaign
    if cmdargs.cubefile.lower().find('brisbane') > -1:
      spdoutfile.setYearOfCapture(2013)
      spdoutfile.setMonthOfCapture(7)
    if cmdargs.cubefile.find('CA') > -1:
      spdoutfile.setYearOfCapture(2013)
      spdoutfile.setMonthOfCapture(6)
    spdoutfile.setWaveformBitRes(16)
    # spdoutfile.setNumOfWavelengths(int(metaDict['dwel_adaptation']['Wavelength']))
    spdoutfile.setPulseRepetitionFreq(2000)
    spdoutfile.setMaxScanAngle(180.0)
    if metaDict['evi_scan_info']['Beam Divergence'] == 2.5:
      spdoutfile.setPulseAngularSpacingAzimuth(2.0 * 1e-3 / np.pi * 180.0) # unit: degree
      spdoutfile.setPulseAngularSpacingZenith(2.0 * 1e-3 / np.pi * 180.0) # unit: degree
    if metaDict['evi_scan_info']['Beam Divergence'] == 1.25:
      spdoutfile.setPulseAngularSpacingAzimuth(1.0 * 1e-3 / np.pi * 180.0) # unit: degree
      spdoutfile.setPulseAngularSpacingZenith(1.0 * 1e-3 / np.pi * 180.0) # unit: degree

    # Set user-defined header attribute string with JSON string format
    json_str = '{"evi_scan_info":{"Scan Duration":"' + metaDict['evi_scan_info']['Scan Duration'] + \
        '","Bearing":"' + metaDict['evi_scan_info']['Bearing'] + \
        '","Scan Description":"' + metaDict['evi_scan_info']['Scan Description'] + \
        '","More Description":"'
    json_str = json_str + ','.join(s.replace('"', '\\"') for s in metaDict['evi_scan_info']['descript_str']) 
    json_str = json_str + '"},"dwel_adaptation":{"More Description":"'
    json_str = json_str + ','.join(s.replace('"', '\\"') for s in metaDict['dwel_adaptation']['descript_str']) + '"}}'
    spdoutfile.setUserMetaField(json_str)

    minAz = 360.0
    maxAz = 0.0
    minZen = 180.0
    maxZen = 0.0
    # now read through the image blocks
    for y in range(cds.RasterYSize):
        
        # Read as scan line
        cdata = cds.ReadAsArray(xoff=0, yoff=y, xsize=cds.RasterXSize, ysize=1)
        adata = ads.ReadAsArray(xoff=0, yoff=y, xsize=ads.RasterXSize, ysize=1)
        scanline = list()
        
        for x in range(cds.RasterXSize):
                        
            pulse = spdpy.createSPDPulsePy()
            
            pulse.x0, pulse.y0, pulse.z0 = 0.0, 0.0, 0.0
            pulse.numberOfReturns = 0
            # band 7 (index 6 here) in ancillary is mask, index to bands here
            # starts from 0.
            if adata[6,0,x] == 0: pulse.ignore = 1
            # band 8 (index 7 here) in ancillary is zenith angle.
            pulse.zenith = adata[7,0,x]/10.0
            # band 9 (index 8 here) in ancillary is azimuth angle.
            pulse.azimuth = adata[8,0,x]/10.0            
            
            if pulse.azimuth > maxAz: maxAz = pulse.azimuth
            if pulse.azimuth < minAz: minAz = pulse.azimuth
            if pulse.zenith > maxZen: maxZen = pulse.zenith
            if pulse.zenith < minZen: minZen = pulse.zenith
            
            pulse.numOfReceivedBins = cdata[:,0,x].size

            pulse.received = [int(w) for w in cdata[:,0,x]]
            pulse.wavelength = int(metaDict['dwel_adaptation']['Wavelength'])

            pulse.pulseID = y * x + x
            pulse.xIdx = x
            pulse.yIdx = y
            pulse.scanline = y
            pulse.scanlineIdx = x
        
            #scanline.append(pulse)
            scanline.append([pulse])
        
        # Write scan line
        spdwriter.writeDataRow(scanline, y)
        
        # Let's monitor progress
        # sys.stdout.write("Writing sequential SPD file %s (%i%%)\r" % (cmdargs.outfile, y / float(cds.RasterYSize) * 100.0))
    
    # set more header attributes
    spdoutfile.setZenithMin(minZen)
    spdoutfile.setZenithMax(maxZen)
    spdoutfile.setAzimuthMin(minAz)
    spdoutfile.setAzimuthMax(maxAz)

    # set more header attributes
    # the time of creation will be populated by the spdlib itself. 
    # timenow = datetime.datetime.now()
    # spdoutfile.setYearOfCreation(timenow.year)
    # spdoutfile.setMonthOfCreation(timenow.month)
    # spdoutfile.setDayOfCreation(timenow.day)
    # spdoutfile.setHourOfCreation(timenow.hour)
    # spdoutfile.setMinuteOfCreation(timenow.minute)
    # spdoutfile.setSecondOfCreation(timenow.second)

    # Close the output file
    spdwriter.close(spdoutfile)
    
    # report it's finished
    sys.stdout.write("Writing sequential SPD file %s finished\n" % (cmdargs.outfile))


# Command arguments
class CmdArgs:
  def __init__(self):
    p = optparse.OptionParser()
    p.add_option("-c","--cubefile", dest="cubefile", default=None, help="Input DWEL scan cube ENVI file")
    p.add_option("-a","--ancillaryfile", dest="ancillaryfile", default=None, help="Input DWEL ancillary ENVI file")
    p.add_option("-o","--outfile", dest="outfile", default="dwel_test.spd", help="Output SPD filename")
    (options, args) = p.parse_args()
    self.__dict__.update(options.__dict__)
    
    if (self.cubefile is None) | (self.ancillaryfile is None):
        p.print_help()
        print "Input filenames must be set."
        sys.exit()


# Run the script
if __name__ == "__main__":
    cmdargs = CmdArgs()
    main(cmdargs)
