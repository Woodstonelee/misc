#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=24:00:00
#$ -N dwel-wf-processing-cal-nsf-uml-20141220
#$ -V
#$ -m ae
#$ -t 1-68

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/0.5/waveform_2014-12-20-11-22.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1.5/waveform_2014-12-20-11-52.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1/waveform_2014-12-20-11-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/10/waveform_2014-12-20-17-06.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/11/waveform_2014-12-20-17-24.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/12/waveform_2014-12-20-17-34.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/waveform_2014-12-20-17-49.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/14/waveform_2014-12-20-18-02.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/15/waveform_2014-12-20-18-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2.5/waveform_2014-12-20-12-43.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2/waveform_2014-12-20-12-32.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/20/waveform_2014-12-20-18-29.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/25/waveform_2014-12-20-18-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3.5/waveform_2014-12-20-13-28.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3/waveform_2014-12-20-12-55.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/30/waveform_2014-12-20-18-56.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/35/waveform_2014-12-20-19-15.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4.5/waveform_2014-12-20-13-52.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4/waveform_2014-12-20-13-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/40/waveform_2014-12-20-20-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5.5/waveform_2014-12-20-14-25.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5/waveform_2014-12-20-14-04.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/50/waveform_2014-12-20-20-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6.5/waveform_2014-12-20-15-00.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6/waveform_2014-12-20-14-48.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/60/waveform_2014-12-20-20-53.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7.5/waveform_2014-12-20-15-29.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7/waveform_2014-12-20-15-12.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70/waveform_2014-12-20-10-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70_0/waveform_2014-12-20-10-26.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8.5/waveform_2014-12-20-16-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8/waveform_2014-12-20-16-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9.5/waveform_2014-12-20-16-52.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9/waveform_2014-12-20-16-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/0.5/waveform_2014-12-20-11-22.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1.5/waveform_2014-12-20-11-52.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1/waveform_2014-12-20-11-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/10/waveform_2014-12-20-17-06.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/11/waveform_2014-12-20-17-24.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/12/waveform_2014-12-20-17-34.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/waveform_2014-12-20-17-49.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/14/waveform_2014-12-20-18-02.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/15/waveform_2014-12-20-18-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2.5/waveform_2014-12-20-12-43.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2/waveform_2014-12-20-12-32.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/20/waveform_2014-12-20-18-29.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/25/waveform_2014-12-20-18-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3.5/waveform_2014-12-20-13-28.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3/waveform_2014-12-20-12-55.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/30/waveform_2014-12-20-18-56.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/35/waveform_2014-12-20-19-15.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4.5/waveform_2014-12-20-13-52.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4/waveform_2014-12-20-13-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/40/waveform_2014-12-20-20-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5.5/waveform_2014-12-20-14-25.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5/waveform_2014-12-20-14-04.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/50/waveform_2014-12-20-20-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6.5/waveform_2014-12-20-15-00.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6/waveform_2014-12-20-14-48.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/60/waveform_2014-12-20-20-53.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7.5/waveform_2014-12-20-15-29.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7/waveform_2014-12-20-15-12.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70/waveform_2014-12-20-10-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70_0/waveform_2014-12-20-10-26.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8.5/waveform_2014-12-20-16-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8/waveform_2014-12-20-16-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9.5/waveform_2014-12-20-16-52.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9/waveform_2014-12-20-16-41.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/0.5/config_2009-12-31-20-20-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1.5/config_2009-12-31-20-38-37.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1/config_2009-12-31-20-26-56.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/10/config_2010-01-01-02-04-37.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/11/config_2010-01-01-02-21-42.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/12/config_2010-01-01-02-32-37.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/config_2010-01-01-02-35-24.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/14/config_2010-01-01-02-47-47.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/15/config_2010-01-01-03-03-14.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2.5/config_2009-12-31-21-41-07.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2/config_2009-12-31-21-29-53.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/20/config_2010-01-01-03-15-17.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/25/config_2010-01-01-03-26-54.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3.5/config_2009-12-31-22-26-29.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3/config_2009-12-31-21-53-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/30/config_2010-01-01-03-41-41.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/35/config_2010-01-01-04-01-36.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4.5/config_2009-12-31-22-49-38.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4/config_2009-12-31-22-37-56.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/40/config_2010-01-01-05-22-14.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5.5/config_2009-12-31-23-17-51.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5/config_2009-12-31-23-01-52.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/50/config_2010-01-01-05-34-05.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6.5/config_2009-12-31-23-51-41.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6/config_2009-12-31-23-40-15.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/60/config_2010-01-01-05-45-25.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7.5/config_2010-01-01-00-20-49.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7/config_2010-01-01-00-04-23.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70/config_2009-12-31-19-39-31.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70_0/config_2009-12-31-19-24-09.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8.5/config_2010-01-01-01-28-40.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8/config_2010-01-01-01-15-17.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9.5/config_2010-01-01-01-50-41.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9/config_2010-01-01-01-39-26.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/0.5/config_2009-12-31-20-20-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1.5/config_2009-12-31-20-38-37.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1/config_2009-12-31-20-26-56.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/10/config_2010-01-01-02-04-37.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/11/config_2010-01-01-02-21-42.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/12/config_2010-01-01-02-32-37.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/config_2010-01-01-02-35-24.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/14/config_2010-01-01-02-47-47.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/15/config_2010-01-01-03-03-14.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2.5/config_2009-12-31-21-41-07.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2/config_2009-12-31-21-29-53.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/20/config_2010-01-01-03-15-17.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/25/config_2010-01-01-03-26-54.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3.5/config_2009-12-31-22-26-29.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3/config_2009-12-31-21-53-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/30/config_2010-01-01-03-41-41.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/35/config_2010-01-01-04-01-36.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4.5/config_2009-12-31-22-49-38.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4/config_2009-12-31-22-37-56.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/40/config_2010-01-01-05-22-14.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5.5/config_2009-12-31-23-17-51.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5/config_2009-12-31-23-01-52.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/50/config_2010-01-01-05-34-05.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6.5/config_2009-12-31-23-51-41.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6/config_2009-12-31-23-40-15.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/60/config_2010-01-01-05-45-25.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7.5/config_2010-01-01-00-20-49.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7/config_2010-01-01-00-04-23.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70/config_2009-12-31-19-39-31.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70_0/config_2009-12-31-19-24-09.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8.5/config_2010-01-01-01-28-40.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8/config_2010-01-01-01-15-17.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9.5/config_2010-01-01-01-50-41.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9/config_2010-01-01-01-39-26.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/0.5/waveform_2014-12-20-11-22_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/1.5/waveform_2014-12-20-11-52_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/1/waveform_2014-12-20-11-41_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/10/waveform_2014-12-20-17-06_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/11/waveform_2014-12-20-17-24_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/12/waveform_2014-12-20-17-34_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/13/waveform_2014-12-20-17-49_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/14/waveform_2014-12-20-18-02_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/15/waveform_2014-12-20-18-17_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2.5/waveform_2014-12-20-12-43_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2/waveform_2014-12-20-12-32_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/20/waveform_2014-12-20-18-29_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/25/waveform_2014-12-20-18-41_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3.5/waveform_2014-12-20-13-28_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3/waveform_2014-12-20-12-55_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/30/waveform_2014-12-20-18-56_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/35/waveform_2014-12-20-19-15_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4.5/waveform_2014-12-20-13-52_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4/waveform_2014-12-20-13-39_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/40/waveform_2014-12-20-20-30_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5.5/waveform_2014-12-20-14-25_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5/waveform_2014-12-20-14-04_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/50/waveform_2014-12-20-20-41_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6.5/waveform_2014-12-20-15-00_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6/waveform_2014-12-20-14-48_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/60/waveform_2014-12-20-20-53_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7.5/waveform_2014-12-20-15-29_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7/waveform_2014-12-20-15-12_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/70/waveform_2014-12-20-10-41_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/70_0/waveform_2014-12-20-10-26_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8.5/waveform_2014-12-20-16-30_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8/waveform_2014-12-20-16-17_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9.5/waveform_2014-12-20-16-52_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9/waveform_2014-12-20-16-41_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/0.5/waveform_2014-12-20-11-22_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/1.5/waveform_2014-12-20-11-52_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/1/waveform_2014-12-20-11-41_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/10/waveform_2014-12-20-17-06_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/11/waveform_2014-12-20-17-24_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/12/waveform_2014-12-20-17-34_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/13/waveform_2014-12-20-17-49_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/14/waveform_2014-12-20-18-02_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/15/waveform_2014-12-20-18-17_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2.5/waveform_2014-12-20-12-43_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2/waveform_2014-12-20-12-32_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/20/waveform_2014-12-20-18-29_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/25/waveform_2014-12-20-18-41_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3.5/waveform_2014-12-20-13-28_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3/waveform_2014-12-20-12-55_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/30/waveform_2014-12-20-18-56_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/35/waveform_2014-12-20-19-15_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4.5/waveform_2014-12-20-13-52_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4/waveform_2014-12-20-13-39_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/40/waveform_2014-12-20-20-30_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5.5/waveform_2014-12-20-14-25_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5/waveform_2014-12-20-14-04_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/50/waveform_2014-12-20-20-41_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6.5/waveform_2014-12-20-15-00_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6/waveform_2014-12-20-14-48_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/60/waveform_2014-12-20-20-53_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7.5/waveform_2014-12-20-15-29_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7/waveform_2014-12-20-15-12_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/70/waveform_2014-12-20-10-41_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/70_0/waveform_2014-12-20-10-26_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8.5/waveform_2014-12-20-16-30_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8/waveform_2014-12-20-16-17_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9.5/waveform_2014-12-20-16-52_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9/waveform_2014-12-20-16-41_1548_cube.img" \
)

