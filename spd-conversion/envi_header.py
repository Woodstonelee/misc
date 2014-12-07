'''
parse the ENVI header file, specially for EVI/DWEL data in ENVI image format. 

It includes a lot of code lines from envi.py by the following author:
# Copyright (c) 2013 Australian Government, Department of the Environment
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software

Zhan Li, zhanli86@bu.edu
Created: 20140606
Last modified:
- 20140606, created
'''

import sys

class ENVI_HDR:
    '''
    A class to handle ENVI header file, provide the envi header file name
    to instantiate the class.
    '''
    def __init__(self, headerfilename, openmode):
        self.headerfilename = headerfilename
        self.openmode = openmode

    def __del__(self):
        pass

    def getheader(self):
        '''
        Get all record strings in an envi header file. 
        A record could be simply "record_name = record_value"
        or a complex string containing more meta data like
        "record_name = {multiple_meta_data}"
        '''
        self.headerfile = open(self.headerfilename, self.openmode)
        headers = self.headerfile.readlines()
        header_dict = {} # create an empty dictionary
        if headers[0].strip().upper().find('ENVI') == -1:
            raise NameError('Not an ENVI header file used to construct the class ENVI_Header!')
        i = 1 # skip the first line in the header file, it is 'ENVI'
        while True:
            line = headers[i].strip()
            if line.find('{') > -1: # this line is a record of complex string
                var = [s.strip() for s in line.replace('{','').split('=',1)] # here is list comprehension
                if line.find('}') == -1:
                    i += 1
                    while True:
                        line = headers[i].strip()
                        var[1] += '\n' + line
                        if line.find('}') > -1: break
                        i += 1
                var[1] = var[1].replace('}','')
            else: # no '{}' means this line is a simple record
                var = [s.strip() for s in line.split('=', 1)] # here is list comprehension
            header_dict[var[0]] = var[1]
            i += 1
            if i >= len(headers): break
        self.headerfile.close()
        return header_dict
    
    __getheader = getheader # private copy of original getheader() method, so that in case of being inheritated
    # by a new class this function won't be broken in by the inheritate class's method.

    def getmetadata(self):
        '''
        Extract the record value from each record string
        '''
        hdr = self.__getheader()
        metadata = {} # create an empty dictionary to store metadata
        if hdr['file type'].upper().find('ENVI') > -1:
            kw = hdr.keys() # get a list of keyword names
            for k in kw:
                varstr = hdr[k].strip()
                if varstr.find(',') > -1: # for complex string record                    
                    vardict = {} # creat an empty dictionary to store the metadata in this record.
                    descript_str = [] # create an empty list to store the string metadata in this record. 
                    for s in varstr.split(','):
                        s = s.strip()
                        var = [t.strip() for t in s.split('=', 1)]
                        if len(var) == 1: # it is simply a string metadata
                            descript_str.append(var[0])
                        else: # it is a "meta_name = meta_value"
                            if var[1].replace('.', '0', 1).isdigit(): # if the right of the "=" is a numeric
                                vardict[var[0]] = float(var[1])
                            else:
                                vardict[var[0]] = var[1]
                    vardict['descript_str'] = descript_str
                    metadata[k] = vardict
                else: # for a simple "meta_name = meta_value"
                    if varstr.isdigit():
                        metadata[k] = float(varstr)
                    else:
                        metadata[k] = varstr
        else:
            raise NameError('Not an ENVI header file used to construct the class ENVI_Header!')
        # special operation on some EVI/DWEL metadata
        varstr = metadata['evi_scan_info']['Beam Divergence']
        var = [t.strip() for t in varstr.split()]
        metadata['evi_scan_info']['Beam Divergence'] = float(var[0])
        varstr = metadata['evi_scan_info']['Digitised Range']
        var = [t.strip() for t in varstr.split()]
        metadata['evi_scan_info']['Digitised Range'] = float(var[0])
        varstr = metadata['evi_scan_info']['Digitiser Sampling Rate']
        var = [t.strip() for t in varstr.split()]
        metadata['evi_scan_info']['Digitiser Sampling Rate'] = float(var[0])

        return metadata

    def putheader(self, header_dict):
        '''
        Write records to a header file
        '''
        self.headerfile = open(self.headerfilename, self.openmode)
        kw = header_dict.keys() # get a list of keyword names        
        for k in kw:
            if header_dict[k].find(',') > -1: # this is a complex string that needs braces
                self.headerfile.write(k + ' = {' + str(header_dict[k]) + '}')
                self.headerfile.write('\n')
            else: # this is a simple string without needing braces
                self.headerfile.write(k + ' = ' + str(header_dict[k]))
                self.headerfile.write('\n')
        self.headerfile.close()




