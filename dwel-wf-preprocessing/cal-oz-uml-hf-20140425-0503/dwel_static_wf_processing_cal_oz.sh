#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=2
#$ -l h_rt=48:00:00
#$ -l cpu_type=E5-2650v2
#$ -N dwel-static-wf-processing-cal-oz
#$ -V
#$ -m ae
#$ -t 1-76

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/0_5/waveform_2014-04-25-17-44.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1/waveform_2014-04-25-17-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/10/waveform_2014-04-25-16-48.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/11/waveform_2014-04-25-16-45.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/12/waveform_2014-04-25-16-42.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/13/waveform_2014-04-25-16-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/14/waveform_2014-04-25-16-33.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/15/waveform_2014-04-25-16-31.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1_5/waveform_2014-04-25-17-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2/waveform_2014-04-25-17-37.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/20/waveform_2014-04-25-16-27.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/25/waveform_2014-04-25-16-24.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2_5/waveform_2014-04-25-17-34.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3/waveform_2014-04-25-17-32.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/30/waveform_2014-04-25-16-20.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/35/waveform_2014-04-25-16-16.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3_5/waveform_2014-04-25-17-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4/waveform_2014-04-25-17-27.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/40/waveform_2014-04-25-16-13.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4_5/waveform_2014-04-25-17-25.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5/waveform_2014-04-25-17-20.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/50/waveform_2014-04-25-16-09.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5_5/waveform_2014-04-25-17-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6/waveform_2014-04-25-17-15.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/60/waveform_2014-04-25-16-06.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6_5/waveform_2014-04-25-17-11.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/waveform_2014-04-25-17-08.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/70/waveform_2014-04-25-16-01.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7_5/waveform_2014-04-25-17-05.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8/waveform_2014-04-25-16-58.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8_5/waveform_2014-04-25-16-56.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9/waveform_2014-04-25-16-53.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9_5/waveform_2014-04-25-16-51.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/50/waveform_2014-05-03-12-19.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/60/waveform_2014-05-03-12-14.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/70/waveform_2014-05-03-12-00.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/80/waveform_2014-05-03-11-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/85/waveform_2014-05-03-11-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/0_5/waveform_2014-04-25-17-44.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1/waveform_2014-04-25-17-41.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/10/waveform_2014-04-25-16-48.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/11/waveform_2014-04-25-16-45.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/12/waveform_2014-04-25-16-42.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/13/waveform_2014-04-25-16-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/14/waveform_2014-04-25-16-33.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/15/waveform_2014-04-25-16-31.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1_5/waveform_2014-04-25-17-39.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2/waveform_2014-04-25-17-37.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/20/waveform_2014-04-25-16-27.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/25/waveform_2014-04-25-16-24.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2_5/waveform_2014-04-25-17-34.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3/waveform_2014-04-25-17-32.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/30/waveform_2014-04-25-16-20.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/35/waveform_2014-04-25-16-16.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3_5/waveform_2014-04-25-17-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4/waveform_2014-04-25-17-27.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/40/waveform_2014-04-25-16-13.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4_5/waveform_2014-04-25-17-25.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5/waveform_2014-04-25-17-20.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/50/waveform_2014-04-25-16-09.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5_5/waveform_2014-04-25-17-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6/waveform_2014-04-25-17-15.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/60/waveform_2014-04-25-16-06.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6_5/waveform_2014-04-25-17-11.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/waveform_2014-04-25-17-08.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/70/waveform_2014-04-25-16-01.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7_5/waveform_2014-04-25-17-05.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8/waveform_2014-04-25-16-58.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8_5/waveform_2014-04-25-16-56.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9/waveform_2014-04-25-16-53.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9_5/waveform_2014-04-25-16-51.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/50/waveform_2014-05-03-12-19.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/60/waveform_2014-05-03-12-14.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/70/waveform_2014-05-03-12-00.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/80/waveform_2014-05-03-11-17.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/85/waveform_2014-05-03-11-39.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/0_5/config_2014-04-25-08-50-02.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1/config_2014-04-25-08-47-45.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/10/config_2014-04-25-07-53-16.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/11/config_2014-04-25-07-51-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/12/config_2014-04-25-07-48-36.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/13/config_2014-04-25-07-43-19.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/14/config_2014-04-25-07-39-34.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/15/config_2014-04-25-07-37-50.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1_5/config_2014-04-25-08-45-58.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2/config_2014-04-25-08-42-55.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/20/config_2014-04-25-07-34-04.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/25/config_2014-04-25-07-30-57.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2_5/config_2014-04-25-08-40-23.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3/config_2014-04-25-08-38-44.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/30/config_2014-04-25-07-27-16.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/35/config_2014-04-25-07-23-03.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3_5/config_2014-04-25-08-36-16.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4/config_2014-04-25-08-34-07.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/40/config_2014-04-25-07-19-35.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4_5/config_2014-04-25-08-29-10.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5/config_2014-04-25-08-26-30.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/50/config_2014-04-25-07-16-02.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5_5/config_2014-04-25-08-23-39.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6/config_2014-04-25-08-21-57.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/60/config_2014-04-25-07-12-34.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6_5/config_2014-04-25-08-16-47.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/config_2014-04-25-08-13-45.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/70/config_2014-04-25-07-08-04.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7_5/config_2014-04-25-08-07-44.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8/config_2014-04-25-08-04-11.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8_5/config_2014-04-25-08-01-58.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9/config_2014-04-25-08-00-02.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9_5/config_2014-04-25-07-57-27.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/50/config_2014-05-03-03-26-42.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/60/config_2014-05-03-03-21-45.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/70/config_2014-05-03-03-07-03.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/80/config_2014-05-03-02-24-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/85/config_2014-05-03-02-46-51.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/0_5/config_2014-04-25-08-50-02.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1/config_2014-04-25-08-47-45.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/10/config_2014-04-25-07-53-16.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/11/config_2014-04-25-07-51-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/12/config_2014-04-25-07-48-36.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/13/config_2014-04-25-07-43-19.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/14/config_2014-04-25-07-39-34.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/15/config_2014-04-25-07-37-50.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1_5/config_2014-04-25-08-45-58.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2/config_2014-04-25-08-42-55.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/20/config_2014-04-25-07-34-04.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/25/config_2014-04-25-07-30-57.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2_5/config_2014-04-25-08-40-23.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3/config_2014-04-25-08-38-44.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/30/config_2014-04-25-07-27-16.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/35/config_2014-04-25-07-23-03.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3_5/config_2014-04-25-08-36-16.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4/config_2014-04-25-08-34-07.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/40/config_2014-04-25-07-19-35.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4_5/config_2014-04-25-08-29-10.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5/config_2014-04-25-08-26-30.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/50/config_2014-04-25-07-16-02.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5_5/config_2014-04-25-08-23-39.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6/config_2014-04-25-08-21-57.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/60/config_2014-04-25-07-12-34.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6_5/config_2014-04-25-08-16-47.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/config_2014-04-25-08-13-45.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/70/config_2014-04-25-07-08-04.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7_5/config_2014-04-25-08-07-44.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8/config_2014-04-25-08-04-11.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8_5/config_2014-04-25-08-01-58.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9/config_2014-04-25-08-00-02.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9_5/config_2014-04-25-07-57-27.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/50/config_2014-05-03-03-26-42.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/60/config_2014-05-03-03-21-45.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/70/config_2014-05-03-03-07-03.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/80/config_2014-05-03-02-24-28.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/85/config_2014-05-03-02-46-51.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/0_5/cal_oz_20140425_0_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/1/cal_oz_20140425_1_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/10/cal_oz_20140425_10_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/11/cal_oz_20140425_11_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/12/cal_oz_20140425_12_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/13/cal_oz_20140425_13_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/14/cal_oz_20140425_14_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/15/cal_oz_20140425_15_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/1_5/cal_oz_20140425_1_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/2/cal_oz_20140425_2_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/20/cal_oz_20140425_20_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/25/cal_oz_20140425_25_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/2_5/cal_oz_20140425_2_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/3/cal_oz_20140425_3_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/30/cal_oz_20140425_30_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/35/cal_oz_20140425_35_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/3_5/cal_oz_20140425_3_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/4/cal_oz_20140425_4_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/40/cal_oz_20140425_40_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/4_5/cal_oz_20140425_4_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/5/cal_oz_20140425_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/50/cal_oz_20140425_50_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/5_5/cal_oz_20140425_5_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/6/cal_oz_20140425_6_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/60/cal_oz_20140425_60_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/6_5/cal_oz_20140425_6_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/7/cal_oz_20140425_7_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/70/cal_oz_20140425_70_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/7_5/cal_oz_20140425_7_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/8/cal_oz_20140425_8_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/8_5/cal_oz_20140425_8_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/9/cal_oz_20140425_9_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/9_5/cal_oz_20140425_9_5_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/50/cal_oz_20140503_50_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/60/cal_oz_20140503_60_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/70/cal_oz_20140503_70_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/80/cal_oz_20140503_80_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/85/cal_oz_20140503_85_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/0_5/cal_oz_20140425_0_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/1/cal_oz_20140425_1_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/10/cal_oz_20140425_10_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/11/cal_oz_20140425_11_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/12/cal_oz_20140425_12_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/13/cal_oz_20140425_13_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/14/cal_oz_20140425_14_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/15/cal_oz_20140425_15_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/1_5/cal_oz_20140425_1_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/2/cal_oz_20140425_2_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/20/cal_oz_20140425_20_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/25/cal_oz_20140425_25_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/2_5/cal_oz_20140425_2_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/3/cal_oz_20140425_3_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/30/cal_oz_20140425_30_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/35/cal_oz_20140425_35_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/3_5/cal_oz_20140425_3_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/4/cal_oz_20140425_4_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/40/cal_oz_20140425_40_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/4_5/cal_oz_20140425_4_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/5/cal_oz_20140425_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/50/cal_oz_20140425_50_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/5_5/cal_oz_20140425_5_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/6/cal_oz_20140425_6_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/60/cal_oz_20140425_60_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/6_5/cal_oz_20140425_6_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/7/cal_oz_20140425_7_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/70/cal_oz_20140425_70_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/7_5/cal_oz_20140425_7_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/8/cal_oz_20140425_8_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/8_5/cal_oz_20140425_8_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/9/cal_oz_20140425_9_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/9_5/cal_oz_20140425_9_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/50/cal_oz_20140503_50_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/60/cal_oz_20140503_60_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/70/cal_oz_20140503_70_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/80/cal_oz_20140503_80_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/Calibration_OzDWEL_HF_20140503/85/cal_oz_20140503_85_1548_cube.img" \
)

