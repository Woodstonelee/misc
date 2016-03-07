% a Matlab script to read DWEL's HDF5 file and have a quick check
% on the data in Matlab's figure windows. 
% 
% zhanli86@bu.edu, Zhan Li
% April 27, 2014

clear;

% read 1064 waveform data
inputfile = '/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_April25/20/waveform_2014-04-25-16-27.hdf5';
wf1064 = h5read(inputfile, '/1064 Waveform Data');
% get the waveform maximum
[wf1064_max, wf1064_max_pos] = max(wf1064, [], 1);