WL=( \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
)

WLLABEL=( \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
)

INSHEIGHTS=( \
  1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 \
  1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 1.065 \
)

module purge
module load envi/4.8

# give the path to your idl .pro files
# IDL_PATH=~/Programs/DWEL2.0

# cd $IDL_PATH

# use which idl to find the path to your current idl
# explicitly give a preference file to IDL startup option
#PREF='/usr3/graduate/zhanli86/Programs/DWEL2.0/dwel2.0_idl.pref'
IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"

# add the path to your program to the IDL environment variable
# $IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

# dwel_hdf2cube_cmd_nsf, DWEL_H5File, Config_File, DataCube_File, Wavelength, Wavelength_Label, DWEL_Height, beam_div, srate, err_flag, nadirshift=nadirelevshift
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="ancillary_at_project.img"
ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$ANCFILENAME', '$ANCATPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="ancillary_hs_project.img"
ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$ANCFILENAME', '$ANCHSPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="bsfix.img"
BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_baseline_sat_fix_cmd_nsf, DWELCubeFile, ancillaryfile_name, out_satfix_name, Casing_Range, get_info_stats, zen_tweak, err
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_baseline_sat_fix_cmd_nsf, '${CUBEFILES[$SGE_TASK_ID-1]}', '$ANCFILENAME', '$BSFIXFILENAME', [170, 180], 1, 0, err_flag"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pulsexc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag"

EXTENSION="bsfix_pulsexc_update.img"
XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pulsexc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_atp.img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_cube2at_nsf, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, 2.0, 0, err_flag, Overlap=1.0"

EXTENSION="bsfix_pxc_update_atp_extrainfo.img"
ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_atp_sievefac8_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sievefac:8}"

EXTENSION="bsfix_pxc_update_atp_sievefac2_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sievefac:2}"

# EXTENSION="bsfix_pulsexc_update_ancillary_atp4.img"
# ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$XCUPDATEANCFILENAME', '$ANCATPROJFILENAME', 117, 4.0, 0, err_flag"

# EXTENSION="bsfix_pulsexc_update_ancillary_hsp4.img"
# ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$XCUPDATEANCFILENAME', '$ANCHSPROJFILENAME', 117, 4.0, 0, err_flag"

wait