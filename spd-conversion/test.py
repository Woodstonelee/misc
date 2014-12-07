#! /project/earth/packages/Python-2.7.5/bin python

import envi_header

testhdr = envi_header.ENVI_HDR('/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_ESP_Cal/Brisbane2013_ESP6m/July30_6m_1548_cube_NadirCorrect_Aligned_ancillary.img.hdr', 'r')

print(testhdr.openmode)
print(testhdr.headerfilename)

print(testhdr.getheader())

print(testhdr.getmetadata())

print('test\n')

-c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_ESP_Cal/Brisbane2013_ESP6m/July30_6m_1548_cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_ESP_Cal/Brisbane2013_ESP6m/July30_6m_1548_cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_ESP_Cal/Brisbane2013_ESP6m/July30_6m_1548_cube_NadirCorrect_Aligned.spd'