RANGES=( \
 0.5 \
 1 \
 10 \
 11 \
 12 \
 13 \
 14 \
 15 \
 1.5 \
 2 \
 20 \
 25 \
 2.5 \
 3 \
 30 \
 35 \
 3.5 \
 4 \
 40 \
 4.5 \
 5 \
 50 \
 5.5 \
 6 \
 60 \
 6.5 \
 7 \
 70 \
 7.5 \
 8 \
 8.5 \
 9 \
 9.5 \
 50 \
 60 \
 70 \
 80 \
 85 \
 0.5 \
 1 \
 10 \
 11 \
 12 \
 13 \
 14 \
 15 \
 1.5 \
 2 \
 20 \
 25 \
 2.5 \
 3 \
 30 \
 35 \
 3.5 \
 4 \
 40 \
 4.5 \
 5 \
 50 \
 5.5 \
 6 \
 60 \
 6.5 \
 7 \
 70 \
 7.5 \
 8 \
 8.5 \
 9 \
 9.5 \
 50 \
 60 \
 70 \
 80 \
 85 \
)

WL=( \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
)

WLLABEL=( \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
)

module purge
module load envi/4.8

IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_static_hdf2cube, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '$FILENAME', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, 0.0, 2.5, 2.0"

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix.img"
BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_static_wire_baseline_sat_fix_cmd_nsf, '$FILENAME', '$ANCFILENAME', '$BSFIXFILENAME', 1, 0, err_flag, ${RANGES[$SGE_TASK_ID-1]}, settings={out_of_pulse:500}"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_static_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, ${RANGES[$SGE_TASK_ID-1]}"

EXTENSION="bsfix_pxc_update.img"
XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:2, sievefac:2, dwel_az_n:0, save_zero_hits:0, cal_dat:0}"

# clean point cloud from DWEL program and summarize panel returns
# path to the Matlab scripts and functions
BASEDIR="/usr3/graduate/zhanli86/Programs/DWEL2.0/dwel_static_scans"
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

OUTPANELDIR="/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/cal-oz-uml-hf-20140425-0503-panel-return-summary"

EXTENSION="bsfix_pxc_update_ptcl_points.txt"
POINTSFILENAME=${BASEFILENAME}_${EXTENSION}
ONLYFILENAME=$(echo $BASEFILENAME | sed 's:/[^ ]*/::g')
EXTENSION="bsfix_pxc_update_ptcl_points_panel_returns.txt"
PANELFILENAME=${ONLYFILENAME}_${EXTENSION}
$ML "addpath(genpath('$BASEDIR')); inptclfile = '$POINTSFILENAME'; outpanelreturnsfile = fullfile('$OUTPANELDIR', '$PANELFILENAME'); satinfofile = '$XCUPDATEANCFILENAME'; panelrange = ${RANGES[$SGE_TASK_ID-1]}; run dwel_ptcl_to_panel_returns"

wait